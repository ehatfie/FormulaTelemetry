//
//  LapTelemetryData.swift
//  FormulaTelemetry
//
//  Created by Erik Hatfield on 6/26/22.
//

import Foundation
import F12020TelemetryPackets

protocol LapTelemetryDataInterface {
    var lapNumber: Int { get }
    var telemetryPackets: [CarTelemetryDataPacket] { get set }
}

/**
 Want to collect all the telemetry packets for the lap
*/
class LapTelemetryData: LapTelemetryDataInterface {
    var lapNumber: Int
    // other correlating info?
    var telemetryPackets: [CarTelemetryDataPacket]
    
    init(lapNumber: Int) {
        self.lapNumber = lapNumber
        self.telemetryPackets = []
    }
    
    func receivedNewPacket(data: CarTelemetryDataPacket) {
        self.telemetryPackets.append(data)
    }
}
