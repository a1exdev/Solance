//
//  MainView.swift
//  Solance
//
//  Created by Alexander Senin on 05.05.2022.
//

import SwiftUI

enum Path {
    case authView
    case mainView
    case settingsView
}

struct ContentView: View {
    
    @ObservedObject var model: ContentViewModel
    
    @ObservedObject var mainViewRouter = Router<Path>(root: .mainView)
    @ObservedObject var authViewRouter = Router<Path>(root: .authView)
    
    var body: some View {
        switch model.isAuthorized {
        case false:
            RouterView(router: authViewRouter) { path in
                switch path {
                case .authView:
                    AuthView(model: AuthViewModel())
                case .mainView:
                    MainView(model: MainViewModel())
                case .settingsView:
                    SettingsView(model: SettingsViewModel())
                }
            }
        default:
            RouterView(router: mainViewRouter) { path in
                switch path {
                case .authView:
                    AuthView(model: AuthViewModel())
                case .mainView:
                    MainView(model: MainViewModel())
                case .settingsView:
                    SettingsView(model: SettingsViewModel())
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: ContentViewModel()).previewDevice("iPhone 14 Pro").preferredColorScheme(.dark).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
