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
    @StateObject private var authenticationManager = AuthenticationManager()
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
            if  UserDefaults.standard.bool(forKey: UD_USE_BIOMETRIC) {
                BiometricAuthView(authenticationManager: authenticationManager)
                    .environment(\.managedObjectContext, persistentContainer.viewContext)
            } else {
                ExpenseView()
             .environment(\.managedObjectContext, persistentContainer.viewContext)
            }
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
