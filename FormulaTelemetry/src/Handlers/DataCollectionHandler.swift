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
}
