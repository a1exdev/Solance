//
//  RouterView.swift
//  Solance
//
//  Created by Alexander Senin on 22.12.2022.
//

import SwiftUI

struct RouterView<T: Hashable, Content: View>: View {
    
    @ObservedObject
    var router: Router<T>
    
    @ViewBuilder var buildView: (T) -> Content
    var body: some View {
        NavigationStack(path: $router.paths) {
            buildView(router.root)
            .navigationDestination(for: T.self) { path in
                buildView(path)
            }
        }
        .environmentObject(router)
    }
}
