//
//  TelemetryDataInterface.swift
//  FormulaTelemetry
//
//  Created by Erik Hatfield on 6/26/22.
//

import Foundation
import Combine
import F12020TelemetryPackets

protocol TelemetryDataHandlerInterface: DataHandlerInterface {
    var playerTelemetryDatas: [CarTelemetryData] { get set }
    var playerTelemetryDataPublished: Published<[CarTelemetryData]> { get }
    var playerTelemetryDataPublisher: Published<[CarTelemetryData]>.Publisher { get }
    
    var lastTelemetryData: CarTelemetryData { get set }
    var lastTelemetryDataPublished: Published<CarTelemetryData> { get }
    var lastTelemetryDataPublisher: Published<CarTelemetryData>.Publisher { get }
    
    var telemetryDataPackets: [CarTelemetryDataPacket] { get set }
    var telemetryDataPublished: Published<[CarTelemetryDataPacket]> { get }
    var telemetryDataPublisher: Published<[CarTelemetryDataPacket]>.Publisher { get }
}
