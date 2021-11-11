//
//  FormulaTelemetryApp.swift
//  FormulaTelemetry
//
//  Created by Erik Hatfield on 11/10/21.
//

import SwiftUI

@main
struct FormulaTelemetryApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
