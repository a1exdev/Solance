//
//  Transaction.swift
//  Solance
//
//  Created by Alexander Senin on 16.05.2022.
//

import Foundation

struct Transaction: Identifiable, Codable {
    var id = UUID()
    var timestamp: UInt64?
    var slot: UInt64?
    var recentBlockhash: String
}
