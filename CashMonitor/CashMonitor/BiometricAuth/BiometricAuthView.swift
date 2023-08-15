//
//  BiometricAuthView.swift
//  CashMonitor
//
//  Created by AMALITECH MACBOOK on 13/08/2023.
//

import SwiftUI

struct BiometricAuthView: View {
    @StateObject private var authenticationManager = AuthenticationManager()

    var body: some View {
        VStack {
            if !authenticationManager.isUnlocked {
                Button("Unlock with Face ID") {
                    authenticationManager.authenticate()
                }
            }
        }
    }
}


struct BiometricAuthView_Previews: PreviewProvider {
    static var previews: some View {
        BiometricAuthView()
    }
}
