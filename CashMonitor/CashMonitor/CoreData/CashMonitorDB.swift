//
//  CashMonitorDB.swift
//  CashMonitor
//
//  Created by AMALITECH MACBOOK on 12/08/2023.
//

import Foundation
import CoreData

enum CashDBSort: String {
    case createdAt
    case updatedAt
    case occuredOn
}

enum CashDBFilterTime: String {
    case all
    case week
    case month
}

public class CashDB: NSManagedObject, Identifiable {
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var type: String?
    @NSManaged public var title: String?
    @NSManaged public var tag: String?
    @NSManaged public var occuredOn: Date?
    @NSManaged public var note: String?
    @NSManaged public var amount: Double
    @NSManaged public var imageAttached: Data?
    @NSManaged public var timestamp: Date
}

extension CashDB {
    static func getAllExpenseData(sortBy: CashDBSort = .occuredOn, ascending: Bool = true, filterTime: CashDBFilterTime = .all) -> NSFetchRequest<CashDB> {
        let request: NSFetchRequest<CashDB> = CashDB.fetchRequest() as! NSFetchRequest<CashDB>
        let sortDescriptor = NSSortDescriptor(key: sortBy.rawValue, ascending: ascending)
        if filterTime == .week {
            let startDate: NSDate = Date().getLast7Day()! as NSDate
            let endDate: NSDate = NSDate()
            let predicate = NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@", startDate, endDate)
            request.predicate = predicate
        } else if filterTime == .month {
            let startDate: NSDate = Date().getLast30Day()! as NSDate
            let endDate: NSDate = NSDate()
            let predicate = NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@", startDate, endDate)
            request.predicate = predicate
        }
        request.sortDescriptors = [sortDescriptor]
        return request
    }
}
