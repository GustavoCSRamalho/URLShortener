import Foundation
import SwiftUI

enum ViewState: Equatable {
    case idle
    case loading
    case success
    case error(String)
}

@MainActor
@Observable
final class URLShortenerViewModel {
    
    private(set) var state: ViewState = .idle
    private(set) var shortenedURLs: [ShortenedURL] = []
    var inputURL: String = "" {
       didSet {
           validateInput()
       }
   }
    private(set) var isInputValid: Bool = false
    
    private let useCase: ShortenURLUseCase
    private let validator: URLValidator
    private var validationTask: Task<Void, Never>?
    
    init(
        useCase: ShortenURLUseCase,
        validator: URLValidator
    ) {
        self.useCase = useCase
        self.validator = validator
    }
    
    convenience init(repository: URLShortenerRepository) {
        let validator = URLValidator()
        let useCase = ShortenURLUseCase(
            repository: repository,
            validator: validator
        )
        self.init(useCase: useCase, validator: validator)
    }
    
    func validateInput() {
        validationTask?.cancel()
        
        validationTask = Task {
            try? await Task.sleep(nanoseconds: 300_000_000)
            
            guard !Task.isCancelled else { return }
            
            isInputValid = !inputURL.isEmpty && validator.isValid(url: inputURL)
        }
    }
    
    func shortenURL() {
        guard !inputURL.isEmpty else { return }
        
        Task {
            state = .loading
            
            do {
                let shortened = try await useCase.execute(url: inputURL)
                
                shortenedURLs.insert(shortened, at: 0)
                
                inputURL = ""
                state = .success
                
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                if state == .success {
                    state = .idle
                }
                
            } catch let error as URLShortenerError {
                state = .error(error.localizedDescription)
            } catch {
                state = .error("Erro inesperado: \(error.localizedDescription)")
            }
        }
    }
    
    func removeURL(at offsets: IndexSet) {
        shortenedURLs.remove(atOffsets: offsets)
    }
    
    func copyToClipboard(_ text: String) {
        #if os(iOS)
        UIPasteboard.general.string = text
        #elseif os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
        #endif
    }
    
    func retry() {
        state = .idle
    }
}

extension URLShortenerViewModel {
    static var preview: URLShortenerViewModel {
        let mockRepository = MockRepository()
        return URLShortenerViewModel(repository: mockRepository)
    }
    
    static var previewWithData: URLShortenerViewModel {
        let vm = URLShortenerViewModel.preview
        vm.shortenedURLs = ShortenedURL.mocks
        return vm
    }
}

final class MockRepository: URLShortenerRepository {
    func shortenURL(_ url: String) async throws -> ShortenedURL {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        return ShortenedURL(
            originalURL: url,
            shortURL: "https://short.url/abc123",
            alias: "abc123"
        )
    }
}
