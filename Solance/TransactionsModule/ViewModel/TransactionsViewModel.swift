//
//  TransactionsViewModel.swift
//  Solance
//
//  Created by Alexander Senin on 18.12.2022.
//

import Combine

@MainActor
class TransactionsViewModel: ObservableObject {
    
    @Published var errorText = ""
    
    @Published var transactions: [Transaction] = []
    
    @Published private(set) var state = ViewState.loading
    
    private var cancellable: Set<AnyCancellable> = []
    
    func receiveTransactions() async {
        do {
            transactions = try await TransactionManager.shared.receiveTransactions().get()
            if !transactions.isEmpty {
                state = .ready
            } else {
                errorText = "You don't have any transactions yet."
                state = .failure
            }
        } catch {
            errorText = error.localizedDescription
            state = .failure
        }
    }
    
    init() {
        Task {
            await receiveTransactions()
        }
    }
}
