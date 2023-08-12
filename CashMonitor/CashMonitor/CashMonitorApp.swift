//
//  CashMonitorApp.swift
//  CashMonitor
//
//  Created by AMALITECH MACBOOK on 12/08/2023.
//

import SwiftUI

@main
struct CashMonitorApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
