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
                Color.primary_color.edgesIgnoringSafeArea(.all)

                VStack {
                  //  NavigationLink(destination: NavigationLazyView(ExpenseView()), isActive: $authenticationManager.isUnlocked, label: {})
                    Spacer()
                   // Image("pie_icon").resizable().frame(width: 120.0, height: 120.0)
                    VStack(spacing: 16) {
                        TextView(text: "\(APP_NAME) is locked", type: .body_1).foregroundColor(Color.text_primary_color).padding(.top, 20)
                        Button(action: {  authenticationManager.authenticate()}, label: {
                            HStack {
                                Spacer()
                                TextView(text: "Unlock", type: .button).foregroundColor(Color.main_color)
                                Spacer()
                            }
                        })
                        .frame(height: 25)
                        .padding().background(Color.secondary_color)
                        .cornerRadius(4)
                        .foregroundColor(Color.text_primary_color)
                        .accentColor(Color.text_primary_color)
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
