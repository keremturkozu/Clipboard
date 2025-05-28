import SwiftUI
import AppKit

struct ClipboardGridView: View {
    @StateObject private var viewModel = ClipboardGridViewModel()
    private let columns = Array(repeating: GridItem(.flexible(minimum: 120, maximum: 150), spacing: 12), count: 3)
    @State private var copiedItemID: UUID?

    var body: some View {
        ZStack {
            Color.modernGridBG.ignoresSafeArea()
        ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                ForEach(viewModel.items) { item in
                        ClipboardGridCard(item: item,
                                          isCopied: copiedItemID == item.id,
                                          onPin: { viewModel.togglePin(for: item) },
                                          onCopy: {
                            copyToPasteboard(item.content)
                            withAnimation(.spring()) { copiedItemID = item.id }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                withAnimation { copiedItemID = nil }
                            }
                        })
                    }
                    if viewModel.items.count < 9 {
                        ForEach(viewModel.items.count..<9, id: \ .self) { _ in
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                                .background(VisualEffectBlur())
                                .frame(height: 120)
                                .opacity(0.4)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .onAppear { viewModel.fetchItems() }
    }

    private func copyToPasteboard(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
}

struct ClipboardGridCard: View {
    let item: ClipboardItem
    let isCopied: Bool
    let onPin: () -> Void
    let onCopy: () -> Void
    @State private var isHovering = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.modernCardBG)
                .shadow(color: .black.opacity(isHovering ? 0.10 : 0.04), radius: isHovering ? 8 : 3, x: 0, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(isCopied ? Color.modernAccent : Color.clear, lineWidth: 2)
                )
                .animation(.easeInOut(duration: 0.2), value: isHovering)
            VStack(alignment: .leading, spacing: 8) {
                Spacer(minLength: 8)
                            Text(item.content)
                                .font(.body)
                    .lineLimit(5)
                    .truncationMode(.tail)
                                .foregroundColor(.primary)
                    .padding(.horizontal, 10)
                    .padding(.top, 8)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            VStack {
                HStack {
                    Spacer()
                    Button(action: onPin) {
                            Image(systemName: item.isPinned ? "pin.fill" : "pin")
                            .foregroundColor(item.isPinned ? .red : .gray)
                            .padding(7)
                            .background(.thinMaterial, in: Circle())
                            .shadow(radius: 1)
                }
                    .buttonStyle(PlainButtonStyle())
                }
                Spacer()
            }
            .padding(8)
            if isCopied {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Label("Copied!", systemImage: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundColor(.black)
                            .padding(8)
                            .background(.ultraThinMaterial, in: Capsule())
                            .shadow(radius: 2)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        Spacer()
                    }
                    Spacer()
                }
                .zIndex(1)
            }
        }
        .frame(height: 120)
        .onTapGesture(perform: onCopy)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovering = hovering
            }
        }
        .scaleEffect(isHovering ? 1.03 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovering)
                }
            }

// macOS için blur efekti
// struct VisualEffectBlur: NSViewRepresentable {
//     func makeNSView(context: Context) -> NSVisualEffectView {
//         let view = NSVisualEffectView()
//         view.material = .sidebar
//         view.blendingMode = .withinWindow
//         view.state = .active
//         return view
//     }
//     func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
// } 
