import Foundation

@Observable
final class AppDependencyContainer {
    
    @MainActor
    func makeURLShortenerViewModel() -> URLShortenerViewModel {
        let network = NetworkService()
        let repository = URLShortenerRepositoryImpl(networkService: network)
        let validator = URLValidator()
        let useCase = ShortenURLUseCase(repository: repository, validator: validator)
        
        return URLShortenerViewModel(useCase: useCase, validator: validator)
    }
}
