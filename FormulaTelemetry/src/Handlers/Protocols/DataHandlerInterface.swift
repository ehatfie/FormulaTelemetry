//
//  DataHandlerInterface.swift
//  FormulaTelemetry
//
//  Created by Erik Hatfield on 6/26/22.
//

import Foundation
import Combine

protocol DataHandlerInterface: ObservableObject {
    associatedtype DataPacket
    var cancellable: AnyCancellable? { get set }
    
    init(_ pub: PassthroughSubject<DataPacket?, Never>)
    
    func setup(_ pub: PassthroughSubject<DataPacket?, Never>)
    func handleDataPacket(packet: DataPacket)
}

extension DataHandlerInterface {
    func setup(_ pub: PassthroughSubject<DataPacket?, Never>) {
        self.cancellable = pub.compactMap({$0})
            .sink(receiveValue: handleDataPacket(packet:))
    }
}
