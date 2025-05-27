import Foundation
import AppKit

final class ClipboardMonitor: ObservableObject {
    static let shared = ClipboardMonitor()
    private var timer: Timer?
    private var lastChangeCount: Int = NSPasteboard.general.changeCount
    var onClipboardChange: (() -> Void)?

    func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.checkClipboard()
        }
    }

    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }

    private func checkClipboard() {
        let pasteboard = NSPasteboard.general
        if pasteboard.changeCount != lastChangeCount {
            lastChangeCount = pasteboard.changeCount
            if let content = pasteboard.string(forType: .string), !content.isEmpty {
                Task { @MainActor in
                    let existing = ClipboardDataStore.shared.fetchAll().first { $0.content == content }
                    if existing == nil {
                        ClipboardDataStore.shared.add(ClipboardItem(content: content))
                        self.onClipboardChange?()
                    }
                }
            }
        }
    }
} 