//
//  SendSolanaView.swift
//  Solance
//
//  Created by Alexander Senin on 09.05.2022.
//

import SwiftUI
import Combine

struct SendSolanaView: View {
    
    @ObservedObject var model: SendSolanaViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    enum Field {
        case recipientAddress
        case amount
    }
    
    init(model: SendSolanaViewModel) {
        self.model = model
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(Color("AlertColor"))
    }
    
    private let gradient = LinearGradient(gradient: Gradient(colors: [Color(0x99455FF), Color(0x14F195)]), startPoint: .bottomLeading, endPoint: .topTrailing)
    
    @State private var dismissSheet = false
    @FocusState private var focusedField: Field?
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
                .onTapGesture { hideKeyboard() }
            
            VStack {
                Capsule()
                    .fill(Color.accentColor)
                    .frame(width: 40, height: 5)
                    .padding(10)
            
                VStack(alignment: .leading) {
                    HStack {
                        Text("RECIPIENT ADDRESS")
                            .foregroundLinearGradient(colors: [Color(0x99455FF), Color(0x14F195)], startPoint: .bottomLeading, endPoint: .topTrailing)
                        Spacer()
                        Text("CLEAR")
                            .foregroundLinearGradient(colors: [Color(0x99455FF), Color(0x14F195)], startPoint: .bottomLeading, endPoint: .topTrailing)
                            .onTapGesture { withAnimation { model.recipientAddress = "" } }
                            .opacity(model.recipientAddress.isEmpty ? 0 : 1)
                    }.font(.caption)
                    
                    TextField("", text: $model.recipientAddress)
                        .focused($focusedField, equals: .recipientAddress)
                        .autocapitalization(.none)
                        .keyboardType(.default)
                        .onReceive(Just(model.recipientAddress)) { newValue in
                            let filtered = newValue.filter { "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890".contains($0) }
                            if filtered != newValue { model.recipientAddress = filtered }
                        }
                        .placeholder(when: model.recipientAddress.isEmpty) {
                            Text("BXVtDq99TJMegqKYx4roYwHQFnhTG5AqWdc4CTs8dFr9")
                                .foregroundColor(.accentColor)
                                .lineLimit(1)
                        }
                        .foregroundColor(Color.white)
                        .underlineTextField()
                    
                    HStack {
                        Text("AMOUNT")
                            .foregroundLinearGradient(colors: [Color(0x99455FF), Color(0x14F195)], startPoint: .bottomLeading, endPoint: .topTrailing)
                        Spacer()
                        Text("CLEAR")
                            .foregroundLinearGradient(colors: [Color(0x99455FF), Color(0x14F195)], startPoint: .bottomLeading, endPoint: .topTrailing)
                            .onTapGesture { withAnimation { model.amount = "" } }
                            .opacity(model.amount.isEmpty ? 0 : 1)
                    }.font(.caption)
                    
                    TextField("", text: $model.amount)
                        .focused($focusedField, equals: .amount)
                        .autocapitalization(.none)
                        .keyboardType(.default)
                        .onReceive(Just(model.amount)) { newValue in
                            let filtered = newValue.filter { "1234567890.,".contains($0) }
                            if filtered != newValue { model.amount = filtered }
                        }
                        .placeholder(when: model.amount.isEmpty) {
                            Text("3.14159")
                                .foregroundColor(.accentColor)
                        }
                        .foregroundColor(Color.white)
                        .underlineTextField()
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Fee")
                                .font(.caption)
                            Text("0.000005 SOL")
                                .font(.callout)
                        }.foregroundLinearGradient(colors: [Color(0x99455FF), Color(0x14F195)], startPoint: .bottomLeading, endPoint: .topTrailing)
                        
                        Spacer()
                        
                        Button(action: { model.validateCredentials() }) {
                            Text("SEND SOL")
                                .foregroundLinearGradient(colors: [Color(0x99455FF), Color(0x14F195)], startPoint: .bottomLeading, endPoint: .topTrailing)
                                .padding(10)
                        }.background(RoundedRectangle(cornerRadius: 8)
                         .stroke(gradient, lineWidth: 2)
                         .saturation(1.8))
                         .hidden(model.recipientAddress.isEmpty || model.amount.isEmpty)
                         .disabled(model.recipientAddress.isEmpty || model.amount.isEmpty)
                         .alert(model.resultText, isPresented: $model.showAlert) {
                             Button("OK", role: .cancel) {
                                 if model.state == .ready { dismissSheet = true }
                             }
                         }
                         .confirmationDialog("Transaction confirmation", isPresented: $model.showConfirmation) {
                             Button("Send") {
                                 Task {
                                     await model.sendTransaction()
                                 }
                             }
                             Button("Cancel", role: .cancel) {}
                         } message: {
                             Text("Are you sure want to send \(model.amount) SOL to \(model.recipientAddress)?")
                         }
                    }
                    Spacer()
                }
            }
        }.padding()
         .background(Color.black)
         .onSubmit {
             switch focusedField {
             case .recipientAddress:
                 focusedField = .amount
             default:
                 hideKeyboard()
            }
         }
    }
}

struct SendSolanaView_Previews: PreviewProvider {
    static var previews: some View {
        SendSolanaView(model: SendSolanaViewModel())
            .preferredColorScheme(.dark)
    }
}
