//
//  TransactionsView.swift
//  Solance
//
//  Created by Alexander Senin on 09.05.2022.
//

import SwiftUI

struct TransactionsView: View {
    
    @ObservedObject var model: TransactionsViewModel
    
    @State private var showFailureAlert = false
    
    var body: some View {
        switch model.state {
        case .failure:
            ZStack {
                VStack {
                    PilllowView()
                    Spacer()
                }
                
                Text(model.errorText)
                    .foregroundLinearGradient(colors: [Color(0x99455FF), Color(0x14F195)], startPoint: .bottomLeading, endPoint: .topTrailing)
            }
        case .loading:
            ZStack {
                VStack {
                    PilllowView()
                    Spacer()
                }
                
                HStack(spacing: 0.1) {
                    Text("Fetching transactions")
                    DotView()
                    DotView(delay: 0.2)
                    DotView(delay: 0.4)
                }.foregroundLinearGradient(colors: [Color(0x99455FF), Color(0x14F195)], startPoint: .bottomLeading, endPoint: .topTrailing)
            }
        case .ready:
            ZStack {
                VStack {
                    PilllowView()
                    if #available(iOS 16.0, *) {
                        List(model.transactions) { transaction in
                            Text("\(transaction.recentBlockhash)")
                                .listRowBackground(Color(UIColor.systemGray6))
                        }.background(Color.black)
                            .scrollContentBackground(.hidden)
                    }
                    Spacer()
                }
            }
        }
    }
}

struct TransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsView(model: TransactionsViewModel())
    }
}
