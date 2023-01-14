//
//  SendSolanaViewModel.swift
//  Solance
//
//  Created by Alexander Senin on 18.12.2022.
//

import Combine

enum InputDataError: Error {
    case invalidRecipientAddress
    case invalidAmount
    case insufficientBalance(solNeeded: Double)
}

@MainActor
class SendSolanaViewModel: ObservableObject {
    
    @Published var fee = 0.000005
    
    @Published var recipientAddress = ""
    @Published var amount = ""
    @Published var resultText = ""
    
    @Published var showAlert = false
    @Published var showConfirmation = false
    
    @Published private(set) var state = ViewState.loading
    
    func sendTransaction() async {
        do {
            let transactionId = try await TransactionManager.shared.sendTransaction(to: recipientAddress, amount: convertAmount(amount)).get()
            resultText = "Transaction\n\(transactionId.prefix(4))...\(transactionId.suffix(4))\nwas sucessfully sent."
            resultText += "\n\nYou can check it in your Transaction History."
            state = .ready
        } catch {
            resultText = error.localizedDescription
        }
        showAlert.toggle()
    }
    
    func validateCredentials() {
        do {
            try validateAmount(amount.replacingOccurrences(of: ",", with: "."))
            showConfirmation = true
        } catch InputDataError.invalidRecipientAddress {
            resultText = "Please, check the recipient address."
            showAlert = true
        }
        catch InputDataError.invalidAmount {
            resultText = "Please, check the entered amount."
            showAlert = true
        }
        catch InputDataError.insufficientBalance(let solNeeded) {
            resultText = "Insufficient balance.\n(\(String(format: "%.9f", solNeeded).doubleValue) more SOL needed)"
            showAlert = true
        }
        catch {
            resultText = "Unexpected error: \(error.localizedDescription)."
            showAlert = true
        }
    }
    
    private func validateAmount(_ amount: String) throws {
        let shortPattern = #"^[-]?(\d+)$"#
        let fullPattern = #"^[-]?(\d+)[.,]?(\d+)$"#
        let amountWithFee = amount.doubleValue + fee
        
        guard recipientAddress.count == 44 else { throw InputDataError.invalidRecipientAddress }
        
        guard amount.matches(shortPattern) || amount.matches(fullPattern) else { throw InputDataError.invalidAmount }
        
        guard amountWithFee > fee else { throw InputDataError.invalidAmount }
    }
    
    private func convertAmount(_ amount: String) -> UInt64 {
        let fixedString = amount.replacingOccurrences(of: ",", with: ".")
        let stringToDouble = fixedString.doubleValue
        let doubleToUint = stringToDouble * 1000000000
        return UInt64(doubleToUint)
    }
}
