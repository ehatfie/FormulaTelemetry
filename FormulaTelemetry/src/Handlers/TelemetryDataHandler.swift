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

class TelemetryDataHandler: TelemetryDataHandlerInterface {
    typealias DataPacket = CarTelemetryDataPacket
    
    @Published var playerTelemetryDatas = [CarTelemetryData]()
    @Published var lastTelemetryData: CarTelemetryData = CarTelemetryData()
    @Published var telemetryDataPackets = [CarTelemetryDataPacket]()
    
    var playerTelemetryDataPublished: Published<[CarTelemetryData]> { _playerTelemetryDatas }
    var playerTelemetryDataPublisher: Published<[CarTelemetryData]>.Publisher { $playerTelemetryDatas }
    
    var lastTelemetryDataPublished: Published<CarTelemetryData> { _lastTelemetryData }
    var lastTelemetryDataPublisher: Published<CarTelemetryData>.Publisher { $lastTelemetryData }
    
    var telemetryDataPublished: Published<[CarTelemetryDataPacket]> { _telemetryDataPackets }
    var telemetryDataPublisher: Published<[CarTelemetryDataPacket]>.Publisher { $telemetryDataPackets }
    
    var cancellable: AnyCancellable?
    
    required init(_ pub: PassthroughSubject<CarTelemetryDataPacket?, Never>) {
        setup(pub)
    }
    
    func handleDataPacket(packet: CarTelemetryDataPacket) {
        self.telemetryDataPackets.append(packet)
        
        guard let playerTelemetryData = packet.carTelemetryData.first else {
            print("WARN - no player telemetry data")
            return
        }
        
        self.lastTelemetryData = playerTelemetryData
        self.playerTelemetryDatas.append(playerTelemetryData)
    }
}
