//
//  TextFieldVieww.swift
//  Anketa
//
//  Created by Артём Иващенко on 31/05/24.
//

import SwiftUI

enum TextFieldState {
    case string
    case phoneNumber
    case email
    case date
    case address
    case numbers
}

struct CustomTextField: UIViewRepresentable {
    @Binding var text: String
    var state: TextFieldState
    var placeholder: String
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CustomTextField
        var datePicker: UIDatePicker?

        init(parent: CustomTextField) {
            self.parent = parent
            super.init()
            
            if parent.state == .date {
                let datePicker = UIDatePicker()
                datePicker.datePickerMode = .date
                datePicker.preferredDatePickerStyle = .wheels
                datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -8, to: Date())
                datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -100, to: Date())
                datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
                self.datePicker = datePicker
            }
        }

        @objc func dateChanged(_ sender: UIDatePicker) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            parent.text = formatter.string(from: sender.date)
        }

        func textFieldDidBeginEditing(_ textField: UITextField) {
            if let datePicker = datePicker {
                textField.inputView = datePicker
            }
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }


        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            switch parent.state {
            case .string:
                let filetered = updatedText.filter { $0.isLetter || $0.isWhitespace }
                parent.text = filetered
                return false
            case .phoneNumber:
                let filtered = updatedText.filter { $0.isNumber }
                if filtered.count <= 11 {
                    parent.text = formatPhoneNumber(filtered)
                }
                return false
            case .email:
                let filetered = updatedText.filter { $0.isLetter || $0.isNumber || $0 == "@" || $0 == "." || $0 == "_" || $0 == "-" }
                parent.text = filetered
                return false
            case .date:
                return false
            case .address:
                let filetered = updatedText.filter { $0.isLetter || $0.isNumber || $0 == "." || $0 == "," || $0.isWhitespace }
                parent.text = filetered
                return false
            case .numbers:
                let filetered = updatedText.filter { $0.isNumber }
                parent.text = filetered
                return false
            }
        }
        
        private func formatPhoneNumber(_ number: String) -> String {
            var formattedNumber = ""
            let numbers = Array(number)
            for (index, digit) in numbers.enumerated() {
                if index == 0 {
                    formattedNumber.append("+7 (")
                } else if index == 1 {
                    formattedNumber.append("\(digit)")
                } else if index == 4 {
                    formattedNumber.append(") \(digit)")
                } else if index == 7 {
                    formattedNumber.append(" \(digit)")
                } else if index == 9 {
                    formattedNumber.append(" \(digit)")
                } else {
                    formattedNumber.append("\(digit)")
                }
            }
            return formattedNumber
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.delegate = context.coordinator
        textField.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 0.7)
        textField.layer.borderWidth = 2
        textField.textColor = .white
        textField.backgroundColor = .clear
        textField.layer.cornerRadius = 12
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 20))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        if let placeholder = textField.placeholder {
            textField.attributedPlaceholder = NSAttributedString(
                string:placeholder,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.7)]
            )
        }
        
        switch state {
        case .phoneNumber, .numbers:
            textField.keyboardType = .numberPad
        case .email:
            textField.keyboardType = .emailAddress
        case .date:
            textField.keyboardType = .numbersAndPunctuation
        default:
            textField.keyboardType = .default
        }
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
}

struct TextFieldView: View {
    var title: String
    @Binding var text: String
    var state: TextFieldState
    var placeholder: String
    
    var body: some View {
        VStack(spacing: 5) {
            Text(title)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 4)
            
            CustomTextField(
                text: $text,
                state: state,
                placeholder: placeholder
            )
            .frame(maxWidth: .infinity)
            .frame(height: 50)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        @State var stringText = ""
        
        TextFieldView(
            title: "Qwerty String",
            text: $stringText,
            state: .date,
            placeholder: "Qwerty String"
        )
        .background(.black)
    }
}
