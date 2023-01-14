//
//  ContentViewModel.swift
//  Solance
//
//  Created by Alexander Senin on 22.12.2022.
//

import Combine

@MainActor
class ContentViewModel: ObservableObject {
    
    @Published var isAuthorized = false
    
    func receiveAccount() {
        if AccountManager.shared.account != nil {
            isAuthorized = true
        } else {
            isAuthorized = false
        }
    }
    
    init() {
        receiveAccount()
    }
}
