//
//  DetailInformationView.swift
//  Solance
//
//  Created by Alexander Senin on 08.05.2022.
//

import SwiftUI

struct DetailInformationView: View {
    
    var title: String
    var value: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.light)
                    .foregroundLinearGradient(colors: [Color(0x99455FF), Color(0x14F195)], startPoint: .bottomLeading, endPoint: .topTrailing)
                Text(value)
                    .font(.headline)
                    .fontWeight(.medium)
                    .textSelection(.enabled)
            }
            Spacer()
        }
    }
}


struct DetailInformationView_Previews: PreviewProvider {
    static var previews: some View {
        DetailInformationView(title: "ADDRESS", value: "12KDRYjm3LpZVz5Y9JoS81trgtZ2opW78NgyFm11pXMM")
    }
}
