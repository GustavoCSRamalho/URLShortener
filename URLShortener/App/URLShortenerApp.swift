import SwiftUI

@main
struct URLShortenerApp: App {
    @State private var dependencyContainer = AppDependencyContainer()
    
    var body: some Scene {
        WindowGroup {
            URLShortenerView(
                viewModel: dependencyContainer.makeURLShortenerViewModel()
            )
        }
    }
}
