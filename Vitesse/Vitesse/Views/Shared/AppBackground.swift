import SwiftUI

struct AppBackground: View {
    var body: some View {
        LinearGradient(colors: [
            Color.accentColor.opacity(0.25),
            Color.blue.opacity(0.15),
            Color(.systemBackground)
        ], startPoint: .topLeading, endPoint: .bottomTrailing)
        .ignoresSafeArea()
    }
}

#Preview {
    AppBackground()
}
