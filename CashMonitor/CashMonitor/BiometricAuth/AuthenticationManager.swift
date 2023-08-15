//
//  AuthenticationManager.swift
//  CashMonitor
//
//  Created by AMALITECH MACBOOK on 13/08/2023.
//

import LocalAuthentication

class AuthenticationManager: ObservableObject {
    @Published var isUnlocked = false

        func authenticate() {
            let context = LAContext()
            var error: NSError?

            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Unlock to access your app"
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                    DispatchQueue.main.async {
                        if success {
                            self.isUnlocked = true
                        } else {
                            self.authenticateWithPasscodeFallback()
                        }
                    }
                }
            } else {
                self.authenticateWithPasscodeFallback()
            }
        }

        private func authenticateWithPasscodeFallback() {
            let context = LAContext()
            var error: NSError?

            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                let reason = "Unlock with your passcode"
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                    DispatchQueue.main.async {
                        if success {
                            self.isUnlocked = true
                        } else {
                                // Passcode authentication failed
                        }
                    }
                }
            }
        }
    }
