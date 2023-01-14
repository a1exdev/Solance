//
//  AccountManager.swift
//  Solance
//
//  Created by Alexander Senin on 18.12.2022.
//

import Combine
import Solana

enum AccountManagerError: Error {
    case getPublicKeyFailure
    case getAccountFailure
}

protocol AccountManagerProtocol {
    static var shared: AccountManager { get }
    
    var publicKey: String? { get }
    var account: HotAccount? { get }
    
    func saveAccount(_ account: HotAccount)
    func removeAccount()
}

class AccountManager: ObservableObject, AccountManagerProtocol {
    
    static var shared: AccountManager = {
        let instance = AccountManager()
        return instance
    }()
    
    private init() {
        self.keychain = KeychainManager()
        self.networkManager = NetworkManager.shared
    }
    
    private let keychain: KeychainManager!
    
    private let networkManager: NetworkManagerProtocol!
    
    private var solana: Solana {
        return networkManager.solana
    }
    
    var publicKey: String? {
        do {
            let publicKey = try getPublicKey().get()
            return publicKey
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func getPublicKey() -> Result<String, AccountManagerError> {
        do {
            let publicKey = try getAccount().get().publicKey.base58EncodedString
            return .success(publicKey)
        } catch {
            return .failure(AccountManagerError.getPublicKeyFailure)
        }
    }
    
    var account: HotAccount? {
        do {
            let account = try getAccount().get()
            return account
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func getAccount() -> Result<HotAccount, AccountManagerError> {
        do {
            let account = try keychain.account.get()
            return .success(account as! HotAccount)
        } catch {
            return .failure(AccountManagerError.getAccountFailure)
        }
    }
    
    func saveAccount(_ account: HotAccount) {
        keychain.save(account)
    }
    
    func removeAccount() {
        keychain.clear()
    }
}
