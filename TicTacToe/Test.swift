//
//  Test.swift
//  TicTacToe
//
//  Created by Kusal on 2024-03-11.
//

import SwiftUI

struct Test: View {
    @State private var alertItem: AlertItem?
        
        var body: some View {
            VStack {
                Button("Show Alert") {
                    self.alertItem = AlertContext.invalidInput
                   
                }
            }
            .alert(item: $alertItem) { alertItem in
                Alert(
                    title: alertItem.title,
                    message: alertItem.message,
                    dismissButton: .default(alertItem.buttonText) {
                        
                    }
                )
            }
        }
}

#Preview {
    Test()
}
