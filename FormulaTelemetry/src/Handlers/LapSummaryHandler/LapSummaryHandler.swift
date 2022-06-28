//
//  LapSummaryHandler.swift
//  FormulaTelemetry
//
//  Created by Erik Hatfield on 6/26/22.
//

import Foundation
import Combine
import F12020TelemetryPackets

protocol LapSummaryHandlerInterface {
    var cancellable: AnyCancellable? { get set }
    var cancellable2: AnyCancellable? { get set }
    
    
    init(lapData: PassthroughSubject<LapDataPacket?, Never>, telemetryData: PassthroughSubject<CarTelemetryDataPacket?, Never>)
    
    func receivedLapData(packet: LapDataPacket)
    func receivedTelemetryData(packet: CarTelemetryDataPacket)
}


class LapSummaryHandler: ObservableObject, LapSummaryHandlerInterface {
    var cancellable: AnyCancellable?
    var cancellable2: AnyCancellable?
    
    var lastLapData: LapDataInner?
    var lapTelemetryData: LapTelemetryData?
    
    var lapTelemetryDataPackets = [CarTelemetryData]()
    
    // publisher for the telemetry for the lap
    
    required init(lapData: PassthroughSubject<LapDataPacket?, Never>, telemetryData: PassthroughSubject<CarTelemetryDataPacket?, Never>) {
        
        self.cancellable = lapData
            .compactMap({$0})
            .sink(receiveValue: receivedLapData(packet:))
        self.cancellable2 = telemetryData
            .compactMap({$0})
            .sink(receiveValue: receivedTelemetryData(packet:))
    }
    
    func receivedLapData(packet: LapDataPacket) {
        print("received lap data")
        
        guard let userLap =  packet.lapData.first else {
            return
        }
        
        checkNewLap(newLapData: userLap)
        //print("lap data ", userLap)
        //lapDataPackets.append(userLap)
        lastLapData = userLap
        
        if lapTelemetryData == nil {
            self.lapTelemetryData = LapTelemetryData(lapNumber: userLap.currentLapNum)
        }
    }
    
    func receivedTelemetryData(packet: CarTelemetryDataPacket) {
        print("received telemetry data")
        packet.printData()
        
        self.lapTelemetryData?.receivedNewPacket(data: packet)
    }
    
    func checkNewLap(newLapData: LapDataInner) {
        guard let lastLapData = self.lastLapData else {
            return
        }
        
        if newLapData.currentLapNum > lastLapData.currentLapNum {
            print("new lap \(newLapData)")
        }
        //let summary = LapSummary(data: newLapData)
        //self.laps.append(summary)
        //print("lap summary ", summary.lapNumber)
        // what do we want to do if its a new lap
        // create some sort of lap summary object
    }
}

extension CarTelemetryDataPacket {
    
    func printData() {
        guard let telemetryData = self.carTelemetryData.first else { return }
        
        print("throttle: \(telemetryData.throttle) brakes: \(telemetryData.brake) speed: \(telemetryData.speed)")
        
    }
}
