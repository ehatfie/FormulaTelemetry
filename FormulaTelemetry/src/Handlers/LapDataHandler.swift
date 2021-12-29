//
//  LapDataHandler.swift
//  FormulaTelemetry
//
//  Created by Erik Hatfield on 11/12/21.
//

import Foundation
import Combine
import F12020TelemetryPackets

class LapDataHandler: ObservableObject {
    @Published var lastLapData: LapDataInner?
    @Published var lapDataPackets = [LapDataInner]()
    
    private var cancellable: AnyCancellable?
    
    var subscriber = ""
    
    deinit {
        cancellable?.cancel()
    }
    
    init(_ pub: PassthroughSubject<LapDataPacket?, Never>) {
        self.cancellable = pub.compactMap({$0})
            .sink(receiveValue: { [weak self] in
                self?.handleLapDataPacket(packet: $0)
            })
    }
    
    func handleLapDataPacket(packet: LapDataPacket) {
        guard let userLap =  packet.lapData.first else {
            return
        }
        
        lapDataPackets.append(userLap)
        lastLapData = userLap
    }
}
