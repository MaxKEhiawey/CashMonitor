//
//  ExpenseSettingsViewModel.swift
//  CashMonitor
//
//  Created by AMALITECH MACBOOK on 15/08/2023.
//

import UIKit
import Combine
import CoreData
import LocalAuthentication

class ExpenseSettingsViewModel: ObservableObject {

    var csvModelArr = [ExpenseCSVModel]()

    var cancellableBiometricTask: AnyCancellable?

    @Published var currency = UserDefaults.standard.string(forKey: EXPENSECURRENCY) ?? ""
    @Published var enableBiometric = UserDefaults.standard.bool(forKey: UDUSEBIOMETRIC) {
        didSet {
            if enableBiometric {
                authenticate()
            } else {
                UserDefaults.standard.setValue(false, forKey: UDUSEBIOMETRIC)
            }
        }
    }

    @Published var alertMsg = String()
    @Published var showAlert = false

    init() {}

    func authenticate() {

      let auth = BiometricAuthUtlity.shared
        _ = auth.authenticate()
        if auth.isUnlocked {
            UserDefaults.standard.setValue(true, forKey: UDUSEBIOMETRIC)
        }
    }

    func getBiometricType() -> String {
        if #available(iOS 11.0, *) {
            let context = LAContext()
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
                switch context.biometryType {
                case .faceID: return "Face ID"
                case .touchID: return "Touch ID"
                case .none: return "App Lock"
                @unknown default: return "App Lock"
                }
            }
        }
        return "App Lock"
    }

    func saveCurrency(currency: String) {
        self.currency = currency
        UserDefaults.standard.set(currency, forKey: EXPENSECURRENCY)
    }

    func exportTransactions(moc: NSManagedObjectContext) {
        let request = CashDB.fetchRequest()
        var results: [CashDB]
        do {
            if let result = try moc.fetch(request) as? [CashDB] {
                results = result
                if results.count <= 0 {
                    alertMsg = "No data to export"; showAlert = true

                } else {
                    for item in results {
                        let csvModel = ExpenseCSVModel()
                        csvModel.title = item.title ?? ""
                        csvModel.amount = "\(currency)\(item.amount)"
                        csvModel.transactionType = "\(item.type == TRANSTYPEINCOME ? "INCOME" : "EXPENSE")"
                        csvModel.tag = getTransTagTitle(transTag: item.tag ?? "")
                        csvModel.occuredOn = "\(getDateFormatter(date: item.occuredOn, format: "yyyy-mm-dd hh:mm a"))"
                        csvModel.note = item.note ?? ""
                        csvModelArr.append(csvModel)
                    }
                    self.generateCSV()
                }
            }
        } catch {
            alertMsg = "\(error)"; showAlert = true
        }
    }

    func generateCSV() {

        let fileName = "CashMonitor.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        var csvText = "Title,Amount,Type,Tag,Occured On,Note\n"

        for csvModel in csvModelArr {
            let row = "\"\(csvModel.title)\","
            + "\"\(csvModel.amount)\","
            + "\"\(csvModel.transactionType)\","
            + "\"\(csvModel.tag)\","
            + "\"\(csvModel.occuredOn)\","
            + "\"\(csvModel.note)\"\n"
            csvText.append(row)
        }

        do {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            let view = UIActivityViewController(activityItems: [path!],
                                                applicationActivities: nil)

            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = windowScene.windows.first?.rootViewController {
                rootViewController.present(view, animated: true, completion: nil)
            }
          //  UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
        } catch { alertMsg = "\(error)"; showAlert = true }

        print(path ?? "not found")
    }

    deinit {
        cancellableBiometricTask = nil
    }
}
