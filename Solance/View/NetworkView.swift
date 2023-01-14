//
//  NetworkView.swift
//  Solance
//
//  Created by Alexander Senin on 19.05.2022.
//

import SwiftUI

struct NetworkView: View {
    
    @Binding var network: String
    
    var body: some View {
        Text(network)
            .font(.caption)
            .fontWeight(.light)
            .padding(.vertical, 3)
            .padding(.horizontal, 6)
    }
}

struct NetworkView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkView(network: .constant("MAINNET BETA"))
    }
}
