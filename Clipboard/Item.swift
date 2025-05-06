//
//  Item.swift
//  Clipboard
//
//  Created by Kerem Türközü on 6.05.2025.
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
