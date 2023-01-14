//
//  View.swift
//  Solance
//
//  Created by Alexander Senin on 15.12.2022.
//

import SwiftUI

extension View {
    
    func navigationBarColor(backgroundColor: UIColor?, titleColor: UIColor?) -> some View {
        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor, titleColor: titleColor))
    }
    
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
    
    func foregroundLinearGradient(colors: [Color], startPoint: UnitPoint, endPoint: UnitPoint) -> some View {
        self.overlay {
            LinearGradient(colors: colors, startPoint: startPoint, endPoint: endPoint)
                .mask(self)
        }
    }
    
    func underlineTextField() -> some View {
        self.overlay(Rectangle()
            .frame(height: 2)
            .padding(.top, 35)
            .foregroundLinearGradient(colors: [Color(0x99455FF), Color(0x14F195)], startPoint: .bottomLeading, endPoint: .topTrailing))
            .padding(.bottom, 20)
    }
    
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0.2 : 1)
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
