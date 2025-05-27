import Foundation
import SwiftData

@Model
final class ClipboardItem: Identifiable {
    @Attribute(.unique) var id: UUID
    var content: String
    var date: Date
    var isPinned: Bool

    init(content: String, date: Date = Date(), isPinned: Bool = false) {
        self.id = UUID()
        self.content = content
        self.date = date
        self.isPinned = isPinned
    }
} 