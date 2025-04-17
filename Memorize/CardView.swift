//
//  CardView.swift
//  Memorize
//
//  Created by cxq on 2025/4/16.
//

import SwiftUI

struct CardView:View {
    typealias Card = MemoryGame<String>.Card
    
    let card: Card
    
    init(_ card: Card) {
        self.card = card
    }
    
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: Constants.cornerRadius)
            Group{
                base.fill(.white)
                //圆角矩形
                base
                //描边，无法同时对形状进行描边或填充
                    .strokeBorder(lineWidth:Constants.lineWidth)
                Circle()
                    .opacity(Constants.Pie.opacity)
                    .overlay(
                Text(card.content)
                    .font(.system(size: Constants.FontSize.largest))
                //如果这个字体太大，可以将其缩小
                    .minimumScaleFactor(Constants.FontSize.scaleFactor )
                //多行文本对齐方式
                    .multilineTextAlignment(.center)
                //通过将这段文字的宽高比设置为1:1，它必须适应我们的2:3宽高比
                    .aspectRatio(1,contentMode: .fit)
                    .padding(Constants.Pie.inset)
                )
                    .padding(Constants.inset)
                
            }
            .opacity(card.isFaceUp ? 1 : 0)
            //不透明度,默认为填充，若面朝上为真，则填充为透明
            base.fill().opacity(card.isFaceUp ? 0 : 1)
        }
        .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
    }
    
    private struct Constants{
        static let cornerRadius: CGFloat = 12
        static let lineWidth:CGFloat = 2
        static let inset: CGFloat = 5
        struct FontSize{
            static let largest: CGFloat = 200
            static let smallest: CGFloat = 1
            static let scaleFactor = smallest / largest
        }
        struct Pie {
            static let opacity: CGFloat = 0.5
            static let inset: CGFloat = 5
        }
    }
    
}


#Preview {
    //为常用类型取别名
    typealias Card = CardView.Card
    return VStack{
        HStack{
            CardView(Card(isFaceUp:true,content: "X", id: "test1"))
            CardView(Card(content: "X", id: "test1"))
        }
        HStack{
            CardView(Card(isFaceUp:true,content: "X", id: "test1"))
            CardView(Card(isMatched:true,content: "X", id: "test1"))
        }
    }
        .padding()
        .foregroundColor(.green)
}
