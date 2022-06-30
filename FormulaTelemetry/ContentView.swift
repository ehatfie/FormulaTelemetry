//
//  ContentView.swift
//  FormulaTelemetry
//
//  Created by Erik Hatfield on 11/10/21.
//

import SwiftUI
import CoreData
import NIOCore
import F12020TelemetryPackets

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var manager: Manager
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Packet.sessionTime, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Packet>
    
    
    //@ObservedObject var manager: Manager = Manager()
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink {
                    
                } label: {
                    //Text(item.timestamp!, formatter: itemFormatter)
                    Text("Data Recording Tab")
                }
                
                NavigationLink {
                    HStack {
                        VStack {
                            LapDataView(source: $manager.lapDataHandler)
                        }.border(.red, width: 1)
                        VStack {
                            Text(verbatim: "awaiting connection: \(manager.isConnected)")
                            
                            SessionView(sessionData: manager.$sessionDataHandler.sessionData)
                            TelemetryView(telemetryData: manager.$telemetryDataHandler.lastTelemetryData, telemetryStuff: $manager.lapSummaryHandler)
                        }.border(.green, width: 1)
                    }.border(.blue, width: 1)
                } label: {
                    //Text(item.timestamp!, formatter: itemFormatter)
                    Text("item one")
                }
                
                NavigationLink {
                    Text("status: \(manager.client.isConnected == true ? "connected" : "disconnected")")
                    Text(verbatim: "Item at 2")
                } label: {
                    //Text(item.timestamp!, formatter: itemFormatter)
                    Text("item two")
                    
                }
                

            }
            .toolbar {
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            
            VStack {
                List{
                    ForEach(items) { item in
                        Text(doSomething(with: item))
                    }
                }
            }

            
            DefaultDataCollectionView()
                .environmentObject(DefaultDataCollectionViewModel(pc: self.manager.persistenceController))
            
        }.onAppear(perform: setup)
    }
    
    func doSomething(with packet: Packet) -> String {
        guard let data = packet.data else { return "no data" }
        
        var buffer = ByteBuffer(bytes: data)
//        guard let header = PacketHeader(data: &buffer) else {
//            print("no header")
//            return "no header"
//        }
        
        
        let packetType = PacketType(rawValue: Int(packet.packetType)) ?? .none
        
        
        return packetType.shortDescription
    }
    
    
    private func setup() {
        self.manager.start()
        print(self.items.count)
    }
    
    private func getText() -> String {
        
        return "test"
    }

    private func addItem() {
        // has to be a better way to to do this, create a new dispatch queue??
        //self.manager.start()
        
        withAnimation {
            
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


/**
 ForEach(manager.lapDataHandler.lapDataPackets) { item in
     NavigationLink {
         Text("status: \(manager.client.isConnected == true ? "connected" : "disconnected")")
         Text(verbatim: "Item at \(item.currentLapNum)")
     } label: {
         //Text(item.timestamp!, formatter: itemFormatter)
         Text("item \(item.currentLapNum)")
     }
 }
 .onDelete(perform: deleteItems)
 */
