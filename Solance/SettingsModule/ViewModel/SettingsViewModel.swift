//
//  SettingsViewModel.swift
//  Solance
//
//  Created by Alexander Senin on 18.12.2022.
//

import Foundation
import Combine

class SettingsViewModel: ObservableObject {
    
    @Published var loggedOut = false

    func logOut() {
        AccountManager.shared.removeAccount()
        UserDefaults.standard.removeObject(forKey: "network")
        loggedOut = true
    }
}
