//
//  DefaultDataCollectionViewModel.swift
//  FormulaTelemetry
//
//  Created by Erik Hatfield on 6/28/22.
//

import SwiftUI
import Combine
import NIOCore
import F12020TelemetryPackets

protocol DefaultDataCollectionViewModelInterface: ObservableObject {
    var udpHandler: UDPHandler { get set }
    
    func startRecording()
    func stopRecording()
    func saveRecording()
    func deleteRecording()
    func printPackets()
    func clearLocalData()
    func getBuffersAsData() -> [Data]
}
/*
    This should start/stop collection
    display some information about the collection
 */
class DefaultDataCollectionViewModel: DefaultDataCollectionViewModelInterface {
    @ObservedObject var client = UDPClient()
    
    @ObservedObject var dataCollectionHandler: DataCollectionHandler
    
    @Published var test: Int = 0
    
    var dispatchQueue: DispatchQueue?
    
    var udpHandler: UDPHandler = UDPHandler()
    
    var cancell: Cancellable?
    
    @ObservedObject var persistenceController: PersistenceController1
    
    init(pc: PersistenceController1) {
        self.persistenceController = pc
        self.dataCollectionHandler = DataCollectionHandler(pub: udpHandler.dataPublisher)

        dataCollectionHandler.$count.assign(to: &$test)
    }
    
    func buttonOnPress(action: DefaultDataCollectionAction) {
        switch action {
        case .startRecording: startRecording()
        case .stopRecording: stopRecording()
        case .deleteRecording: deleteRecording()
        case .saveRecording: saveRecording()
        case .printPackets: printPackets()
        case .loadData: loadData()
        case .clearLocalData: clearLocalData()
        }
    }
    
    func startRecording() {
        print("Start Recording")

        let dispatchQueue = DispatchQueue(label: "test")
        self.dispatchQueue = dispatchQueue
        
        dispatchQueue.async { [ weak self] in
            guard let self = self else {
                return
            }
            self.client.start(handler: self.udpHandler)
        }
        
       // self.client.start(handler: self.udpHandler)
    }
    
    func stopRecording() {
        print("Stop Recording")
        self.client.stop()
    }
    
    func saveRecording() {
        print("Save Recording")
        //self.dataCollectionHandler.count += 1
        self.dataCollectionHandler.savePackets()
        let foo = self.dataCollectionHandler.getBuffersAsData()
        let packetEntries = self.createPackets(from: foo)
        
        self.persistenceController.addData(dataToSave: packetEntries)
    }
    
    func deleteRecording() {
        print("Delete Recording")
    }
    
    func printPackets() {
        self.dataCollectionHandler.printPackets()
    }
    
    func loadData() {
        self.dataCollectionHandler.loadFromUserDefaults()
    }
    
    func clearLocalData() {
        self.persistenceController.deleteLocalData()

    }
    
    func getBuffersAsData() -> [Data] {
        return []
    }
}

//TODO: these functions should be moved
extension DefaultDataCollectionViewModel {
    func convertToData(buffers: [ByteBuffer]) -> [Data] {
        return buffers
            .compactMap({ byteBuffer -> [UInt8]? in
                var bufferCopy = byteBuffer
                return bufferCopy.readBytes(length: bufferCopy.readableBytes)
            }).map{ Data($0 )}
    }
    
    func convertBufferToData(buffer: ByteBuffer) -> Data? {
        var bufferCopy = buffer
        guard let bytes = bufferCopy.readBytes(length: bufferCopy.readableBytes) else { return nil }
        return Data(bytes)
    }
    
    func createPackets(from data: [Data]) -> [PacketEntry] {
        let buffers = data.map{ ByteBuffer(bytes: $0) }
        
        let packetEntries = buffers.compactMap({ buffer -> PacketEntry? in
            var bufferCopy = buffer
            
            guard let header = PacketHeader(data: &bufferCopy),
                  let data = convertBufferToData(buffer: bufferCopy) else { return nil }
            
            let packetEntry = PacketEntry(header: header, data: data)
            return packetEntry
        })
        
        return packetEntries
    }
}


struct PacketEntry {
    let header: PacketHeader
    let data: Data
    
    init(header: PacketHeader, data: Data) {
        self.header = header
        self.data = data
    }
    
}
