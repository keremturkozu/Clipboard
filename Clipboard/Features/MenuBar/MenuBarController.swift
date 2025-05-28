import AppKit
import SwiftUI

final class MenuBarController: NSObject {
    private var statusItem: NSStatusItem!
    private var popover: NSPopover!

    override init() {
        super.init()
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "doc.on.clipboard", accessibilityDescription: "Clipboard")
            button.action = #selector(togglePopover(_:))
            button.target = self
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        popover = NSPopover()
        popover.contentSize = NSSize(width: 480, height: 450)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: ClipboardMenuView())
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        guard let event = NSApp.currentEvent else { return }
        if event.type == .rightMouseUp {
            if popover.isShown { popover.performClose(sender) }
            showMenu()
            return
        }
        if let button = statusItem.button {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }

    private func showMenu() {
        let menu = NSMenu()

        let aboutItem = NSMenuItem(title: "About", action: #selector(showAbout), keyEquivalent: "i")
        aboutItem.target = self
        menu.addItem(aboutItem)

        let supportItem = NSMenuItem(title: "Support", action: #selector(openSupport), keyEquivalent: "s")
        supportItem.target = self
        menu.addItem(supportItem)

        let privacyItem = NSMenuItem(title: "Privacy Policy", action: #selector(openPrivacyPolicy), keyEquivalent: "p")
        privacyItem.target = self
        menu.addItem(privacyItem)

        menu.addItem(NSMenuItem.separator())

        let quitItem = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem.menu = menu
        statusItem.button?.performClick(nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.statusItem.menu = nil
        }
    }

    @objc private func showAbout() {
        let alert = NSAlert()
        alert.messageText = "CopyBoard – Quick Paste"
        alert.informativeText = "A modern, privacy-first menubar clipboard app for macOS. Pin, copy, and organize your clips instantly."
        alert.alertStyle = .informational
        alert.runModal()
    }

    @objc private func openSupport() {
        if let url = URL(string: "mailto:turkozukerem@gmail.com") {
            NSWorkspace.shared.open(url)
        }
    }

    @objc private func openPrivacyPolicy() {
        if let url = URL(string: "https://keremturkozu.github.io/copyboard-privacy.html") {
            NSWorkspace.shared.open(url)
        }
    }

    @objc private func quitApp() {
        NSApp.terminate(nil)
    }
} 