//
//  LapDataHandler.swift
//  FormulaTelemetry
//
//  Created by Erik Hatfield on 11/12/21.
//

import Foundation
import Combine
import F12020TelemetryPackets

/**
 If this is going to be what tracks everything over a lap then we need to store all the packets we want here also
 create new "Lap" objects, would this be core data?, lap object will contain all the packets that happened over that lap
  Lap
 - sector times
 - total time
 - telemetry inputs
 - lap number
 */

class LapDataHandler: ObservableObject {
    @Published var lastLapData: LapDataInner?
    @Published var laps = [LapSummary]()
    @Published var lapDataPackets = [LapDataInner]()
    
    private var cancellable: AnyCancellable?
    
    var subscriber = ""
    
    deinit {
        cancellable?.cancel()
    }
    
    init(_ pub: PassthroughSubject<LapDataPacket?, Never>) {
        self.cancellable = pub.compactMap({$0})
            .sink(receiveValue: handleLapDataPacket(packet:))
    }
    
    func handleLapDataPacket(packet: LapDataPacket) {
        guard let userLap =  packet.lapData.first else {
            return
        }
        checkNewLap(newLapData: userLap)
        //print("lap data ", userLap)
        lapDataPackets.append(userLap)
        lastLapData = userLap
    }
    
    func checkNewLap(newLapData: LapDataInner) {
        guard let lastLapData = self.lastLapData else {
            return
        }
        
        if newLapData.currentLapNum > lastLapData.currentLapNum {
            print("new lap \(newLapData)")
        }
        let summary = LapSummary(data: newLapData)
        self.laps.append(summary)
        print("lap summary ", summary.lapNumber)
        // what do we want to do if its a new lap
        // create some sort of lap summary object
    }
}

// should we just store the LapDataInner??
class LapSummary {
    let lapNumber: Int
    let times: LapTimes
    
    init(data: LapDataInner) {
        self.lapNumber = data.currentLapNum
        self.times = LapTimes(from: data)
    }
}

class LapTimes {
    let lapTime: Float
    
    init(from data: LapDataInner) {
        print("last lap time ", data.lastLapTime)
        print("current lap time ", data.currentLapTime)
        lapTime = 0.0
    }
}
