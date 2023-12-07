//
//  Config.swift
//  CashMonitor
//
//  Created by AMALITECH MACBOOK on 13/08/2023.
//

import Foundation

    // App Globals
let APPNAME = "CashMonitor"
let APPLINK = "https://github.com/"
let SHAREDFROM = """
    Shared from \(APPNAME) App: \(APPLINK)
    """
// NAVIGATIONTTITLE
let DASHBOARD = "Dashboard"
let SETTINGS = "Settings"
let DETAILS = "Details"
let ADDTRANSACTION = "Add Transaction"
let EDITTRANSACTION = "Edit Transaction"
    // IMAGE_ICON NAMES
let IMAGEBACKARROWICON = "back_arrow"
let IMAGEDELETEICON = "delete_icon"
let IMAGESHAREICON = "share_icon"
let IMAGEFILTERICON = "filter_icon"
let IMAGEOPTIONICON = "settings_icon"

    // User Defaults
let UDUSEBIOMETRIC = "useBiometric"
let EXPENSECURRENCY = "expenseCurrency"

let CURRENCYLIST =  allCurrencySymbols().sorted() // ["₹", "$", "€", "¥", "£", "¢", "₭"]

    // Transaction types
let TRANSTYPEINCOME = "income"
let TRANSTYPEEXPENSE = "expense"

    // Transaction tags
let TRANSTAGTRANSPORT = "transport"
let TRANSTAGFOOD = "food"
let TRANSTAGHOUSING = "housing"
let TRANSTAGINSURANCE = "insurance"
let TRANSTAGMEDICAL = "medical"
let TRANSTAGSAVINGS = "savings"
let TRANSTAGPERSONAL = "personal"
let TRANSTAGENTERTAINMENT = "entertainment"
let TRANSTAGOTHERS = "others"
let TRANSTAGUTILITIES = "utilities"

// Empty filter message
let allEmptyItem = EmptyFilterContent(
    title: "No Input Entered Yet!",
    subtitle: "Add a transaction and it will show up here")
 let lastWeekItem = EmptyFilterContent(
    title: "No Inputs for the past 7 days!",
    subtitle: "Consider using another filter")
let lastMonthItem = EmptyFilterContent(
    title: "No Inputs for the past 30 days!",
    subtitle: "Consider using another filter")

func getTransTagIcon(transTag: String) -> String {
    switch transTag {
    case TRANSTAGTRANSPORT: return "trans_type_transport"
    case TRANSTAGFOOD: return "trans_type_food"
    case TRANSTAGHOUSING: return "trans_type_housing"
    case TRANSTAGINSURANCE: return "trans_type_insurance"
    case TRANSTAGMEDICAL: return "trans_type_medical"
    default: return getTransTagIcon2(transTag: transTag)
    }
}
func getTransTagIcon2(transTag: String) -> String {
    switch transTag {
    case TRANSTAGSAVINGS: return "trans_type_savings"
    case TRANSTAGPERSONAL: return "trans_type_personal"
    case TRANSTAGENTERTAINMENT: return "trans_type_entertainment"
    case TRANSTAGOTHERS: return "trans_type_others"
    case TRANSTAGUTILITIES: return "trans_type_utilities"
    default: return "trans_type_others"
    }
}

func getTransTagTitle(transTag: String) -> String {
    switch transTag {
    case TRANSTAGTRANSPORT: return "Transport"
    case TRANSTAGFOOD: return "Food"
    case TRANSTAGHOUSING: return "Housing"
    case TRANSTAGINSURANCE: return "Insurance"
    case TRANSTAGMEDICAL: return "Medical"
    default: return getTransTagTitle2(transTag: transTag)
    }
}

func getTransTagTitle2(transTag: String) -> String {
    switch transTag {
    case TRANSTAGSAVINGS: return "Savings"
    case TRANSTAGPERSONAL: return "Personal"
    case TRANSTAGENTERTAINMENT: return "Entertainment"
    case TRANSTAGOTHERS: return "Others"
    case TRANSTAGUTILITIES: return "Utilities"
    default: return "Unknown"
    }
}

func getDateFormatter(date: Date?, format: String = "yyyy-MM-dd") -> String {
    guard let date = date else { return "" }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
}

func allCurrencySymbols() -> Set<String> {
    let availableLocales = Locale.availableIdentifiers
    var symbols = Set<String>()

    for identifier in availableLocales {
        let locale = Locale(identifier: identifier)

        if let currencySymbol = locale.currencySymbol {
            symbols.insert(currencySymbol)
        }
    }

    return symbols
}
