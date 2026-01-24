import SwiftUI

struct PaymentFormView: View {
    let product: Product
    let onSubmit: (PaymentDetails) async throws -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var cardholderName: String = ""
    @State private var cardNumber: String = ""
    @State private var expiryMonth: String = ""
    @State private var expiryYear: String = ""
    @State private var cvv: String = ""
    @State private var isProcessing = false
    @State private var errorMessage: String?

    var body: some View {
        Form {
            Section(header: Text("Produkt")) {
                Text(product.name)
                Text(product.price.currencyString).foregroundStyle(.secondary)
            }
            
            Section(header: Text("Dane karty")) {
                TextField("Imię i nazwisko na karcie", text: $cardholderName)
                TextField("Numer karty", text: $cardNumber)
                    .keyboardType(.numberPad)
                HStack {
                    TextField("MM", text: $expiryMonth)
                        .frame(width: 50)
                        .keyboardType(.numberPad)
                    Text("/")
                    TextField("RRRR", text: $expiryYear)
                        .frame(width: 80)
                        .keyboardType(.numberPad)
                }
                TextField("CVV", text: $cvv)
                    .frame(width: 80)
                    .keyboardType(.numberPad)
            }
            
            if let errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }

            Section {
                Button {
                    Task {
                        isProcessing = true
                        errorMessage = nil
                        do {
                            let details = PaymentDetails(
                                cardholderName: cardholderName,
                                cardNumber: cardNumber,
                                expiryMonth: Int(expiryMonth) ?? 0,
                                expiryYear: Int(expiryYear) ?? 0,
                                cvv: cvv
                            )
                            try await onSubmit(details)
                            dismiss()
                        } catch {
                            errorMessage = error.localizedDescription
                        }
                        isProcessing = false
                    }
                } label: {
                    if isProcessing {
                        ProgressView()
                    } else {
                        Text("Zapłać")
                    }
                }
                .disabled(isProcessing || cardholderName.isEmpty || cardNumber.isEmpty || expiryMonth.isEmpty || expiryYear.isEmpty || cvv.isEmpty)
            }
        }
        .navigationTitle("Płatność")
        .interactiveDismissDisabled(isProcessing)
    }
}
