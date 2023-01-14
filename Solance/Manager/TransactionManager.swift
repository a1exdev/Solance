//
//  TransactionManager.swift
//  Solance
//
//  Created by Alexander Senin on 18.12.2022.
//

import Foundation
import Solana

enum TransactionManagerError: Error {
    case getTransactionsFailure
    case getSignaturesFailure
    case getTransactionsInfoFailure
    case sendTransactionFailure
}

protocol TransactionManagerProtocol {
    static var shared: TransactionManager { get }
    
    func receiveTransactions() async -> Result<[Transaction], TransactionManagerError>
    func sendTransaction(to recipientAddress: String, amount: UInt64) async -> Result<TransactionID, TransactionManagerError>
}

class TransactionManager: TransactionManagerProtocol {
    
    static var shared: TransactionManager = {
        let instance = TransactionManager()
        return instance
    }()
    
    private init() {
        self.networkManager = NetworkManager.shared
        self.accountManager = AccountManager.shared
    }
    
    private let group = DispatchGroup()
    
    private let keychain = KeychainManager()
    
    private let networkManager: NetworkManagerProtocol!
    private let accountManager: AccountManagerProtocol!
    
    private var solana: Solana {
        return networkManager.solana
    }
    
    private var publicKey: String? {
        return accountManager.publicKey
    }
    
    // MARK: Receive Transactions

    func receiveTransactions() async -> Result<[Transaction], TransactionManagerError> {

        guard let account = publicKey else {
            return .failure(TransactionManagerError.getTransactionsFailure)
        }
        
        var transactions: [Transaction] = []
        
        do {
            let transactionsSignatures = try receiveTransactionsSignatures(for: account).get()
            transactions = try receiveTransactions(for: transactionsSignatures).get()
        } catch {
            print(error.localizedDescription)
        }
        
        return .success(transactions)
    }
    
    private func receiveTransactionsSignatures(for account: String) -> Result<[SignatureInfo], TransactionManagerError> {
        
        var transactionsSignatures: [SignatureInfo]?
        
        group.enter()
        solana.api.getConfirmedSignaturesForAddress2(account: account) { result in
            switch result {
            case .success(let signatures):
                transactionsSignatures = signatures
                self.group.leave()
            case .failure(let error):
                print("Get signatures failure: \(error.localizedDescription)")
            }
        }
        group.wait()
        
        if let transactionsSignatures {
            return .success(transactionsSignatures)
        }

        return .failure(TransactionManagerError.getSignaturesFailure)
    }
    
    private func receiveTransactions(for signatures: [SignatureInfo]) -> Result<[Transaction], TransactionManagerError> {
        
        guard !signatures.isEmpty else { return .failure(TransactionManagerError.getTransactionsInfoFailure) }
        
        var transactions: [Transaction] = []

        group.enter()
        signatures.forEach { signature in
            solana.api.getConfirmedTransaction(transactionSignature: signature.signature) { result in
                switch result {
                case .success(let info):
                    transactions.append(Transaction(timestamp: info.blockTime,
                                                    slot: info.slot,
                                                    recentBlockhash: info.transaction.message.recentBlockhash))
                    if transactions.count == signatures.count {
                        self.group.leave()
                    }
                case .failure(let error):
                    print("Get transaction info failure: \(error.localizedDescription)")
                }
            }
        }
        group.wait()

        return .success(transactions)
    }
    
    // MARK: Send Transaction
    
    func sendTransaction(to recipientAddress: String, amount: UInt64) async -> Result<TransactionID, TransactionManagerError> {
        do {
            let transactionId = try await solana.action.sendSOL(
                to: recipientAddress,
                from: keychain.account.get(),
                amount: amount
            )
            return .success(transactionId)
        } catch {
            return .failure(TransactionManagerError.sendTransactionFailure)
        }
    }
}

extension TransactionManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
