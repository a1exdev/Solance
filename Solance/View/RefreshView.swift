//
//  RefreshView.swift
//  Solance
//
//  Created by Alexander Senin on 08.05.2022.
//

import SwiftUI

struct RefreshView: View {
    
    var coordinateSpaceName: String
    var onRefresh: ()-> Void
    
    @State var needRefresh: Bool = false
    
    var body: some View {
        
        GeometryReader { geo in
            if (geo.frame(in: .named(coordinateSpaceName)).midY > 50) {
                Spacer()
                    .onAppear { needRefresh = true }
            } else if (geo.frame(in: .named(coordinateSpaceName)).maxY < -10) {
                Spacer()
                    .onAppear {
                        if needRefresh {
                            needRefresh = false
                            onRefresh()
                        }
                    }
            }
            HStack {
                Spacer()
                if needRefresh { ProgressView() } else { Image(systemName: "arrow.down") }
                Spacer()
            }
        }.padding(.top, -30)
    }
}
