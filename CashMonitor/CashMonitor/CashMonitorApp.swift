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
            if authenticationManager.isUnlocked {
                ExpenseView()
             .environment(\.managedObjectContext, persistentContainer.viewContext)
            } else {
                Button(action: {
                    authenticationManager.authenticate()
                }, label: {
                    VStack(spacing: 0) {
                        Image(systemName: "faceid")
                            .font(.largeTitle)
                        Text( "Click to Unlock with Face ID")
                            .font(.title2)

                    }
                })
                .capsuleButtonStyle()

            }
//
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
