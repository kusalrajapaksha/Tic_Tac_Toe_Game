//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by Kusal on 2024-03-11.
//

import Foundation
import SwiftUI

final class GameViewModel: ObservableObject {
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var gameBoardDisabled = false
    @Published var alertItem: AlertItem?
    @Published var showYourTurn: Bool = true
    @Published var gameOver: Bool = false
    
    
    @Published var computerPoints: Int = 0
    @Published var humanPoints: Int = 0
    
    func processPlayerMove(for position: Int){
        if isSquareOccupied(in: moves, forIndex: position){
            return
        }
        moves[position] = Move(player: .human, boardIndex: position)
        
        showYourTurn = false
        gameBoardDisabled = true
       
        //Check for win condition or draw
        if checkWinCondition(for: .human, in: moves){
            humanPoints += 1
            
            if humanPoints < 3{
                alertItem = AlertContext.humanWin
            }else{
                gameOver = true
                gameBoardDisabled = true
            }
            
            return
        }
        
        if checkDrawConditions(in: moves){
            alertItem = AlertContext.draw
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [self] in
            let computerPosition = determineComputerMovePosition(in: moves)
            moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            gameBoardDisabled = false
            showYourTurn = true
            
            if checkWinCondition(for: .computer, in: moves){
                computerPoints += 1
              
                if computerPoints < 3{
                    alertItem = AlertContext.computerWin
                }else{
                    gameOver = true
                    gameBoardDisabled = true
                }
                
                return
            }
            
            if checkDrawConditions(in: moves){
                alertItem = AlertContext.draw
                return
            }
        })
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: {$0?.boardIndex == index})
    }
    
    //--If AI can win, then win
    //--If AI can't win, then block
    //--If AI can't block, then take middle square
    //--If AI can't take middle square, take random available square
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
        
        //--If AI can win, then win
        let computerMoves = moves.compactMap({$0}).filter({$0.player == .computer})
        let computerPositions = Set(computerMoves.map({$0.boardIndex}))
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPositions)
            
            if winPositions.count == 1{
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable { return winPositions.first!}
            }
        }
        
        //--If AI can't win, then block
        let humanMoves = moves.compactMap({$0}).filter({$0.player == .human})
        let humanPositions = Set(humanMoves.map({$0.boardIndex}))
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPositions)
            
            if winPositions.count == 1{
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable { return winPositions.first!}
            }
        }
        
        //--If AI can't block, then take middle square
        let centerSquare = 4
        if !isSquareOccupied(in: moves, forIndex: centerSquare){
            return centerSquare
        }
        
        //--If AI can't take middle square, take random available square
        var movePosition = Int.random(in: 0..<9)
        while isSquareOccupied(in: moves, forIndex: movePosition){
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        let winPatters: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
        
        let playerMoves = moves.compactMap({$0}).filter({$0.player == player})
        let playerPositions = Set(playerMoves.map({$0.boardIndex}))
        
        for pattern in winPatters where pattern.isSubset(of: playerPositions){
            return true
        }
        
        return false
    }
    
    func checkDrawConditions(in moves: [Move?]) -> Bool {
        return moves.compactMap({$0}).count == 9
    }
    
    func resetGameRound(){
        moves = Array(repeating: nil, count: 9)
        gameBoardDisabled = false
        showYourTurn = true
    }
    
    func resetGame(){
        moves = Array(repeating: nil, count: 9)
        gameBoardDisabled = false
        showYourTurn = true
        gameOver = false
        computerPoints = 0
        humanPoints = 0
    }
}
