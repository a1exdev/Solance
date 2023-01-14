//
//  BalanceManager.swift
//  Solance
//
//  Created by Alexander Senin on 18.12.2022.
//

import Foundation
import Solana

enum BalanceManagerError: Error {
    case requestAirdropFailure
}

protocol BalanceManagerProtocol {
    static var shared: BalanceManager { get }

    func receiveBalance() async -> Double
    func requestAirdrop(completionHandler: @escaping (Result<String, Error>) -> Void)
}

class BalanceManager: ObservableObject, BalanceManagerProtocol {
    
    static var shared: BalanceManager = {
        let instance = BalanceManager()
        return instance
    }()
    
    private init() {
        self.networkManager = NetworkManager.shared
        self.accountManager = AccountManager.shared
    }
    
    private let group = DispatchGroup()
    
    private let networkManager: NetworkManagerProtocol!
    private let accountManager: AccountManagerProtocol!
    
    private var solana: Solana {
        return networkManager.solana
    }
    
    private var publicKey: String? {
        return accountManager.publicKey
    }
    
    func receiveBalance() async -> Double {
        var balance: Double = 0

        if let account = publicKey {
            group.enter()
            solana.api.getBalance(account: account) { result in
                switch result {
                case .success(let sol):
                    balance = Double(sol) / 1000000000
                    self.group.leave()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            group.wait()
        }
        
        return balance
    }
    
    func requestAirdrop(completionHandler: @escaping (Result<String, Error>) -> Void) {
        if let account = publicKey {
            solana.api.requestAirdrop(account: account, lamports: 1987654321) { result in
                switch result {
                case .success(let success):
                    completionHandler(.success(success))
                case .failure(let failure):
                    completionHandler(.failure(failure))
                }
            }
        } else {
            completionHandler(.failure(AccountManagerError.getAccountFailure))
        }
    }
}
