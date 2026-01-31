import SwiftUI

@main
struct OauthTaskApp: App {
    @StateObject private var authService = AuthService.shared

    var body: some Scene {
        WindowGroup {
            Group {
                if authService.isLoggedIn {
                    ContentView()
                } else {
                    LoginView()
                }
            }
            .onOpenURL { url in
                handleDeepLink(url)
            }
        }
    }

    private func handleDeepLink(_ url: URL) {
        guard url.scheme == "oauthtask" else { return }
        
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let tokenItem = components.queryItems?.first(where: { $0.name == "token" })?.value {
            authService.token = tokenItem
        }
    }
}
