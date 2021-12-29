//
//  SessionDataHandler.swift
//  FormulaTelemetry
//
//  Created by Erik Hatfield on 11/30/21.
//

import Foundation
import Combine
import F12020TelemetryPackets

class SessionDataHandler: ObservableObject {
    @Published var trackName: String = ""
    @Published var sessionType: String = ""
    @Published var lastSessionData: SessionDataPacket?
    @Published var sessionData: SessionData = SessionData()
    
    private var cancellable: AnyCancellable?
    
    deinit {
        cancellable?.cancel()
    }
    
    init(_ pub: PassthroughSubject<SessionDataPacket?, Never>) {
        self.cancellable = pub
            .receive(on: RunLoop.main)
            .compactMap({$0})
            .sink(receiveValue: { [weak self] in
                self?.handlePacket($0)
            })
    }
    
    func handlePacket(_ packet: SessionDataPacket) {
        self.lastSessionData = packet
        //print("session data ", packet)
        let trackName = TrackIDs[packet.trackId] ?? ""
        
        self.trackName = trackName
        let sessionData = SessionData(from: packet)
        self.sessionData = sessionData
        //let sessionType = SessionType(value1: packet.sessionType)
        //print("sessionType ", sessionType)
    }
}
