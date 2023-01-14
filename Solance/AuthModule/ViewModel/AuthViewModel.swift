//
//  AuthViewModel.swift
//  Solance
//
//  Created by Alexander Senin on 18.12.2022.
//

import Combine
import Solana

class AuthViewModel: ObservableObject {
    
    @Published var secretPhrase = ""
    @Published var isAuthorized = false
    
    func initAccount() {
        AccountManager.shared.saveAccount(HotAccount(phrase: self.secretPhrase.components(separatedBy: " "), derivablePath: DerivablePath(type: .bip44, walletIndex: 3))!)
        isAuthorized = true
    }
    
    func checkSecretPhrase() -> Bool {
        if secretPhrase.trimmingCharacters(in: .whitespaces).components(separatedBy: " ").count != 12 && secretPhrase.trimmingCharacters(in: .whitespaces).components(separatedBy: " ").count != 24 {
            return true
        } else {
            return false
        }
    }
}
