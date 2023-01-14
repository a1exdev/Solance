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
            ContentView(model: ContentViewModel())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(.dark)
                .onAppear() {
                    let scenes = UIApplication.shared.connectedScenes
                    let windowScene = scenes.first as? UIWindowScene
                    let window = windowScene?.windows.first
                    window?.overrideUserInterfaceStyle = .dark
                }
        }
    }
}
