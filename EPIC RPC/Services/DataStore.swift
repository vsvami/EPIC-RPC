//
//  DataStore.swift
//  EPIC RPC
//
//  Created by Vladimir Dmitriev on 13.06.24.
//

final class DataStore {
    
    static let shared = DataStore()
    
    var computer = Player(
        currentMove: .ready,
        score: 0,
        wins: 0,
        losses: 0
    )
    
    var player = Player(
        currentMove: .ready,
        score: 0,
        wins: 0,
        losses: 0
    )
    
    private init() {}
}
