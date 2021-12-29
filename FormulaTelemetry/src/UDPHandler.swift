//
//  UDPHandler.swift
//  FormulaTelemetry
//
//  Created by Erik Hatfield on 11/10/21.
//

import Foundation
import NIO
import Combine
import F12020TelemetryPackets


/**
 Either this guy will do all the things or nearly none of the things
 Options:
 A publisher for each packet type. Then externally there could be a unique @ObserverdObject handler class for each type whith @Published properties for the values it tracks and the external manager assigns those to its correlating @Published values
    - this would let things be done async!!
 One generic publisher that either returns the header and bytes to let something external do the processing or a generic way to return the actual packet object to be re-typed on the other side
 */
class UDPHandler: ChannelInboundHandler {
    typealias InboundIn = AddressedEnvelope<ByteBuffer>
    
    var packetPublisher = PassthroughSubject<IsPacket, Never>()
    var lapDataPublisher = PassthroughSubject<LapDataPacket?, Never>()
    var carSetupsPublisher = PassthroughSubject<CarSetupPacket?, Never>()
    var carStatusPublisher = PassthroughSubject<CarStatusPacket?, Never>()
    var carTelemetryPublisher = PassthroughSubject<CarTelemetryDataPacket?, Never>()
    var eventDataPublisher = PassthroughSubject<EventDataPacket?, Never>()
    var sessionDataPublisher = PassthroughSubject<SessionDataPacket?, Never>()
    var motionDataPublisher = PassthroughSubject<MotionDataPacket?, Never>()
    
    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        let addressedEnvelope = self.unwrapInboundIn(data)
        
        var byteBuffer = addressedEnvelope.data
        
        guard let header = PacketHeader(data: &byteBuffer) else { return }
        
        let packet = PacketInfo(format: header.packetFormat, version: header.packetVersion, type: header.packetId)
        
        switch packet.packetType {
        case .LapData: lapDataPublisher.send(LapDataPacket(header: header, data: &byteBuffer))
        case .CarSetups: carSetupsPublisher.send(CarSetupPacket(header: header, data: &byteBuffer))
        case .CarStatus: carStatusPublisher.send(CarStatusPacket(header: header, data: &byteBuffer))
        case .CarTelemetry: carTelemetryPublisher.send(CarTelemetryDataPacket(header: header, data: &byteBuffer))
        case .EventData: eventDataPublisher.send(EventDataPacket(header: header, data: &byteBuffer))
        case .SessionData: sessionDataPublisher.send(SessionDataPacket(header: header, data: &byteBuffer))
        case .Motion: motionDataPublisher.send(MotionDataPacket(header: header, data: &byteBuffer))
        case .LobbyInfo:
            print("lobby info")
        case .FinalClassification:
            print("final classification")
        case .Participants:
            print("participants")
        default:
            print("packet type \(packet.packetType.shortDescription)")
        }
    }
    
    func test() {
    }
}
