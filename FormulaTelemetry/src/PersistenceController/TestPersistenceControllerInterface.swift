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
    
    var savedData: [Packet] { get }
    var savedDataPublished: Published<[Packet]> { get }
    var savedDataPublisher: Published<[Packet]>.Publisher { get }
    
    func getData()
    func addData(dataToSave: Data)
    func saveData()
}
