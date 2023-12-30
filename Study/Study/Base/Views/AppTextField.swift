//
//  AppTextField.swift
//  Study
//
//  Created by habil . on 30/12/23.
//

import SwiftUI

struct AppTextField: View {
    let title: String
    @Binding private var text: String
    @Binding private var textFocus: Bool
    var isSecure: Bool = false
    
    init(title: String, text: Binding<String>, textFocus: Binding<Bool>, isSecure: Bool = false) {
        self.title = title
        self._text = text
        self._textFocus = textFocus
        self.isSecure = isSecure
    }
    
    var body: some View {
        if isSecure {
            SecureField(title, text: $text, onCommit: onCommit)
                .onTapGesture {
                    textFocus = true
                }
                .textInputAutocapitalization(.none)
                .textContentType(.password)
                .overlay{
                    overlayBorderColor(active: $textFocus)
                }
                .textFieldStyle(.roundedBorder)
        } else {
            TextField(title, text: $text, onEditingChanged: getFocus, onCommit: onCommit)
                .textInputAutocapitalization(.never)
                .overlay{
                    overlayBorderColor(active: $textFocus)
                }
                .textFieldStyle(.roundedBorder)
        }
    }
    
    func getFocus(focused: Bool) {
        textFocus = focused
    }
    
    func onCommit() {
        textFocus = false
    }
}

fileprivate extension View {
    @ViewBuilder
    func overlayBorderColor(active: Binding<Bool>) -> some View{
        if active.wrappedValue {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.blue, lineWidth: 2)
        }else{
            RoundedRectangle(cornerRadius: 10)
                .stroke(.placeholder, lineWidth: 1)
        }
    }
}

#Preview {
    return AppTextField(title: "Email", text: .constant(""), textFocus: .constant(false))
}
