//
//  AuthenticationManager.swift
//  CashMonitor
//
//  Created by AMALITECH MACBOOK on 13/08/2023.
//

import Foundation
import Combine
import LocalAuthentication

class AuthenticationManager: ObservableObject {
    @Published var isUnlocked = false

        func authenticate() {
            let context = LAContext()
            var error: NSError?

            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Unlock to access your app"
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                       localizedReason: reason) { success, _ in
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
                context.evaluatePolicy(.deviceOwnerAuthentication,
                                       localizedReason: reason) { success, _ in
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
// check this🧑🏽‍💻
struct BiometericAuthError: LocalizedError {

    var description: String

    init(description: String) {
        self.description = description
    }

    init(error: Error) {
        self.description = error.localizedDescription
    }

    var errorDescription: String? {
        return description
    }
}

class BiometricAuthUtlity {
    static let shared = BiometricAuthUtlity()
    @Published var isUnlocked = false
    private init() {}

    public func authenticate() -> Future<Bool, BiometericAuthError> {
        Future { _ in

            let context = LAContext()
            var error: NSError?
            let reason = "Please authenticate yourself to unlock \(APPNAME)"
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                       localizedReason: reason) { success, _ in
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
    }
    private func authenticateWithPasscodeFallback() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Unlock with your passcode"
            context.evaluatePolicy(.deviceOwnerAuthentication,
                                   localizedReason: reason) { success, _ in
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
