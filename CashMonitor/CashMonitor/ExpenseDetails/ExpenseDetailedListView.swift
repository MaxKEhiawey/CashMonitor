//
//  ExpenseDetailedListView.swift
//  CashMonitor
//
//  Created by AMALITECH MACBOOK on 13/08/2023.
//

import SwiftUI

struct ExpenseDetailedView: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
        // CoreData
    @Environment(\.managedObjectContext) var managedObjectContext

    @ObservedObject private var viewModel: ExpenseDetailedViewModel
    @AppStorage(EXPENSECURRENCY) var CURRENCY: String = ""

    @State private var confirmDelete = false

    init(expenseObj: CashDB) {
        viewModel = ExpenseDetailedViewModel(expenseObj: expenseObj)
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.primaryColor.edgesIgnoringSafeArea(.all)

                VStack {

                    ToolbarModelView(title: "Details",
                                     button1Icon: IMAGEDELETEICON,
                                     button2Icon: IMAGESHAREICON) { self.presentationMode.wrappedValue.dismiss() }
                button1Method: { self.confirmDelete = true }
                button2Method: { viewModel.shareNote() }

                    ScrollView(showsIndicators: false) {

                        VStack(spacing: 24) {
                            ExpenseDetailedListView(title: "Title", description: viewModel.expenseObj.title ?? "")
                            ExpenseDetailedListView(title: "Amount",
                                                    description: "\(CURRENCY)\(viewModel.expenseObj.amount)")
                            ExpenseDetailedListView(
                                title: "Transaction type",
                                description: viewModel.expenseObj.type == TRANSTYPEINCOME ? "Income" : "Expense" )
                            ExpenseDetailedListView(
                                title: "Tag",
                                description: getTransTagTitle(transTag: viewModel.expenseObj.tag ?? ""))
                            ExpenseDetailedListView(
                                title: "When",
                                description: getDateFormatter(
                                    date: viewModel.expenseObj.occuredOn,
                                    format: "EEEE, dd MMM hh:mm a"))
                            if let note = viewModel.expenseObj.note, note != "" {
                                ExpenseDetailedListView(title: "Note", description: note)
                            }
                            if let data = viewModel.expenseObj.imageAttached {
                                VStack(spacing: 8) {
                                    HStack { TextView(text: "Attachment", type: .caption)
                                        .foregroundColor(Color.init(hex: "828282"))
                                        Spacer() }
                                    Image(uiImage: UIImage(data: data)!)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 250).frame(maxWidth: .infinity)
                                        .background(Color.secondaryColor)
                                        .cornerRadius(4)
                                }
                            }
                        }.padding(16)

                        Spacer().frame(height: 24)
                        Spacer()
                    }
                    .alert(isPresented: $confirmDelete,
                           content: {
                        Alert(title: Text(APPNAME), message: Text("Are you sure you want to delete this transaction?"),
                              primaryButton: .destructive(Text("Delete")) {
                            viewModel.deleteNote(managedObjectContext: managedObjectContext)
                        }, secondaryButton: Alert.Button.cancel(Text("Cancel"), action: { confirmDelete = false })
                        )
                    })
                }.edgesIgnoringSafeArea(.all)

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(destination: AddExpenseView(
                            viewModel: AddExpenseViewModel(
                            expenseObj: viewModel.expenseObj)),
                                       label: {
                            Image("pencil_icon")
                                .resizable()
                                .frame(width: 28.0, height: 28.0)
                            Text("Edit").modifier(InterFont(.semiBold, size: 18)).foregroundColor(.white)
                        })
                        .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 20))
                        .background(Color.mainColor).cornerRadius(25)
                    }.padding(24)
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct ExpenseDetailedListView: View {

    var title: String
    var description: String

    var body: some View {
        VStack(spacing: 8) {
            HStack { TextView(text: title, type: .caption).foregroundColor(Color.init(hex: "828282")); Spacer() }
            HStack { TextView(text: description, type: .body1).foregroundColor(Color.textPrimaryColor); Spacer() }
        }
    }
}
