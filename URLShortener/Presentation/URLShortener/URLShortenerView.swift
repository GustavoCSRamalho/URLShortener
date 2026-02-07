import SwiftUI

struct URLShortenerView: View {
    
    @State private var viewModel: URLShortenerViewModel
    @FocusState private var isInputFocused: Bool
    
    init(viewModel: URLShortenerViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    URLInputSection(
                        inputURL: $viewModel.inputURL,
                        isInputFocused: $isInputFocused,
                        isInputValid: viewModel.isInputValid,
                        isLoading: viewModel.state == .loading,
                        onSubmit: {
                            viewModel.shortenURL()
                            isInputFocused = false
                        }
                    )
                    .padding()
                    .background(Color(.white))
                    
                    Divider()
                    
                    urlListSection
                }
                
                if viewModel.state == .loading {
                    LoadingView()
                }
            }
            .navigationTitle("URL Shortener")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            #endif
            .alert(
                "Erro",
                isPresented: .constant(isErrorState),
                presenting: errorMessage
            ) { _ in
                Button("OK") {
                    viewModel.retry()
                }
            } message: { message in
                Text(message)
            }
        }
    }
    
    private var isErrorState: Bool {
        if case .error = viewModel.state {
            return true
        }
        return false
    }
    
    private var errorMessage: String? {
        if case .error(let message) = viewModel.state {
            return message
        }
        return nil
    }
    
    @ViewBuilder
    private var urlListSection: some View {
        if viewModel.shortenedURLs.isEmpty {
            EmptyStateView()
        } else {
            List {
                ForEach(viewModel.shortenedURLs) { url in
                    URLListItem(
                        shortenedURL: url,
                        onCopy: { text in
                            viewModel.copyToClipboard(text)
                        }
                    )
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .listRowSeparator(.hidden)
                }
                .onDelete(perform: viewModel.removeURL)
            }
            .listStyle(.plain)
            .accessibilityIdentifier("urlList")
        }
    }
}

#Preview("Empty State") {
    URLShortenerView(viewModel: .preview)
}

#Preview("With Data") {
    URLShortenerView(viewModel: .previewWithData)
}

#Preview("Dark Mode") {
    URLShortenerView(viewModel: .previewWithData)
        .preferredColorScheme(.dark)
}
