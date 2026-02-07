import SwiftUI

struct URLInputSection: View {
    
    @Binding var inputURL: String
    @FocusState.Binding var isInputFocused: Bool
    
    let isInputValid: Bool
    let isLoading: Bool
    let onSubmit: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Cole ou digite a URL")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack(spacing: 12) {
                TextField("https://example.com", text: $inputURL)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .focused($isInputFocused)
                    .onSubmit {
                        if isInputValid {
                            onSubmit()
                        }
                    }
                    .accessibilityIdentifier("urlInput")
                
                Button(action: onSubmit) {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.title2)
                        .foregroundColor(isInputValid ? .accentColor : .gray)
                }
                .disabled(!isInputValid || isLoading)
                .accessibilityIdentifier("shortenButton")
                .accessibilityLabel("Encurtar URL")
            }
            
            if !inputURL.isEmpty && !isInputValid {
                Label("URL inválida", systemImage: "exclamationmark.triangle.fill")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
}

#Preview {
    URLInputSectionPreview()
}

private struct URLInputSectionPreview: View {
    @State private var inputURL = ""
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            URLInputSection(
                inputURL: $inputURL,
                isInputFocused: $isInputFocused,
                isInputValid: false,
                isLoading: false,
                onSubmit: {}
            )
            .padding()
            
            URLInputSection(
                inputURL: .constant("https://apple.com"),
                isInputFocused: $isInputFocused,
                isInputValid: true,
                isLoading: false,
                onSubmit: {}
            )
            .padding()
            
            URLInputSection(
                inputURL: .constant("invalid"),
                isInputFocused: $isInputFocused,
                isInputValid: false,
                isLoading: false,
                onSubmit: {}
            )
            .padding()
        }
    }
}
