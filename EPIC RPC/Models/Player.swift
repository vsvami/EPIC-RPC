//
//  User.swift
//  EPICRPS
//
//  Created by Vladimir Dmitriev on 12.06.24.
//

struct Player {
    let name: String
    let choice: [String]
    let scoreInGame: Int
    let TotalScore: Int
    
    let numberOfGames: Int
    let numberOfWins: Int
    
    var resultInPercent: String {
        String(format: "%.2f %", numberOfWins / numberOfGames * 100)
    }
    
    static func getPlayer() -> Player {
        Player(
            name: "Player 1",
            choice: ["maleRock", "maleScissors", "malePaper", "maleHand"],
            scoreInGame: 0,
            TotalScore: 0,
            numberOfGames: 0,
            numberOfWins: 0
        )
    }
}

