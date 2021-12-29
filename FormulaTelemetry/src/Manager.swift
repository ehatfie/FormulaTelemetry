//
//  Manager.swift
//  FormulaTelemetry
//
//  Created by Erik Hatfield on 11/10/21.
//

import Foundation
import NIO
import SwiftUI
import Combine
import F12020TelemetryPackets

/**
 We will want the Manager (rename) to be the data source for the SwiftUI View so there will be @Published variables for everything we want to display
 Alternatively SwiftUI components will use @Environment variables
 
 Data Points:
 lap number
 position
 duration
 fastest lap
 track name
 
 */
class Manager: ObservableObject {
    @Published var isConnected = false
    @Published var trackName = ""
    @ObservedObject var client = UDPClient()
    
    @ObservedObject var lapDataHandler: LapDataHandler
    @ObservedObject var sessionDataHandler: SessionDataHandler
    @ObservedObject var motionDataHandler: MotionDataHandler
    @ObservedObject var telemetryDataHandler: TelemetryDataHandler
    
    var handler = UDPHandler()
    
    init() {
        let lapDataSub = Subscribers.Sink<LapDataPacket, Never>(
            receiveCompletion: { completion in
                print("complete: \(completion)")
            }, receiveValue: { packet in
                //print("packet \(packet)")
            })
        
        let carSetupsSub = Subscribers.Sink<CarSetupPacket, Never>(
            receiveCompletion: { completion in
                print(completion)
            }) { value in
                
                //print(value)
            }
        
        let carTelemetrySub = Subscribers.Sink<CarTelemetryDataPacket, Never>(
            receiveCompletion: { completion in
                print(completion)
            }) { value in
                
                //print(value)
            }
        
        let sessionDataSub = Subscribers.Sink<SessionDataPacket, Never>(
            receiveCompletion: { completion in
                print("session data receive ", completion)
            }, receiveValue: { packet in
                print("packet ", packet)
                
            }
        )
        
        self.lapDataHandler = LapDataHandler(handler.lapDataPublisher)
        self.sessionDataHandler = SessionDataHandler(handler.sessionDataPublisher)
        self.motionDataHandler = MotionDataHandler(handler.motionDataPublisher)
        self.telemetryDataHandler = TelemetryDataHandler(handler.carTelemetryPublisher)
        
        handler.lapDataPublisher
            .receive(on: RunLoop.main)
            .compactMap({$0})
            .subscribe(lapDataSub)
        
        handler.carSetupsPublisher
            .receive(on: RunLoop.main)
            .compactMap({$0})
            .subscribe(carSetupsSub)
        
        handler.carTelemetryPublisher
            .receive(on: RunLoop.main)
            .compactMap({$0})
            .subscribe(carTelemetrySub)
        
        handler.carTelemetryPublisher
            .receive(on: RunLoop.main)
            .compactMap({$0})
            .subscribe(carTelemetrySub)
        
//        handler.sessionDataPublisher
//            .receive(on: RunLoop.main)
//            .compactMap({$0})
//            .subscribe(sessionDataSub)
            
        
        client.$isConnected.assign(to: &$isConnected)
        sessionDataHandler.$trackName.assign(to: &$trackName)
    }
    
    func start() {
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.client.start(handler: strongSelf.handler)
        }
    }
    
}


