//
//  AuthView.swift
//  Solance
//
//  Created by Alexander Senin on 08.05.2022.
//

import SwiftUI
import Combine

struct AuthView: View {
    
    @EnvironmentObject var router: Router<Path>
    
    @ObservedObject var model: AuthViewModel
    
    private let gradient = LinearGradient(gradient: Gradient(colors: [Color(0x99455FF), Color(0x14F195)]), startPoint: .bottomLeading, endPoint: .topTrailing)
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
                .onTapGesture { hideKeyboard() }
            
            VStack {
                Text("YOUR SECRET PHRASE (12 OR 24 WORDS)")
                    .font(.caption)
                    .foregroundLinearGradient(colors: [Color(0x99455FF), Color(0x14F195)], startPoint: .bottomLeading, endPoint: .topTrailing)
                
                TextField("", text: $model.secretPhrase)
                    .autocapitalization(.none)
                    .keyboardType(.default)
                    .onReceive(Just($model.secretPhrase.wrappedValue)) { newValue in
                        let filtered = newValue.filter { "abcdefghijklmnopqrstuvwxyz ".contains($0) }
                        if filtered != newValue { $model.secretPhrase.wrappedValue = filtered }
                    }
                    .placeholder(when: $model.secretPhrase.wrappedValue.isEmpty) {
                        Text("person hand save, etc.").foregroundColor(.accentColor)
                    }
                    .foregroundColor(Color.white)
                    .underlineTextField()
                
                Button(action: { model.initAccount() }) {
                    Text("AUTHORIZE")
                        .foregroundLinearGradient(colors: [Color(0x99455FF), Color(0x14F195)], startPoint: .bottomLeading, endPoint: .topTrailing)
                        .padding(10)
                }.background(Capsule()
                 .stroke(gradient, lineWidth: 2)
                 .saturation(1.8))
                 .hidden(model.checkSecretPhrase())
                 .disabled(model.checkSecretPhrase())
                
                Text("OR")
                    .font(.caption)
                    .foregroundColor(.accentColor)
                
                Button(action: { model.initAccount() }) {
                    Text("CREATE A NEW ONE")
                        .font(.callout)
                        .foregroundLinearGradient(colors: [Color(0x99455FF), Color(0x14F195)], startPoint: .bottomLeading, endPoint: .topTrailing)
                }
                Spacer()
            }
        }.padding()
         .toolbar(.hidden)
         .onChange(of: model.isAuthorized) { _ in
             withAnimation {
                 router.updateRoot(root: .mainView)
                 router.popToRoot()
             }
         }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(model: AuthViewModel())
            .preferredColorScheme(.dark)
    }
}
