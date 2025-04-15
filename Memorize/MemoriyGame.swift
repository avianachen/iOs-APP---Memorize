//
//  MemorizeGame.swift
//  Memorize
//
//  Created by cxq on 2025/4/14.
//

import Foundation

//<>里放入的是不关心的类型,每次使用到<>里面的内容时都要指明其具体类型
struct MemoryGame<CardContent> where CardContent: Equatable{
    init(numberOfPairsOfCards: Int,cardContentFactory:(Int) -> CardContent){
        cards = Array<Card>()
        for pairIndex in 0..<max(2,numberOfPairsOfCards){
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: "\(pairIndex+1)a"))
            cards.append(Card(content: content, id: "\(pairIndex+1)b"))
        }
    }
    private(set) var cards: Array<Card>
    
    mutating func choose(_ card:Card){
        //print("choose \(card)")
        if let chosenIndex = index(of: card){
            cards[chosenIndex].isFaceUp.toggle()
        }
    }
    
    private func index(of card:Card) ->Int?{
        for index in cards.indices{
            if cards[index].id == card.id{
                return index
            }
        }
        return nil // FIXME: bogus!
    }
    
    mutating func shuffle(){
        cards.shuffle()
        print(cards)
    }
    
    struct Card: Equatable,Identifiable,CustomDebugStringConvertible{
        var isFaceUp: Bool = true
        var isMatched: Bool = false
        let content: CardContent
        
        var id: String
        var debugDescription: String{
            return "\(id):\(content) \(isFaceUp ? "up" : "down") \(isMatched ? "matched" : "")"
        }
    }
}
