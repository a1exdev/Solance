//
//  PilllowView.swift
//  Solance
//
//  Created by Alexander Senin on 20.12.2022.
//

import SwiftUI

struct PilllowView: View {
    var body: some View {
        Capsule()
            .fill(Color(UIColor.systemGray4))
            .frame(width: 40, height: 5)
            .padding(.top, 20)
            .padding(.bottom, 10)
    }
}

struct PilllowView_Previews: PreviewProvider {
    static var previews: some View {
        PilllowView()
    }
}
