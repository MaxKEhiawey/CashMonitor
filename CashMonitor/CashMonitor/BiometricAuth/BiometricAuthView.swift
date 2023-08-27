//
//  BiometricAuthView.swift
//  CashMonitor
//
//  Created by AMALITECH MACBOOK on 13/08/2023.
//

import SwiftUI

struct BiometricAuthView: View {
    @ObservedObject var authenticationManager: AuthenticationManager

    var body: some View {
        NavigationStack {
            ZStack {
                Color.primaryColor.edgesIgnoringSafeArea(.all)

                VStack {
                  //  NavigationLink(destination: NavigationLazyView(ExpenseView()),
                // isActive: $authenticationManager.isUnlocked, label: {})
                    Spacer()
                   // Image("pie_icon").resizable().frame(width: 120.0, height: 120.0)
                    VStack(spacing: 16) {
                        TextView(text: "\(APPNAME) is locked", type: .body1)
                            .foregroundColor(Color.textPrimaryColor)
                            .padding(.top, 20)
                        Button(action: {  authenticationManager.authenticate()}, label: {
                            HStack {
                                Spacer()
                                TextView(text: "Unlock", type: .button).foregroundColor(Color.mainColor)
                                Spacer()
                            }
                        })
                        .frame(height: 25)
                        .padding().background(Color.secondaryColor)
                        .cornerRadius(4)
                        .foregroundColor(Color.textPrimaryColor)
                        .accentColor(Color.textPrimaryColor)
                    }.padding(.horizontal)
                    Spacer()
                }
                .edgesIgnoringSafeArea(.all)
                .onAppear(perform: authenticationManager.authenticate)
                .navigationDestination(isPresented: $authenticationManager.isUnlocked) {
                    NavigationLazyView(ExpenseView())
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear(perform: {
            authenticationManager.authenticate()
        })
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }

}
