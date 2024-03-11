//
//  GameModel.swift
//  TicTacToe
//
//  Created by Kusal on 2024-03-11.
//

import Foundation

enum Player{
    case human, computer
}

struct Move{
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}
