//
//  MainView.swift
//  Solance
//
//  Created by Alexander Senin on 22.12.2022.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var router: Router<Path>
    
    @ObservedObject var model: MainViewModel
    
    @State private var showTransactionsView = false
    @State private var showSettingsView = false
    @State private var showSendSolanaView = false
    @State private var showReceiveSolanaView = false
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView(showsIndicators: false) {
                    RefreshView(coordinateSpaceName: "Pull To Refresh") {
                        Task {
                            await model.receiveBalance()
                        }
                    }
                    VStack(spacing: 20) {
                        
                        switch model.state {
                        case .loading:
                            HStack(spacing: 0.1) {
                                DotView()
                                DotView(delay: 0.2)
                                DotView(delay: 0.4)
                            }.font(.largeTitle)
                             .foregroundLinearGradient(colors: [Color(0x99455FF), Color(0x14F195)], startPoint: .bottomLeading, endPoint: .topTrailing)
                        case .ready:
                            Text("\(String(format: "%.9f", model.balance)) SOL")
                                .font(.largeTitle)
                                .foregroundLinearGradient(colors: [Color(0x99455FF), Color(0x14F195)], startPoint: .bottomLeading, endPoint: .topTrailing)
                        case .failure:
                            Text("Couldn't fetch balance :(")
                                .font(.largeTitle)
                                .foregroundLinearGradient(colors: [Color(0x99455FF), Color(0x14F195)], startPoint: .bottomLeading, endPoint: .topTrailing)
                        }
                        
                        VStack {
                            DetailInformationView(title: "ADDRESS", value: model.publicKey)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 60) {
                            
                            RoundedRectangleButtonView(label: "SEND SOL")
                                .onTapGesture { withAnimation { showSendSolanaView = true } }
                                .sheet(isPresented: $showSendSolanaView) {
                                    SendSolanaView(model: SendSolanaViewModel())
                                }
                            
                            RoundedRectangleButtonView(label: "RECEIVE SOL")
                                .onTapGesture { withAnimation { showReceiveSolanaView = true } }
                        }
                    }
                }.coordinateSpace(name: "Pull To Refresh")
            }
            
            VStack {
                Spacer()
                NetworkView(network: $model.network)
                    .overlay {
                        Capsule().fill(.black).overlay() {
                            NetworkView(network: $model.network)
                                .foregroundLinearGradient(colors: [Color(0x99455FF), Color(0x14F195)], startPoint: .bottomLeading, endPoint: .topTrailing)
                        }
                    }
            }
            
            ReceiveSolanaView(publicKey: $model.publicKey, isShowing: $showReceiveSolanaView)
        }.padding(.horizontal)
         .navigationTitle("My Wallet")
         .navigationBarColor(backgroundColor: UIColor(Color.black), titleColor: UIColor(Color.primary))
         .navigationBarTitleDisplayMode(.inline)
         .toolbar {
             ToolbarItem(placement: .navigationBarLeading) {
                 if showReceiveSolanaView {
                     ListIconView(isShowing: true)
                         .onTapGesture() {
                             withAnimation { showReceiveSolanaView = false }
                         }
                 } else {
                     ListIconView(isShowing: false)
                         .onTapGesture { showTransactionsView = true }
                         .sheet(isPresented: $showTransactionsView) {
                             ZStack {
                                 Color.black.ignoresSafeArea()
                                 TransactionsView(model: TransactionsViewModel())
                             }
                         }
                }
             }
             
             ToolbarItem(placement: .navigationBarTrailing) {
                 if showReceiveSolanaView {
                     GearIconView(isShowing: true)
                         .onTapGesture() {
                             withAnimation { showReceiveSolanaView = false }
                         }
                } else {
                    GearIconView(isShowing: false).onTapGesture {
                        withAnimation {
                            router.push(.settingsView)
                        }
                    }
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(model: MainViewModel())
    }
}
