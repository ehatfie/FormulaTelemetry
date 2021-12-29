//
//  MotionDataHandler.swift
//  FormulaTelemetry
//
//  Created by Erik Hatfield on 12/9/21.
//

import Foundation
import Combine
import F12020TelemetryPackets

struct Position {
    let worldPosX: Float
    let worldPosY: Float
    let worldPosZ: Float
    
    init(data: CarMotionData) {
        worldPosX = data.worldPositionX
        worldPosY = data.worldPositionY
        worldPosZ = data.worldPositionZ
    }
    
    init() {
        worldPosX = 0
        worldPosY = 0
        worldPosZ = 0
    }
}

class MotionDataHandler: ObservableObject {
    @Published var motionData = CarMotionData()
    @Published var position = Position()
    
    private var cancellable: AnyCancellable? // make generic
    
    deinit {
        cancellable?.cancel()
    }
    
    init(_ pub: PassthroughSubject<MotionDataPacket?, Never>) {
        self.cancellable = pub
            .receive(on: RunLoop.main)
            .compactMap({$0})
            .sink(receiveValue: handlePacket)
    }
    
    func handlePacket(_ packet: MotionDataPacket) {
        guard let motionData = packet.carMotionData.first else {
            print("no motion data ", packet)
            return
        }
        
        self.position = Position(data: motionData)
        self.motionData = motionData
    }
}
