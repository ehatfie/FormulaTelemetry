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
    let container: NSPersistentContainer
    
    @Published var savedData: [ReceivedPacket] = []
    
    var savedDataPublished: Published<[ReceivedPacket]> { _savedData }
    var savedDataPublisher: Published<[ReceivedPacket]>.Publisher { $savedData }
    
    init() {
        container = NSPersistentContainer(name: "FormulaTelemetry") //exactname of the CoreData file
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func getData() {
        let request = NSFetchRequest<ReceivedPacket>(entityName: "ReceivedPacket") //exact name as in the CoreData file
        
        do {
            try savedData = container.viewContext.fetch(request)
        } catch {
            print("Error getting data. \(error.localizedDescription)")
        }
    }
    
    func addData(dataToSave: Data) {
        let newEntity = ReceivedPacket(context: container.viewContext)
        newEntity.data = dataToSave
        saveData()
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
            getData() //to update the published variable to reflect this change
        } catch let error {
            print("Error: \(error)")
        }
    }
}
