import Foundation
import SwiftUI

@MainActor
final class PinnedGridViewModel: ObservableObject {
    @Published var items: [ClipboardItem] = []
    private let dataStore = ClipboardDataStore.shared
    private var clipboardMonitor: ClipboardMonitor? = nil

    init() {
        fetchItems()
        clipboardMonitor = ClipboardMonitor.shared
        clipboardMonitor?.onClipboardChange = { [weak self] in
            self?.fetchItems()
        }
    }

    func fetchItems() {
        items = dataStore.fetchAll().filter { $0.isPinned }.prefix(9).map { $0 }
    }

    func togglePin(for item: ClipboardItem) {
        item.isPinned.toggle()
        dataStore.update(item)
        fetchItems()
    }
} 