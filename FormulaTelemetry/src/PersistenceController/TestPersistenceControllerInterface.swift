//
//  TestPersistenceControllerInterface.swift
//  FormulaTelemetry
//
//  Created by Erik Hatfield on 6/26/22.
//

import Foundation
import F12020TelemetryPackets
import CoreData
import Combine

protocol TestPersistenceControllerInterface: ObservableObject {
    var container: NSPersistentContainer? { get }
    
    var savedData: [ReceivedPacket] { get }
    var savedDataPublished: Published<[ReceivedPacket]> { get }
    var savedDataPublisher: Published<[ReceivedPacket]>.Publisher { get }
    
    func getData()
    func addData(dataToSave: Data)
    func saveData()
}
