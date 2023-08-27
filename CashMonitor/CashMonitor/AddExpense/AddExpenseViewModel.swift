//
//  AddExpenseViewModel.swift
//  CashMonitor
//
//  Created by AMALITECH MACBOOK on 13/08/2023.
//

import UIKit
import CoreData

class AddExpenseViewModel: ObservableObject {

    var expenseObj: CashDB?

    @Published var title = ""
    @Published var amount = ""
    @Published var occuredOn = Date()
    @Published var note = ""
    @Published var typeTitle = "Income"
    @Published var tagTitle = getTransTagTitle(transTag: TRANSTAGTRANSPORT)
    @Published var showTypeDrop = false
    @Published var showTagDrop = false

    @Published var selectedType = TRANSTYPEINCOME
    @Published var selectedTag = TRANSTAGTRANSPORT

    @Published var imageUpdated = false // When transaction edit, check if attachment is updated?
    @Published var imageAttached: UIImage?

    @Published var alertMsg = String()
    @Published var showAlert = false
    @Published var closePresenter = false

    init(expenseObj: CashDB? = nil) {

        self.expenseObj = expenseObj
        self.title = expenseObj?.title ?? ""
        if let expenseObj = expenseObj {
            self.amount = String(expenseObj.amount)
            self.typeTitle = expenseObj.type == TRANSTYPEINCOME ? "Income" : "Expense"
        } else {
            self.amount = ""
            self.typeTitle = "Income"
        }
        self.occuredOn = expenseObj?.occuredOn ?? Date()
        self.note = expenseObj?.note ?? ""
        self.tagTitle = getTransTagTitle(transTag: expenseObj?.tag ?? TRANSTAGTRANSPORT)
        self.selectedType = expenseObj?.type ?? TRANSTYPEINCOME
        self.selectedTag = expenseObj?.tag ?? TRANSTAGTRANSPORT
        if let data = expenseObj?.imageAttached {
            self.imageAttached = UIImage(data: data)
        }

        AttachmentHandler.shared.imagePickedBlock = { [weak self] image in
            self?.imageUpdated = true
            self?.imageAttached = image
        }
    }

    func getButtText() -> String {
        if selectedType == TRANSTYPEINCOME {
            return "\(expenseObj == nil ? "ADD" : "EDIT") INCOME"
        } else if selectedType == TRANSTYPEEXPENSE {
            return "\(expenseObj == nil ? "ADD" : "EDIT") EXPENSE"
        } else {
            return "\(expenseObj == nil ? "ADD" : "EDIT") TRANSACTION"

        }
    }

    func attachImage() { AttachmentHandler.shared.showAttachmentActionSheet() }

    func removeImage() { imageAttached = nil }

    func saveTransaction(managedObjectContext: NSManagedObjectContext) {
        let expense: CashDB
        let titleStr = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let amountStr = amount.trimmingCharacters(in: .whitespacesAndNewlines)
        if titleStr.isEmpty || titleStr == "" {
            alertMsg = "Enter Title"; showAlert = true
            return
        }
        if amountStr.isEmpty || amountStr == "" {
            alertMsg = "Enter Amount"; showAlert = true
            return
        }
        guard let amount = Double(amountStr) else {
            alertMsg = "Enter valid number"; showAlert = true
            return
        }
        guard amount >= 0 else {
            alertMsg = "Amount can't be negative"; showAlert = true
            return
        }
        guard amount <= 1000000000 else {
            alertMsg = "Enter a smaller amount"; showAlert = true
            return
        }
        if expenseObj != nil {
            expense = expenseObj!

            if let image = imageAttached {
                if imageUpdated {
                   // if let _ = expense.imageAttached {
                            // Delete Previous Image from CoreData
                   //  }
                    expense.imageAttached = image.jpegData(compressionQuality: 1.0)
                }
            } else {
                expense.imageAttached = nil
            }
        } else {
            expense = CashDB(context: managedObjectContext)
            expense.createdAt = Date()
            if let image = imageAttached {
                expense.imageAttached = image.jpegData(compressionQuality: 1.0)
            }
        }
        expense.updatedAt = Date()
        expense.type = selectedType
        expense.title = titleStr
        expense.tag = selectedTag
        expense.occuredOn = occuredOn
        expense.note = note
        expense.amount = amount
        do {
            try managedObjectContext.save()
            closePresenter = true
        } catch { alertMsg = "\(error)"; showAlert = true }
    }

    func deleteTransaction(managedObjectContext: NSManagedObjectContext) {
        guard let expenseObj = expenseObj else { return }
        managedObjectContext.delete(expenseObj)
        do {
            try managedObjectContext.save(); closePresenter = true
        } catch { alertMsg = "\(error)"; showAlert = true }
    }
}
