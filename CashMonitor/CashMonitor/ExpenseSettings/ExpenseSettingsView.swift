//
//  ExpenseSettingsView.swift
//  CashMonitor
//
//  Created by AMALITECH MACBOOK on 15/08/2023.
//

import SwiftUI

struct ExpenseSettingsView: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
        // CoreData
    @Environment(\.managedObjectContext) var managedObjectContext

    @ObservedObject private var viewModel = ExpenseSettingsViewModel()
    @State private var selectCurrency = false

    var body: some View {

            ZStack(alignment: .top) {
                Color.primaryColor.edgesIgnoringSafeArea(.all)

                VStack {
                        /// ToolbarModelView(title: SETTINGS) { self.presentationMode.wrappedValue.dismiss() }

                    VStack {

                        HStack {
                            TextView(text: "Enable \(viewModel.getBiometricType())",
                                     type: .button)
                            .foregroundColor(Color.textPrimaryColor)
                            Spacer()
                            Toggle("", isOn: $viewModel.enableBiometric)
                                .toggleStyle(SwitchToggleStyle(tint: Color.mainColor))
                                .onChange(of: viewModel.enableBiometric) { _ in

                                }
                        }.padding(8)

                        Button(action: { selectCurrency = true }, label: {
                            HStack {
                                Spacer()
                                TextView(text: "Currency - \(viewModel.currency)", type: .button)
                                    .foregroundColor(Color.textPrimaryColor)
                                Spacer()
                            }
                        })
                        .frame(height: 25)
                        .padding().background(Color.secondaryColor)
                        .cornerRadius(4)
                        .foregroundColor(Color.textPrimaryColor)
                        .accentColor(Color.textPrimaryColor)
                        .actionSheet(isPresented: $selectCurrency) {
                            var buttons: [ActionSheet.Button] = CURRENCYLIST.map { curr in
                                ActionSheet.Button.default(Text(curr)) { viewModel.saveCurrency(currency: curr) }
                            }
                            buttons.append(.cancel())
                            return ActionSheet(title: Text("Select a currency"), buttons: buttons)
                        }

                        Button(action: { viewModel.exportTransactions(moc: managedObjectContext) },
                               label: {
                            HStack {
                                Spacer()
                                TextView(text: "Export transactions", type: .button)
                                    .foregroundColor(Color.textPrimaryColor)
                                Spacer()
                            }
                        })
                        .frame(height: 25)
                        .padding().background(Color.secondaryColor)
                        .cornerRadius(4)
                        .foregroundColor(Color.textPrimaryColor)
                        .accentColor(Color.textPrimaryColor)

                    }
                    .padding(.horizontal, 8).padding(.top, 1)
                    .alert(isPresented: $viewModel.showAlert,
                           content: {
                        Alert(title: Text(APPNAME),
                              message: Text(viewModel.alertMsg),
                              dismissButton: .default(Text("OK")))})
                }
                VStack {
                    Spacer()

                    HStack {
                        Spacer()
                        Button(action: { self.presentationMode.wrappedValue.dismiss() },
                               label: {
                            Image("tick_icon")
                                .resizable()
                                .frame(width: 32.0, height: 32.0)
                        })
                        .padding()
                        .background(Color.mainColor)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.5), radius: 8, x: 2, y: 6)

                    }
                }.padding()
            }
        .navigationBarTitle(SETTINGS, displayMode: .inline)
        .navigationViewStyle(StackNavigationViewStyle())

    }
}

struct ExpenseSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseSettingsView()
    }
}
