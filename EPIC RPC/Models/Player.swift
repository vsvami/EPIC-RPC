//
//  User.swift
//  EPICRPS
//
//  Created by Vladimir Dmitriev on 12.06.24.
//

import Foundation

class Player {
    var currentMove: Move
    var score: Int
    private(set) var wins: Int
    private(set) var losses: Int
    var gamesPlayed: Int {
        return wins + losses
    }
    
    init(currentMove: Move, score: Int, wins: Int, losses: Int) {
        self.currentMove = currentMove
        self.score = score
        self.wins = wins
        self.losses = losses
    }
    
    enum Move {
        case ready
        case rock
        case paper
        case scissors
        
        var maleHandImage: String {
            switch self {
            case .ready:
                return "maleHand"
            case .rock:
                return "maleRock"
            case .paper:
                return "malePaper"
            case .scissors:
                return "maleScissors"
            }
        }
        
        var femaleHandImage: String {
            switch self {
            case .ready:
                return "femaleHand"
            case .rock:
                return "femaleRock"
            case .paper:
                return "femalePaper"
            case .scissors:
                return "femaleScissors"
            }
        }
        
        static func randomMoves() -> Move {
            let moves: [Move] = [.rock, .paper, .scissors]
            return moves[Int.random(in: 0..<moves.count)]
        }
    }
    
    func resetScore() {
        score = 0
    }
    
    func recordWin() {
        wins += 1
    }
    
    func recordLoss() {
        losses += 1
    }
}

class Game {
    var playerOne: Player
    var playerTwo: Player
    let maxScore = 3
    
    init(playerOne: Player, playerTwo: Player) {
        self.playerOne = playerOne
        self.playerTwo = playerTwo
    }
    
    func startRound(playerOneMove: Player.Move? = nil, playerTwoMove: Player.Move? = nil) {
        playerOne.currentMove = playerOneMove ?? .ready
        playerTwo.currentMove = playerTwoMove ?? .ready
    }
    
    func playRound(playerOneMove: Player.Move, playerTwoMove: Player.Move) -> String {
            
            playerOne.currentMove = playerOneMove
            playerTwo.currentMove = playerTwoMove
            
            let result = determineWinner(playerOneMove: playerOneMove, playerTwoMove: playerTwoMove)
            
            switch result {
            case .draw:
                return "DRAW"
            case .playerOneWins:
                playerOne.score += 1
                return ""
            case .playerTwoWins:
                playerTwo.score += 1
                return ""
            }
        }
    
    func endRoundDueToTimeout() {
        playerOne.score += 1
    }
    
    func determineWinner(playerOneMove: Player.Move, playerTwoMove: Player.Move) -> RoundResult {
        
        switch (playerOneMove, playerTwoMove) {
        case (.scissors, .rock), (.paper, .scissors), (.rock, .paper):
            return .playerTwoWins
        case (.rock, .scissors), (.scissors, .paper), (.paper, .rock):
            return .playerOneWins
        default:
            return .draw
        }
    }
    
    enum RoundResult {
        case draw
        case playerOneWins
        case playerTwoWins
    }
    
    func isGameOver() -> Bool {
        return playerOne.score >= maxScore || playerTwo.score >= maxScore
    }
    
    func getWinner() -> Player? {
        if playerOne.score >= maxScore {
            playerOne.recordWin()
            playerTwo.recordLoss()
            return playerOne
        } else if playerTwo.score >= maxScore {
            playerTwo.recordWin()
            playerOne.recordLoss()
            return playerTwo
        }
        return nil
    }
    
   func resetScores() {
        playerOne.resetScore()
        playerTwo.resetScore()
    }
}
