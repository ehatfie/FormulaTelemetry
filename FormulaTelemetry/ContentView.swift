//
//  ContentView.swift
//  FormulaTelemetry
//
//  Created by Erik Hatfield on 11/10/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var manager: Manager
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    
    //@ObservedObject var manager: Manager = Manager()
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink {
                    VStack {
                        Text(verbatim: "connected: \(manager.isConnected)")
                    }
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
           
                HStack {
                    VStack {
                        LapDataView(source: $manager.lapDataHandler)
                    }.border(.red, width: 1)
                    VStack {
                        Text(verbatim: "awaiting connection: \(manager.isConnected)")
                        SessionView(sessionData: manager.$sessionDataHandler.sessionData)
                        TelemetryView(telemetryData: manager.$telemetryDataHandler.lastTelemetryData)
                    }.border(.green, width: 1)
                }.border(.blue, width: 1)
            

            
        }.onAppear(perform: setup)
    }
    
    
    private func setup() {
        self.manager.start()
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
