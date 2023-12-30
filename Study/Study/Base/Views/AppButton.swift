//
//  AppButton.swift
//  Study
//
//  Created by habil . on 30/12/23.
//

import SwiftUI

struct AppButton: View {
    let label: String
    var action: () -> Void
    var disable: Bool
    var loading: Bool
    
    init(label: String, disable: Bool, loading: Bool, action: @escaping () -> Void) {
        self.label = label
        self.action = action
        self.disable = disable
        self.loading = loading
    }
    
    var body: some View {
        Button{
            action()
        } label: {
            if loading {
                ProgressView()
                    .tint(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(disable || loading ? .gray : .blue)
                    .clipShape(.rect(cornerRadius: 8))
            } else {
                Text(label)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(disable || loading ? .gray : .blue)
                    .foregroundStyle(.white)
                    .clipShape(.rect(cornerRadius: 8))
            }
        }
    }
}

#Preview {
    AppButton(label: "Login", disable: false, loading: false, action: {})
}
