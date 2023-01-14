//
//  SettingsView.swift
//  Solance
//
//  Created by Alexander Senin on 09.05.2022.
//

import SwiftUI
import Solana

struct SettingsView: View {
    
    @EnvironmentObject var router: Router<Path>
    
    @ObservedObject var model: SettingsViewModel
    
    init(model: SettingsViewModel) {
        self.model = model
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(Color("AlertColor"))
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color(0x2a2a2a))
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color("AlertColor"))], for: .selected)
    }
    
    private let gradient = LinearGradient(gradient: Gradient(colors: [Color(0x99455FF), Color(0x14F195)]), startPoint: .bottomLeading, endPoint: .topTrailing)
    
    @AppStorage("network", store: .standard) var network: Network = .mainnetBeta
    
    @State private var showConfirmation = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("CLUSTER")
                        .font(.caption)
                        .fontWeight(.light)
                        .foregroundLinearGradient(colors: [Color(0x99455FF), Color(0x14F195)], startPoint: .bottomLeading, endPoint: .topTrailing)
                    Spacer()
                }
                
                Picker("Choose a cluster", selection: $network) {
                    ForEach(Network.allCases, id: \.self) {
                        switch $0.rawValue {
                        case "mainnet-beta":
                            Text("Mainnet beta")
                        case "devnet":
                            Text("Devnet")
                        case "testnet":
                            Text("Testnet")
                        default:
                            Text("Mainnet beta")
                        }
                    }
                }.pickerStyle(.segmented)
                
                Spacer()
            }
            
            Button(role: .destructive, action: { showConfirmation = true }) {
                Text("LOG OUT")
                    .foregroundLinearGradient(colors: [Color(0x99455FF), Color(0x14F195)], startPoint: .bottomLeading, endPoint: .topTrailing)
            }.confirmationDialog("Log out confirmation", isPresented: $showConfirmation) {
                Button("Log out") {
                    withAnimation {
                        model.logOut()
                        router.push(.authView)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure?")
            }
        }.padding()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(model: SettingsViewModel())
    }
}
