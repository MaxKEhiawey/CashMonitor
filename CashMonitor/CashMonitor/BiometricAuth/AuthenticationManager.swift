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


// check this🧑🏽‍💻
struct BiometericAuthError: LocalizedError {

    var description: String

    init(description: String){
        self.description = description
    }

    init(error: Error){
        self.description = error.localizedDescription
    }

    var errorDescription: String?{
        return description
    }
}

class BiometricAuthUtlity {


    static let shared = BiometricAuthUtlity()

    private init(){}

        /// Authenticate the user with device Authentication system.
        /// If the .deviceOwnerAuthenticationWithBiometrics is not available, it will fallback to .deviceOwnerAuthentication
        /// - Returns: future which passes `Bool` when the authentication suceeds or `BiometericAuthError` when failed to authenticate
    public func authenticate() -> Future<Bool, BiometericAuthError> {
        Future { promise in

            func handleReply(success: Bool, error: Error?) -> Void {
                if let error = error {
                    return promise(
                        .failure(BiometericAuthError(error: error))
                    )
                }

                promise(.success(success))
            }

            let context = LAContext()
            var error: NSError?
            let reason = "Please authenticate yourself to unlock \(APP_NAME)"
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: handleReply)
            } else if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                    // fallback
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason, reply: handleReply)
            }else{
                    //cannot evaluate
                let error = BiometericAuthError(description: "Something went wrong while authenticating. Please try again")
                promise(.failure(error))
            }
        }
    }


}
