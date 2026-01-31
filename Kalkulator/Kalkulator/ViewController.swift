//
//  ViewController.swift
//  Kalkulator
//
//  Created by Jan Sakłak on 06/11/2025.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var wynik: UILabel!
    
    var firstNumber: Double = 0
    var currentOperation: String = ""
    var isTypingSecondNumber: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func number_clicked(_ sender: UIButton) {
        let digit = sender.titleLabel?.text ?? ""
        
        if isTypingSecondNumber {
            wynik.text = digit
            isTypingSecondNumber = false
        }
        else{
            let currentText = wynik.text ?? ""
            if currentText == "Wynik" || currentText == "0" {
                wynik.text = digit
            }
            else{
                wynik.text = currentText + digit
            }
        }
        
        
    }
    
    @IBAction func delete_number(_ sender: Any) {
        guard var currentText = wynik.text, currentText != "Wynik", !currentText.isEmpty else {
            return
        }
        
        currentText.removeLast()
        
        if currentText.isEmpty {
            wynik.text = "0"
        } else {
            wynik.text = currentText
        }
    }
    
    @IBAction func sum_sign(_ sender: UIButton) {
        let sign = sender.titleLabel?.text ?? ""
        if let currentNumberText = wynik.text, let number = Double(currentNumberText) {
            firstNumber = number
        }
        currentOperation = sign
        isTypingSecondNumber = true
    }
    
    @IBAction func equal_sign(_ sender: UIButton) {
        guard !currentOperation.isEmpty else { return }
        var result: Double = 0
        
        guard let secondNumberText = wynik.text else { return }
        let formattedText = secondNumberText.replacingOccurrences(of: ",", with: ".")
        guard let secondNumber = Double(formattedText) else {
            print("Nie można przekonwertować: \(secondNumberText)")
            return
        }
        
        switch currentOperation {
        case "+": result = firstNumber + secondNumber
        case "-": result = firstNumber - secondNumber
        case "*": result = firstNumber * secondNumber
        case "/": result = firstNumber / secondNumber
        default: break
        }
        
        if result.truncatingRemainder(dividingBy: 1) == 0 {
            wynik.text = String(Int(result))
        } else {
            wynik.text = String(result)
        }
        
        firstNumber = result
        isTypingSecondNumber = false
        currentOperation = ""
    }

                
}

