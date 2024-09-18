//
//  AuthenticationManager.swift
//  CashMonitor
//
//  Created by AMALITECH MACBOOK on 13/08/2023.
//

import Foundation
import Combine
import LocalAuthentication

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

class BiometricAuthUtlity: ObservableObject {
    static let shared = BiometricAuthUtlity()
    @Published var isUnlocked = false
    private init() {}

    public func authenticate(completion: @escaping (Bool) -> Void) {

        let context = LAContext()
        var error: NSError?
        let reason = "Please authenticate yourself to unlock \(APPNAME)"
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                   localizedReason: reason) { success, _ in
                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true
                        completion(true)
                        UserDefaults.standard.setValue(true, forKey: UDUSEBIOMETRIC)
                    } else {
                        self.authenticateWithPasscodeFallback { status in
                            completion(status)
                            UserDefaults.standard.setValue(status, forKey: UDUSEBIOMETRIC)
                        }
                    }
                }
            }
        } else {
            self.authenticateWithPasscodeFallback {  status in
                completion(status)
                UserDefaults.standard.setValue(status, forKey: UDUSEBIOMETRIC)
            }
        }
    }

    private func authenticateWithPasscodeFallback(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Unlock with your passcode"
            context.evaluatePolicy(.deviceOwnerAuthentication,
                                   localizedReason: reason) { success, _ in
                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true
                        completion(true)
                    } else {
                            // Passcode authentication failed
                        self.isUnlocked = false
                        completion(false)
                    }
                }
            }
        }
    }

}
