//
//  Alerts.swift
//  TicTacToe
//
//  Created by Kusal on 2024-03-11.
//

import Foundation
import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonText: Text
}

struct AlertContext {
    static let humanWin = AlertItem(title: Text("You won this round!").foregroundColor(Color.blue),
                            message: Text("You are so smart. You won against your own AI"),
                            buttonText: Text("Hell yeah")
    )
    
    static let computerWin = AlertItem(title: Text("Oops, You lost this round!").foregroundColor(Color.red),
                            message: Text("You programmed a super AI"),
                            buttonText: Text("Rematch")
    )
    
    static let draw = AlertItem(title: Text("Draw!").foregroundColor(Color.yellow),
                            message: Text("What a battle...So close"),
                            buttonText: Text("Try again!")
    )
    
    static let invalidInput = AlertItem(
            title: Text("Invalid Input"),
            message: Text("Please enter valid numbers for the operation."),
            buttonText: Text("Got it")
        )
}


