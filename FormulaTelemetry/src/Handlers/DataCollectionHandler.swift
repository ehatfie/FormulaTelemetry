//
//  DataCollectionHandler.swift
//  FormulaTelemetry
//
//  Created by Erik Hatfield on 6/28/22.
//

import SwiftUI
import Combine
import NIOCore
import F12020TelemetryPackets

protocol DataCollectionHandlerInterface: ObservableObject {
    var cancellable: AnyCancellable? { get set }
    
    func printPackets()
    func saveToUserDefaults()
    func loadFromUserDefaults()
    func getBuffersAsData() -> [Data]
}

class DataCollectionHandler: ObservableObject {
    @Published var receivedData: [ByteBuffer] = []
    @Published var count: Int = 0
    
    var sessionData: SessionData? = nil
    
    let key = "TEST_KEY"
    
    var cancellable: AnyCancellable?
    
    deinit {
        self.cancellable?.cancel()
        self.cancellable = nil
    }
    
    init(pub: PassthroughSubject<ByteBuffer, Never>) {
        self.cancellable = pub
            .receive(on: RunLoop.current)
            .sink(receiveValue: didReceiveData(_:))
        
        
    }
    
    func didReceiveData(_ buffer: ByteBuffer) {
        self.receivedData += [buffer]
        self.count = receivedData.count
//        DispatchQueue.global().async { [weak self] in
//            self?.receivedData += [buffer]
//            //self?.count += 1
//            print("did receive data \(self!.count)")
//        }
    }
    
    func printPackets() {
        for buffer in receivedData {
            var buf = buffer
            guard let header = PacketHeader(data: &buf) else {
                print("no header")
                continue
            }
            guard let packetType = PacketType(rawValue: header.packetId) else {
                print("Couldnt create PacketType for ", header.packetId)
                continue
            }
            
            print("packetId ", packetType.shortDescription)
            
        }
    }
    
    func savePackets() {
        guard !self.receivedData.isEmpty else {
            return
        }
        
        let dataUrl = URL(fileURLWithPath: "testData", relativeTo: FileManager.documentsDirectoryURL())
        let foo = self.receivedData.compactMap({ byteBuffer -> [UInt8]? in
            var bufferCopy = byteBuffer
            return bufferCopy.readBytes(length: bufferCopy.readableBytes)
        })
        
       saveToUserDefaults(data: foo)
    }
    
    func saveToUserDefaults(data: [[UInt8]]) {
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(data, forKey: key)
        
        guard let foo = userDefaults.value(forKey: key) as? [[UInt8]] else {
            print("couldnt get saved data")
            return
        }
        print("got foo", foo.count)
    }
    
    func loadFromUserDefaults() {
        let userDefaults = UserDefaults.standard
        guard let foo = userDefaults.value(forKey: key) as? [[UInt8]] else {
            print("couldnt get saved data")
            return
        }
        let byteBuffers = foo.map({ bytes in
            return ByteBuffer(bytes: bytes)
        })
        
        self.receivedData = byteBuffers
        self.count = receivedData.count
        print("byteBuffer count ", byteBuffers.count)
    }
    
    func getBuffersAsData() -> [Data] {
        return convertToData(buffers: self.receivedData)
    }
    
    // TODO: this can go into a helper class
    private func convertToData(buffers: [ByteBuffer]) -> [Data] {
        return buffers
            .compactMap({ byteBuffer -> [UInt8]? in
                var bufferCopy = byteBuffer
                return bufferCopy.readBytes(length: bufferCopy.readableBytes)
            }).map{ Data($0 )}
    }
}


extension FileManager {
    static func documentsDirectoryURL() -> URL {
        let paths = self.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
