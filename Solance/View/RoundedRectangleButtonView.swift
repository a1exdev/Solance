//
//  RoundedRectangleButtonView.swift
//  Solance
//
//  Created by Alexander Senin on 19.05.2022.
//

import SwiftUI

struct RoundedRectangleButtonView: View {
    
    private let gradient = LinearGradient(gradient: Gradient(colors: [Color(0x99455FF), Color(0x14F195)]), startPoint: .bottomLeading, endPoint: .topTrailing)
    
    @State var label: String = ""
    
    var body: some View {
        Text(label)
            .foregroundLinearGradient(colors: [Color(0x99455FF), Color(0x14F195)], startPoint: .bottomLeading, endPoint: .topTrailing)
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 8)
            .stroke(gradient, lineWidth: 2)
            .saturation(1.8))
    }
}

struct RoundedRectangleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        RoundedRectangleButtonView()
    }
}
