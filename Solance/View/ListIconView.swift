//
//  ListIconView.swift
//  Solance
//
//  Created by Alexander Senin on 19.05.2022.
//

import SwiftUI

struct ListIconView: View {
    
    @State var isShowing = true
    
    var body: some View {
        Image(systemName: "list.bullet")
            .resizable()
            .frame(width: 26, height: 23)
            .aspectRatio(contentMode: .fit)
            .foregroundLinearGradient(colors: [Color(0x99455FF), Color(0x14F195)], startPoint: .bottomLeading, endPoint: .topTrailing)
            .padding(10)
            .hidden(isShowing)
    }
}

struct ListIconView_Previews: PreviewProvider {
    static var previews: some View {
        ListIconView()
    }
}
