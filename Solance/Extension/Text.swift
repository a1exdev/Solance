//
//  Text.swift
//  Solance
//
//  Created by Alexander Senin on 15.12.2022.
//

import SwiftUI

extension Text {
    
    public func foregroundLinearGradient(colors: [Color], startPoint: UnitPoint, endPoint: UnitPoint) -> some View {
        self.overlay {
            LinearGradient(colors: colors, startPoint: startPoint, endPoint: endPoint)
                .mask(self)
        }
    }
}
