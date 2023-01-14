//
//  String.swift
//  Solance
//
//  Created by Alexander Senin on 15.12.2022.
//

import Foundation

extension String {
    
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    var doubleValue: Double {
        return (self as NSString).doubleValue
    }
}
