//
//  KeychainManager.swift
//  Solance
//
//  Created by Alexander Senin on 08.05.2022.
//

import Foundation
import Solana
import KeychainSwift

enum SolanaAccountStorageError: Error {
    case unauthorized
}

struct KeychainManager: SolanaAccountStorage {
    
    private let key = "solance"
    private let keychain = KeychainSwift()
    
    var account: Result<Signer, Error> {
        guard let account = keychain.getData(key) else {
            return .failure(SolanaAccountStorageError.unauthorized)
        }
        if let account = try? JSONDecoder().decode(HotAccount.self, from: account) {
            return .success(account)
        }
        return .failure(SolanaAccountStorageError.unauthorized)
    }
    
    @discardableResult
    func save(_ signer: Signer) -> Result<Void, Error> {
        do {
            let data = try JSONEncoder().encode(signer as! HotAccount)
            keychain.set(data, forKey: key)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    @discardableResult
    func clear() -> Result<Void, Error> {
        keychain.clear()
        return .success(())
    }
}
