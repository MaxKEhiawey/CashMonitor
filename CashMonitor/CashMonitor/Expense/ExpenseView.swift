//
//  ExpenseView.swift
//  CashMonitor
//
//  Created by AMALITECH MACBOOK on 13/08/2023.
//

import SwiftUI

struct ExpenseView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
        // CoreData
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: CashDB.getAllExpenseData(sortBy: CashDBSort.occuredOn, ascending: false))
    var expense: FetchedResults<CashDB>

    @State private var filter: CashDBFilterTime = .all
    @State private var showFilterSheet = false

    @State private var showOptionsSheet = false
    @State private var displayAbout = false
    @State private var displaySettings = false
    var emptyFilterContentItem: EmptyFilterContent?
    private let allEmptyItem = EmptyFilterContent(
        title: "No Input Entered Yet!",
        subtitle: "Add a transaction and it will show up here")
    private let lastWeekItem = EmptyFilterContent(
        title: "No Inputs for the past 7 days!",
        subtitle: "Consider using another filter")
    private let lastMonthItem = EmptyFilterContent(
        title: "No Inputs for the past 30 days!",
        subtitle: "Consider using another filter")
    var body: some View {
        NavigationStack {
            ZStack {
                Color.primaryColor.edgesIgnoringSafeArea(.all)

                VStack {

                    ToolbarModelView(title: "Dashboard",
                                     hasBackButt: false,
                                     button1Icon: IMAGEOPTIONICON,
                                     button2Icon: IMAGEFILTERICON) { self.presentationMode.wrappedValue.dismiss() }
                button1Method: { self.showOptionsSheet = true }
                button2Method: { self.showFilterSheet = true }
                        .actionSheet(isPresented: $showFilterSheet) {
                            ActionSheet(title: Text("Select a filter"), buttons: [
                                .default(Text("Overall")) {
                                    filter = .all
                                },
                                .default(Text("Last 7 days")) {
                                    filter = .week
                                },
                                .default(Text("Last 30 days")) { filter = .month },
                                .cancel()
                            ])
                        }
                    ExpenseMainView(filter: filter, emptyFilter: updateEmptyFilter())
                        .actionSheet(isPresented: $showOptionsSheet) {
                            ActionSheet(title: Text("Select an option"), buttons: [
                                .default(Text("About")) { self.displayAbout = true },
                                .default(Text("Settings")) { self.displaySettings = true },
                                .cancel()
                            ])
                        }
                    Spacer()
                }
                .edgesIgnoringSafeArea(.all)
                .navigationDestination(isPresented: $displaySettings) {
                    NavigationLazyView(ExpenseSettingsView())
                }
                .navigationDestination(isPresented: $displayAbout) {
                    NavigationLazyView(AboutView())
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(destination: NavigationLazyView(
                            AddExpenseView(viewModel: AddExpenseViewModel())),
                                       label: { Image("plus_icon").resizable().frame(width: 32.0, height: 32.0) })
                        .padding().background(Color.mainColor).cornerRadius(35)
                    }
                }.padding()
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    func updateEmptyFilter() -> EmptyFilterContent {
        switch filter {
        case .all:
            return allEmptyItem
        case .week:
             return lastWeekItem
        case .month:
            return  lastMonthItem
        }
    }
}

struct ExpenseMainView: View {
    var emptyFilterContent: EmptyFilterContent
    var filter: CashDBFilterTime
    var fetchRequest: FetchRequest<CashDB>
    var expense: FetchedResults<CashDB> { fetchRequest.wrappedValue }
    @AppStorage(EXPENSECURRENCY) var CURRENCY: String = ""

    init(filter: CashDBFilterTime, emptyFilter: EmptyFilterContent) {
        let sortDescriptor = NSSortDescriptor(key: "occuredOn", ascending: false)
        self.emptyFilterContent = emptyFilter
        self.filter = filter
        if filter == .all {
            fetchRequest = FetchRequest<CashDB>(entity: CashDB.entity(), sortDescriptors: [sortDescriptor])
        } else {
            var startDate: NSDate!
            let endDate: NSDate = NSDate()
            if filter == .week {
                startDate = Date().getLast7Day()! as NSDate
            } else if filter == .month {
                startDate = Date().getLast30Day()! as NSDate
            } else {
                startDate = Date().getLast6Month()! as NSDate
            }
            let predicate = NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@",
                                        startDate, endDate)
            fetchRequest = FetchRequest<CashDB>(entity: CashDB.entity(),
                                                sortDescriptors: [sortDescriptor],
                                                predicate: predicate)
        }
    }

    private func getTotalBalance() -> String {
        var value = Double(0)
        for item in expense {
            if item.type == TRANSTYPEINCOME {
                value += item.amount
            } else if item.type == TRANSTYPEEXPENSE {
                value -= item.amount
            }
        }
        return "\(String(format: "%.2f", value))"
    }

    var body: some View {

        ScrollView(showsIndicators: false) {

            if fetchRequest.wrappedValue.isEmpty {
                LottieView(name: .emptyData, loopMode: .autoReverse).frame(width: 300, height: 300)
                VStack {
                    TextView(text: emptyFilterContent.title, type: .h6Type)
                        .foregroundColor(Color.textPrimaryColor)
                    TextView(text: emptyFilterContent.subtitle, type: .body1)
                        .foregroundColor(Color.textSecondaryColor)
                        .padding(.top, 2)
                }.padding(.horizontal)
            } else {
                VStack(spacing: 16) {
                    TextView(text: "TOTAL BALANCE", type: .overline)
                        .foregroundColor(Color.init(hex: "828282"))
                        .padding(.top, 30)
                    TextView(text: "\(CURRENCY)\(getTotalBalance())", type: .h5Type)
                        .foregroundColor(Color.textPrimaryColor)
                        .padding(.bottom, 30)
                }
                .frame(maxWidth: .infinity)
                .background(Color.secondaryColor)
                .cornerRadius(4)

                HStack(spacing: 8) {
                    NavigationLink(destination: NavigationLazyView(ExpenseFilterView(isIncome: true)),
                                   label: { ExpenseModelView(isIncome: true, filter: filter) })
                    NavigationLink(destination: NavigationLazyView(ExpenseFilterView(isIncome: false)),
                                   label: { ExpenseModelView(isIncome: false, filter: filter) })
                }.frame(maxWidth: .infinity)

                Spacer().frame(height: 16)

                HStack {
                    TextView(text: "Recent Transaction", type: .subtitle1).foregroundColor(Color.textPrimaryColor)
                    Spacer()
                }.padding(4)

                ForEach(self.fetchRequest.wrappedValue) { expenseObj in
                 NavigationLink(destination: ExpenseDetailedView(expenseObj: expenseObj),
                label: {
                        ExpenseTransView(expenseObj: expenseObj)

                   })
                }
           }
            Spacer().frame(height: 150)

        }.padding(.horizontal, 8).padding(.top, 0)
    }
}

struct ExpenseModelView: View {

    var isIncome: Bool
    var type: String
    var fetchRequest: FetchRequest<CashDB>
    var expense: FetchedResults<CashDB> { fetchRequest.wrappedValue }
    @AppStorage(EXPENSECURRENCY) var CURRENCY: String = ""

    private func getTotalValue() -> String {
        var value = Double(0)
        for item in expense { value += item.amount }
        return "\(String(format: "%.2f", value))"
    }

    init(isIncome: Bool, filter: CashDBFilterTime, categTag: String? = nil) {
        self.isIncome = isIncome
        self.type = isIncome ? TRANSTYPEINCOME : TRANSTYPEEXPENSE
        let sortDescriptor = NSSortDescriptor(key: "occuredOn", ascending: false)
        if filter == .all {
            var predicate: NSPredicate!
            if let tag = categTag {
                predicate = NSPredicate(format: "type == %@ AND tag == %@", type, tag)
            } else { predicate = NSPredicate(format: "type == %@", type) }
            fetchRequest = FetchRequest<CashDB>(entity: CashDB.entity(),
                                                sortDescriptors: [sortDescriptor],
                                                predicate: predicate)
        } else {
            var startDate: NSDate!
            let endDate: NSDate = NSDate()
            if filter == .week {
                startDate = Date().getLast7Day()! as NSDate
            } else if filter == .month {
                startDate = Date().getLast30Day()! as NSDate
            } else { startDate = Date().getLast6Month()! as NSDate
            }
            var predicate: NSPredicate!
            if let tag = categTag {
                predicate = NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@ AND type == %@ AND tag == %@",
                                        startDate,
                                        endDate,
                                        type,
                                        tag)
            } else { predicate = NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@ AND type == %@",
                                             startDate,
                                             endDate,
                                             type) }
            fetchRequest = FetchRequest<CashDB>(entity: CashDB.entity(),
                                                sortDescriptors: [sortDescriptor],
                                                predicate: predicate)
        }
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Spacer()
                Image(isIncome ? "income_icon" : "expense_icon")
                    .resizable()
                    .frame(width: 40.0, height: 40.0)
                    .padding(12)
            }
            HStack {
                TextView(text: isIncome ? "INCOME" : "EXPENSE",
                         type: .overline)
                    .foregroundColor(Color.init(hex: "828282"))
                Spacer()
            }.padding(.horizontal, 12)
            HStack {
                TextView(text: "\(CURRENCY)\(getTotalValue())",
                         type: .h5Type, lineLimit: 1)
                    .foregroundColor(Color.textPrimaryColor)
                Spacer()
            }.padding(.horizontal, 12)
        }
        .padding(.bottom, 12)
        .background(Color.secondaryColor)
        .cornerRadius(4)
    }
}

struct ExpenseTransView: View {

    @ObservedObject var expenseObj: CashDB
    @AppStorage(EXPENSECURRENCY) var CURRENCY: String = ""

    var body: some View {
        HStack {

            NavigationLink(destination: NavigationLazyView(ExpenseFilterView(categTag: expenseObj.tag)), label: {
                Image(getTransTagIcon(transTag: expenseObj.tag ?? ""))
                    .resizable().frame(width: 24, height: 24).padding(16)
                    .background(Color.primaryColor).cornerRadius(4)
            })

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    TextView(text: expenseObj.title ?? "",
                             type: .subtitle1,
                             lineLimit: 1)
                        .foregroundColor(Color.textPrimaryColor)
                    Spacer()
                    TextView(text: "\(expenseObj.type == TRANSTYPEINCOME ? "+" : "-")\(CURRENCY)\(expenseObj.amount)",
                             type: .subtitle1)
                        .foregroundColor(expenseObj.type == TRANSTYPEINCOME ? Color.mainGreen : Color.mainRed)
                }
                HStack {
                    TextView(text: getTransTagTitle(transTag: expenseObj.tag ?? ""),
                             type: .body2)
                    .foregroundColor(Color.textPrimaryColor)
                    Spacer()
                    TextView(text: getDateFormatter(date: expenseObj.occuredOn,
                                                    format: "MMM dd, yyyy"),
                             type: .body2)
                    .foregroundColor(Color.textPrimaryColor)
                }
            }.padding(.leading, 4)

            Spacer()

        }
        .padding(8)
        .background(Color.secondaryColor)
        .cornerRadius(4)
    }
}

struct ExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseView()
    }
}

struct EmptyFilterContent {
    let title: String
    let subtitle: String
}
