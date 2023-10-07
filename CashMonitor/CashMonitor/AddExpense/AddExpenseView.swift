//
//  AddExpenseView.swift
//  CashMonitor
//
//  Created by AMALITECH MACBOOK on 13/08/2023.
//

import SwiftUI

struct AddExpenseView: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
        // CoreData
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var confirmDelete = false
    @State var showAttachSheet = false

    @StateObject var viewModel: AddExpenseViewModel

    let typeOptions = [
        DropdownOption(key: TRANSTYPEINCOME, val: "Income"),
        DropdownOption(key: TRANSTYPEEXPENSE, val: "Expense")
    ]

    let tagOptions = [
        DropdownOption(key: TRANSTAGTRANSPORT, val: "Transport"),
        DropdownOption(key: TRANSTAGFOOD, val: "Food"),
        DropdownOption(key: TRANSTAGHOUSING, val: "Housing"),
        DropdownOption(key: TRANSTAGINSURANCE, val: "Insurance"),
        DropdownOption(key: TRANSTAGMEDICAL, val: "Medical"),
        DropdownOption(key: TRANSTAGSAVINGS, val: "Savings"),
        DropdownOption(key: TRANSTAGPERSONAL, val: "Personal"),
        DropdownOption(key: TRANSTAGENTERTAINMENT, val: "Entertainment"),
        DropdownOption(key: TRANSTAGOTHERS, val: "Others"),
        DropdownOption(key: TRANSTAGUTILITIES, val: "Utilities")
    ]

    var body: some View {
            ZStack {
                Color.primaryColor.edgesIgnoringSafeArea(.all)
                    ScrollView(showsIndicators: false) {

                        VStack(spacing: 12) {

                            TextField("Title", text: $viewModel.title)
                                .modifier(InterFont(.regular, size: 16))
                                .accentColor(Color.textPrimaryColor)
                                .frame(height: 50).padding(.leading, 16)
                                .background(Color.secondaryColor)
                                .cornerRadius(4)

                            TextField("Amount", text: $viewModel.amount)
                                .modifier(InterFont(.regular, size: 16))
                                .accentColor(Color.textPrimaryColor)
                                .frame(height: 50).padding(.leading, 16)
                                .background(Color.secondaryColor)
                                .cornerRadius(4).keyboardType(.decimalPad)

                            DropdownButton(shouldShowDropdown: $viewModel.showTypeDrop,
                                           displayText: $viewModel.typeTitle,
                                           options: typeOptions,
                                           mainColor: Color.textPrimaryColor,
                                           backgroundColor: Color.secondaryColor,
                                           cornerRadius: 4, buttonHeight: 50) { key in
                                let selectedObj = typeOptions.filter({ $0.key == key }).first
                                if let object = selectedObj {
                                    viewModel.typeTitle = object.val
                                    viewModel.selectedType = key
                                }
                                viewModel.showTypeDrop = false
                            }

                            DropdownButton(shouldShowDropdown: $viewModel.showTagDrop,
                                           displayText: $viewModel.tagTitle,
                                           options: tagOptions,
                                           mainColor: Color.textPrimaryColor,
                                           backgroundColor: Color.secondaryColor,
                                           cornerRadius: 4, buttonHeight: 50) { key in
                                let selectedObj = tagOptions.filter({ $0.key == key }).first
                                if let object = selectedObj {
                                    viewModel.tagTitle = object.val
                                    viewModel.selectedTag = key
                                }
                                viewModel.showTagDrop = false
                            }

                            HStack {
                                DatePicker("PickerView",
                                           selection: $viewModel.occuredOn,
                                           displayedComponents: [.date, .hourAndMinute])
                                .labelsHidden()
                                .padding(.leading, 16)
                                Spacer()
                            }
                            .frame(height: 50).frame(maxWidth: .infinity)
                            .accentColor(Color.textPrimaryColor)
                            .background(Color.secondaryColor).cornerRadius(4)

                            TextField("Note", text: $viewModel.note)
                                .modifier(InterFont(.regular, size: 16))
                                .accentColor(Color.textPrimaryColor)
                                .frame(height: 50).padding(.leading, 16)
                                .background(Color.secondaryColor)
                                .cornerRadius(4)

                            Button(action: { viewModel.attachImage() }, label: {
                                HStack {
                                    Image(systemName: "paperclip")
                                        .font(.system(size: 18.0, weight: .bold))
                                        .foregroundColor(Color.textSecondaryColor)
                                        .padding(.leading, 16)
                                    TextView(text: "Attach an image", type: .button)
                                        .foregroundColor(Color.textSecondaryColor)
                                    Spacer()
                                }
                            })
                            .frame(height: 50).frame(maxWidth: .infinity)
                            .background(Color.secondaryColor)
                            .cornerRadius(4)
                            .actionSheet(isPresented: $showAttachSheet) {
                                ActionSheet(title: Text("Do you want to remove the attachment?"), buttons: [
                                    .default(Text("Remove")) { viewModel.removeImage() },
                                    .cancel()
                                ])
                            }

                            if let image = viewModel.imageAttached {
                                Button(action: { showAttachSheet = true }, label: {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 250).frame(maxWidth: .infinity)
                                        .background(Color.secondaryColor)
                                        .cornerRadius(4)
                                })
                            }
                        }
                        .frame(maxWidth: .infinity).padding(.horizontal, 8)
                        .alert(isPresented: $viewModel.showAlert,
                               content: { Alert(title: Text(APPNAME),
                                                message: Text(viewModel.alertMsg),
                                                dismissButton: .default(Text("OK"))) })
                    }
                    .padding(.top, 8)
                    .alert(isPresented: $confirmDelete,
                           content: {
                        Alert(title: Text(APPNAME), message: Text("Are you sure you want to delete this transaction?"),
                              primaryButton: .destructive(Text("Delete")) {
                            viewModel.deleteTransaction(managedObjectContext: self.managedObjectContext)
                        }, secondaryButton: Alert.Button.cancel(Text("Cancel"), action: { confirmDelete = false })
                        )
                    })

                VStack {
                    Spacer()
                    VStack {
                        Button(action: { viewModel.saveTransaction(managedObjectContext: managedObjectContext) },
                               label: {
                            HStack {
                                Spacer()
                                TextView(text: viewModel.getButtText(), type: .button)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                        })
                        .padding(.vertical, 12).background(Color.mainColor).cornerRadius(8)
                    }
                    .padding(.bottom, 16)
                    .padding(.horizontal, 8)
                }

            }
        .navigationBarTitle(viewModel.expenseObj == nil ? ADDTRANSACTION : EDITTRANSACTION, displayMode: .inline)
        .dismissKeyboardOnTap()
        .navigationViewStyle(StackNavigationViewStyle())
        .onReceive(viewModel.$closePresenter) { close in
            if close { self.presentationMode.wrappedValue.dismiss() }
        }
    }
}
