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
    @State var isActive: Bool = false
    init() {
        self.setDefaultPreferences()
    }

    private func setDefaultPreferences() {
        let currency = UserDefaults.standard.string(forKey: EXPENSECURRENCY)
        if currency == nil {
            UserDefaults.standard.set("$", forKey: EXPENSECURRENCY)
        }
    }

    var body: some Scene {
        WindowGroup {
            if !isActive {
                SplashScreenView(isActive: $isActive)
            } else {
                if  UserDefaults.standard.bool(forKey: UDUSEBIOMETRIC) {
                    BiometricAuthView(authenticationManager: authenticationManager)
                        .environment(\.managedObjectContext, persistentContainer.viewContext)
                } else {
                    ExpenseView()
                        .environment(\.managedObjectContext, persistentContainer.viewContext)
                }
            }
        }
    }
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CashMonitor")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}
struct LaunchScreenView: View {
    var body: some View {
        Text("CashMonitor")
            .font(.largeTitle)
    }
}
