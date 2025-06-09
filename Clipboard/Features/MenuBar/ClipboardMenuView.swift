import SwiftUI

struct ClipboardMenuView: View {
    @State private var selectedTab = 0
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color.modernGridBG
                Picker("", selection: $selectedTab) {
                    Text("Clips").tag(0)
                    Text("Pins").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding([.top, .horizontal])
            }
            .frame(height: 44)
            if selectedTab == 0 {
                ClipboardGridView()
            } else {
                PinnedGridView()
            }
        }
        .frame(width: 480, height: 450)
        .preferredColorScheme(.light)
    }
} 