//
//  NavigationBarModifier.swift
//  Solance
//
//  Created by Alexander Senin on 09.05.2022.
//

import SwiftUI

struct NavigationBarModifier: ViewModifier {

    var backgroundColor: UIColor?
    var titleColor: UIColor?

    init(backgroundColor: UIColor?, titleColor: UIColor?) {
        
        self.backgroundColor = backgroundColor
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        navigationBarAppearance.backgroundColor = .clear
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: titleColor ?? .white]
        navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor ?? .white]
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().tintColor = UIColor(Color.white)
        
        let toolbarAppearance = UIToolbarAppearance()
        toolbarAppearance.configureWithTransparentBackground()
        toolbarAppearance.backgroundColor = .clear
        UIToolbar.appearance().standardAppearance = toolbarAppearance
        UIToolbar.appearance().compactAppearance = toolbarAppearance
        if #available(iOS 15.0, *) { UIToolbar.appearance().scrollEdgeAppearance = toolbarAppearance }
    }

    func body(content: Content) -> some View {
        ZStack{
            content
            VStack {
                GeometryReader { geometry in
                    Color(self.backgroundColor ?? .clear)
                        .frame(height: geometry.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                    Spacer()
                }
            }
        }
    }
}
