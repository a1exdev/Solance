//
//  GearIconView.swift
//  Solance
//
//  Created by Alexander Senin on 19.05.2022.
//

import SwiftUI

struct GearIconView: View {
    
    @State var isShowing = true
    
    var body: some View {
        Image(systemName: "gear")
            .resizable()
            .frame(width: 28, height: 28)
            .aspectRatio(contentMode: .fit)
            .foregroundLinearGradient(colors: [Color(0x99455FF), Color(0x14F195)], startPoint: .bottomLeading, endPoint: .topTrailing)
            .padding(10)
            .hidden(isShowing)
    }
}

struct GearIconView_Previews: PreviewProvider {
    static var previews: some View {
        GearIconView()
    }
}
