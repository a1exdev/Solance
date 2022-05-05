//
//  SolanceApp.swift
//  Solance
//
//  Created by Alexander Senin on 05.05.2022.
//

import SwiftUI

@main
struct SolanceApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
