//
//  ExpenseDetailedViewModel.swift
//  CashMonitor
//
//  Created by AMALITECH MACBOOK on 13/08/2023.
//

import UIKit
import CoreData

class ExpenseDetailedViewModel: ObservableObject {

    @Published var expenseObj: CashDB

    @Published var alertMsg = String()
    @Published var showAlert = false
    @Published var closePresenter = false

    init(expenseObj: CashDB) {
        self.expenseObj = expenseObj
    }

    func deleteNote(managedObjectContext: NSManagedObjectContext) {
        managedObjectContext.delete(expenseObj)
        do {
            try managedObjectContext.save(); closePresenter = true
        } catch { alertMsg = "\(error)"; showAlert = true }
    }

    func shareNote() {
        let shareStr = """
        Title: \(expenseObj.title ?? "")
        Amount: \(UserDefaults.standard.string(forKey: EXPENSECURRENCY) ?? "")\(expenseObj.amount)
        Transaction type: \(expenseObj.type == TRANSTYPEINCOME ? "Income" : "Expense")
        Category: \(getTransTagTitle(transTag: expenseObj.tag ?? ""))
        Date: \(getDateFormatter(date: expenseObj.occuredOn, format: "EEEE, dd MMM hh:mm a"))
        Note: \(expenseObj.note ?? "")

        \(SHAREDFROM)
        """
        let view = UIActivityViewController(
            activityItems: [shareStr],
            applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(view, animated: true, completion: nil)
        }
      //  UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
}
