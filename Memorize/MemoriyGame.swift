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
    
    //计算属性，能够查看牌组找到这张唯一正面朝上的牌的索引,保证这个计算始终是正确的
    var indexOfTheOneAndOnlyFaceUpCard:Int?{
        get{cards.indices.filter{index in cards[index].isFaceUp}.only}
            //过滤条件是卡片中对应索引的整数如果正面朝上,我们将获得正面朝上的卡片筛选出其索引并返回那唯一的一张
            
            //            return faceUpCardIndices.count == 1 ? faceUpCardIndices.first:nil
            //            var faceUpCardIndices = [Int]()
            //            for index in cards.indices {
            //                if cards[index].isFaceUp{
            //                    faceUpCardIndices.append(index)
            //                }
            //            }
            
        set{cards.indices.forEach{ cards[$0].isFaceUp = (newValue == $0)}}
            //forEach接收一个函数并对数组中的每一项执行这个函数
            
//            for index in cards.indices{
//                if index == newValue{
//                    cards[index].isFaceUp = true
//                }else{
//                    cards[index].isFaceUp = false
//                }
//            }
       
    }
    
    mutating func choose(_ card:Card){
        //print("choose \(card)")
        if let chosenIndex = cards.firstIndex(where: {$0.id == card.id}){
            //面朝下且不匹配才能进行翻转
            if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched{
                // 上一次翻转的牌与本次翻转的牌内容一样时就设置这两张牌匹配为真，然后将indexOfTheOneAndOnlyFaceUpCard的索引值清掉，如果内容不一样就将所有牌都面朝下且设为当前所选牌的索引值
                if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard{
                    if cards[chosenIndex].content == cards[potentialMatchIndex].content{
                        cards[chosenIndex].isMatched = true
                        cards[potentialMatchIndex].isMatched = true
                    }
                }else{
                    indexOfTheOneAndOnlyFaceUpCard = chosenIndex
                }
                cards[chosenIndex].isFaceUp = true
            }
        }
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

extension Array{
    var only:Element?{
        count == 1 ? first :nil
    }
}
