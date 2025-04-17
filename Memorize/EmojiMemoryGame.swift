//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by cxq on 2025/4/15.
//

import SwiftUI



class EmojiMemoryGame:ObservableObject{
    typealias Card = MemoryGame<String>.Card
    //static 意味着将表情符号设为全局，但在我的类里面使用命名空间
    private static let emojis = ["😎","😴","😜","🙈","😉","💕","🫥","👨‍🎨","🐯","🧶","😈","💁🏿"]
    
    private static func createMemoryGame() -> MemoryGame<String>{
        return MemoryGame(numberOfPairsOfCards:2){pairIndex in
            //无法直接在属性初始化器中使用实例成员表情符号，属性初始化器在self可用之前运行
            if emojis.indices.contains(pairIndex){
                return emojis[pairIndex]
            }else{
                return "⁉️"
            }
        }
    }
    
    
    @Published private var model = createMemoryGame() 
    //保护模型不被视图访问，视图必须通过视图模型才能获取数据
    var cards:Array<Card>{
        model.cards
    }
    
    var color: Color{
        .orange
    }
    
    //MARK: - Intents
    //意图函数
    
    func shuffle(){
        model.shuffle()
    }
    
    func choose(_ card:Card){
        model.choose(card)
    }
}
