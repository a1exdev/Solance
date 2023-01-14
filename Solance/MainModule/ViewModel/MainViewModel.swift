//
//  MainViewModel.swift
//  Solance
//
//  Created by Alexander Senin on 18.12.2022.
//

import Combine

@MainActor
class MainViewModel: ObservableObject {
    
    @Published var balance = 0.0
    @Published var publicKey: String = ""
    @Published var network: String = ""
    
    @Published private(set) var state = ViewState.loading
    
    func receiveBalance() async {
        balance = await BalanceManager.shared.receiveBalance()
        state = .ready
    }
    
    func receiveNetwork() {
        network = NetworkManager.shared.receiveNetwork()
    }
    
    func receivePublicKey() {
        publicKey = AccountManager.shared.publicKey ?? ""
    }
    
    init() {
        Task {
            await receiveBalance()
        }
        receiveNetwork()
        receivePublicKey()
    }
}
