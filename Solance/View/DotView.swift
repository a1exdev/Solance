//
//  DotView.swift
//  Solance
//
//  Created by Alexander Senin on 19.05.2022.
//

import SwiftUI

struct DotView: View {
    
    @State var opacity: CGFloat = 0
    @State var delay: CGFloat = 0
    
    var body: some View {
        Text(".")
            .opacity(opacity)
            .animation(.easeInOut.repeatForever().speed(0.3).delay(delay), value: opacity)
            .onAppear() { opacity = 1 }
    }
}

struct DotView_Previews: PreviewProvider {
    static var previews: some View {
        DotView()
    }
}
