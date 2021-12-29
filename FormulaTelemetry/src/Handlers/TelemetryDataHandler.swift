//
//  CarTelemetryDataHandler.swift
//  FormulaTelemetry
//
//  Created by Erik Hatfield on 12/29/21.
//

import Foundation
import Combine
import F12020TelemetryPackets

class TelemetryData {
    let inputs = TelemetryInputs()
}

class TelemetryInputs {
    let throttle: Float
    let steer: Float
    let brake: Float
    let clutch: Int
    let gear: Int
    
    init() {
        self.throttle = 0.0
        self.steer = 0.0
        self.brake = 0.0
        self.clutch = 0
        self.gear = 0
    }
    
    init(from data: CarTelemetryData) {
        self.throttle = data.throttle
        self.steer = data.steer
        self.brake = data.brake
        self.clutch = data.clutch
        self.gear = data.gear
    }
}

class TelemetryDataHandler: ObservableObject {
    typealias DataPacket = CarTelemetryDataPacket
    
    @Published var lastTelemetryData = CarTelemetryData()
    @Published var playerTelemetryDatas = [CarTelemetryData]()
    @Published var telemetryDataPackets = [CarTelemetryDataPacket]()
    
    private var cancellable: AnyCancellable?
    
    deinit {
        cancellable?.cancel()
    }
    
    init(_ pub: PassthroughSubject<DataPacket?, Never>) {
        self.cancellable = pub.compactMap({$0})
            .sink(receiveValue: { [weak self] in
                self?.handleDataPacket(packet: $0)
            })
    }
    
    func handleDataPacket(packet: DataPacket) {
        self.telemetryDataPackets.append(packet)
        
        guard let playerTelemetryData = packet.carTelemetryData.first else {
            print("WARN - no player telemetry data")
            return
        }
        
        self.lastTelemetryData = playerTelemetryData
        self.playerTelemetryDatas.append(playerTelemetryData)
    }
}
