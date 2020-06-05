//
//  Card.swift
//  Cards
//
//  Created by Darren Jones on 14/03/2020.
//  Copyright © 2020 Dappological Ltd. All rights reserved.
//

import Foundation
import GameKit

struct ArbitraryRandomNumberGenerator : RandomNumberGenerator {

    mutating func next() -> UInt64 {
        // GKRandom produces values in [INT32_MIN, INT32_MAX] range; hence we need two numbers to produce 64-bit value.
        let next1 = UInt64(bitPattern: Int64(gkrandom.nextInt()))
        let next2 = UInt64(bitPattern: Int64(gkrandom.nextInt()))
        return next1 | (next2 << 32)
    }

    init(seed: UInt64) {
        self.gkrandom = GKMersenneTwisterRandomSource(seed: seed)
    }

    private let gkrandom: GKRandom
}

enum Rank: Int {
    case Ace = 1
    case Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten
    case Jack, Queen, King

    func simpleDescription() -> String {
        switch self {
            case .Ace:
                return "ace"
            case .Jack:
                return "jack"
            case .Queen:
                return "queen"
            case .King:
                return "king"
            default:
                return String(self.rawValue)
        }
    }
}

enum Suit {
    case Spades, Hearts, Diamonds, Clubs

    func simpleDescription() -> String {
        switch self {
            case .Spades:
                return "spades"
            case .Hearts:
                return "hearts"
            case .Diamonds:
                return "diamonds"
            case .Clubs:
                return "clubs"
        }
    }
}

struct Card: Hashable {
    var rank: Rank
    var suit: Suit
    func simpleDescription() -> String {
        return "The \(rank.simpleDescription()) of \(suit.simpleDescription())"
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.rank == rhs.rank && lhs.suit == rhs.suit
    }
    
    static func createDeck() -> [Card] {
        var n = 1
        var deck = [Card]()
        let suits = [Suit.Spades, Suit.Hearts, Suit.Diamonds, Suit.Clubs]
        while let rank = Rank(rawValue: n) {
            for suit in suits {
                deck.append(Card(rank: rank, suit: suit))
            }
            n += 1
        }
        return deck
    }
    
    static func createDecks(numberOfDecks:Int) -> [Card] {
        
        var decks:[Card] = []
        let seed = UInt64.random(in: UInt64.min ... UInt64.max)
        var generator = ArbitraryRandomNumberGenerator(seed: seed)
        for _ in 0..<numberOfDecks {
            decks.append(contentsOf: Card.createDeck().shuffled(using: &generator))
        }
        decks.shuffle(using: &generator)
        
        return decks
    }
    
    static func findThreeOfAKind() -> Int {
        
        let sixDecks = Card.createDecks(numberOfDecks: 6)
        // Make a random seed and store in a database
        let seed = UInt64.random(in: UInt64.min ... UInt64.max)
        var generator = ArbitraryRandomNumberGenerator(seed: seed)

        var keepgoing = true
        var loop = 0
        while keepgoing {
            
            loop += 1
            
            // Shuffle the 6 decks
            let shuffledDecks = sixDecks.shuffled(using: &generator)
            // A Set cannot have duplicates, so if all cards match, it'll contain just 1
            let firstThree:Set = [shuffledDecks[0], shuffledDecks[1], shuffledDecks[2]]
            if firstThree.count == 1
            {
//                print("We have a winner! 3x \(shuffledDecks[0].simpleDescription())")
                keepgoing = false
            }
            
        }
        
        return loop
    }
    
    static func findPerfectPair() -> Int {
        
        let sixDecks = Card.createDecks(numberOfDecks: 6)
        // Make a random seed and store in a database
        let seed = UInt64.random(in: UInt64.min ... UInt64.max)
        var generator = ArbitraryRandomNumberGenerator(seed: seed)

        var keepgoing = true
        var loop = 0
        while keepgoing {
            
            loop += 1
            
            // Shuffle the 6 decks
            let shuffledDecks = sixDecks.shuffled(using: &generator)
            // A Set cannot have duplicates, so if all cards match, it'll contain just 1
//            let firstThree:Set = [shuffledDecks[0], shuffledDecks[2]]
            let firstThree:Set = [shuffledDecks[0], shuffledDecks[7]]
            if firstThree.count == 1
            {
//                print("We have a winner! 2x \(shuffledDecks[0].simpleDescription())")
                keepgoing = false
            }
            
        }
        
        return loop
    }
}
