import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @StateObject private var auth = AuthService.shared

    var body: some View {
        VStack(spacing: 30) {
            Text("Logowanie").font(.largeTitle).bold()

            VStack(spacing: 15) {
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                
                SecureField("Hasło", text: $password)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.horizontal)

            Button("Zaloguj klasycznie") {
                Task {
                    await auth.login(email: email, password: password)
                }
            }
            .buttonStyle(.borderedProminent)

            Divider().padding()

            HStack(spacing: 20) {
                Button("Google") {
                    openOAuth(provider: "google")
                }
                
                Button("GitHub") {
                    openOAuth(provider: "github")
                }
            }
            .buttonStyle(.bordered)
        }
    }

    private func openOAuth(provider: String) {
        if let url = URL(string: "http://localhost:3000/oauth/\(provider)") {
            UIApplication.shared.open(url)
        }
    }
}
