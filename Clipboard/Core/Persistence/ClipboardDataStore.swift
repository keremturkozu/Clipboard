import Foundation
import SwiftData

@MainActor
final class ClipboardDataStore {
    static let shared = ClipboardDataStore()
    private let container: ModelContainer

    private init() {
        container = try! ModelContainer(for: ClipboardItem.self)
    }

    var context: ModelContext {
        container.mainContext
    }

    func fetchAll() -> [ClipboardItem] {
        let descriptor = FetchDescriptor<ClipboardItem>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        return (try? context.fetch(descriptor)) ?? []
    }

    func add(_ item: ClipboardItem) {
        context.insert(item)
        try? context.save()
    }

    func update(_ item: ClipboardItem) {
        try? context.save()
    }

    func delete(_ item: ClipboardItem) {
        context.delete(item)
        try? context.save()
    }
} 
