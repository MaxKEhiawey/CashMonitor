//
//  CashMonitorApp.swift
//  CashMonitor
//
//  Created by AMALITECH MACBOOK on 12/08/2023.
//

import SwiftUI
import CoreData

@main
struct CashMonitorApp: App {
    //let persistenceController = PersistenceController.shared
    init() {
        self.setDefaultPreferences()
    }

    private func setDefaultPreferences() {
        let currency = UserDefaults.standard.string(forKey: UD_EXPENSE_CURRENCY)
        if currency == nil {
            UserDefaults.standard.set("$", forKey: UD_EXPENSE_CURRENCY)
        }
    }

    var body: some Scene {
        WindowGroup {
            ExpenseView()
           .environment(\.managedObjectContext, persistentContainer.viewContext)
        }
    }
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CashMonitor")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}
