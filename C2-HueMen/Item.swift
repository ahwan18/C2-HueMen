//
//  Item.swift
//  C2-HueMen
//
//  Created by Ahmad Kurniawan Ibrahim on 08/05/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
