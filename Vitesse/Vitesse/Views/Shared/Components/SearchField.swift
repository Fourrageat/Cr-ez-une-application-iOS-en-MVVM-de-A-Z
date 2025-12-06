import SwiftUI

public struct SearchField: View {
    @Binding var text: String
    var placeholder: String

    public init(text: Binding<String>, placeholder: String = "Search") {
        self._text = text
        self.placeholder = placeholder
    }

    public var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                .padding(.leading, 8)
            TextField(placeholder, text: $text)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .submitLabel(.search)
        }
        .padding(.vertical, 14)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}

#Preview {
    struct SearchField_PreviewWrapper: View {
        @State private var query: String = ""
        var body: some View {
            ZStack {
                VStack {
                    SearchField(text: $query)
                }
            }
        }
    }
    return SearchField_PreviewWrapper()
}
