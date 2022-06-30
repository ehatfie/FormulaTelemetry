//
//  PersistenceController.swift
//  FormulaTelemetry
//
//  Created by Erik Hatfield on 6/26/22.
//

import Foundation
import SwiftUI
import CoreData
import F12020TelemetryPackets

class PersistenceController1: TestPersistenceControllerInterface {
    let container: NSPersistentContainer?
    
    @Published var savedData: [Packet] = []
    
    var savedDataPublished: Published<[Packet]> { _savedData }
    var savedDataPublisher: Published<[Packet]>.Publisher { $savedData }
    
    init(_ container: NSPersistentContainer) {
        self.container = container

        // by passing in the existing container we cant load here
//        container.loadPersistentStores { (description, error) in
//            if let error = error {
//                fatalError("Error: \(error.localizedDescription)")
//            }
//        }
    }
    
    func getData() {
        let request = NSFetchRequest<Packet>(entityName: "Packet") //exact name as in the CoreData file
        
        do {
            try savedData = (container?.viewContext.fetch(request))!
        } catch {
            print("Error getting data. \(error.localizedDescription)")
        }
    }
    
    func addData(dataToSave: [Data]) {
        guard let container = self.container else {
            print("no container")
            return
        }

        saveData()
    }
    
    func addData(dataToSave: [PacketEntry]) {
        guard let container = self.container else {
            print("no container")
            return
        }
        
        let entities = dataToSave.map { entry -> Packet in
            let newEntity = Packet(context: container.viewContext)
            let header = entry.header
            
            newEntity.frameIdentifier = Int16(header.frameIdentifier)
            newEntity.gameMajorVersion = Int16(header.gameMajorVersion)
            newEntity.gameMinorVersion = Int16(header.gameMinorVersion)
            newEntity.packetFormat = Int64(header.packetFormat)
            newEntity.packetType = Int16(header.packetId)
            newEntity.packetVersion = Int16(header.packetVersion)
            newEntity.playerCarIndex = Int16(header.playerCarIndex)
            newEntity.secondaryPlayerCarIndex = Int16(header.secondaryPlayerCarIndex)
            newEntity.sessionId = Int64(header.sessionUID)
            newEntity.sessionTime = header.sessionTime
            
            newEntity.data = entry.data
            
            print("header format ", header.packetFormat)
            print("converted format ", newEntity.packetFormat)
            return newEntity
        }
        do {
            try container.viewContext.save()
            //getData() //to update the published variable to reflect this change
        } catch let error {
            print("Error: \(error)")
        }
        //saveData()
    }
    
    func addData(dataToSave: Data) {
        
    }
    
    func saveData() {
        do {
            try container!.viewContext.save()
            //getData() //to update the published variable to reflect this change
        } catch let error {
            print("Error: \(error)")
        }
    }
    
}
