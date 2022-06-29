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
}

class DataCollectionHandler: ObservableObject {
    @Published var receivedData: [ByteBuffer] = []
    @Published var count: Int = 0
    
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
        
        
//        let dataObjects = self.receivedData.compactMap({ byteBuffer -> Data? in
//            var bufferCopy = byteBuffer
//            guard let byteArray = bufferCopy.readBytes(length: bufferCopy.readableBytes) else {
//                print("couldnt unpack")
//                return nil
//            }
//
//            return Data(byteArray)
//        })
//
//        do {
//
//        } catch let err {
//            print("Save error ", err)
//        }
//        print("saving to ", dataUrl)
        
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
}


extension FileManager {
    static func documentsDirectoryURL() -> URL {
        let paths = self.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
