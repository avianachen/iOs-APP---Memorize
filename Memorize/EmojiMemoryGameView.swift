//
//  ContentView.swift
//  Memorize
//
//  Created by cxq on 2025/4/8.
//
//cxq
import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel:EmojiMemoryGame
    @State var cardCount = 4
    //计算属性，计算的意思是这个变量的值并没有存储在某个地方，它被计算，每次有人请求获取body的值时，都会运行这段代码。some view意味着这个变量的类型可以是任何结构体，只要它的行为像视图一样，它确保返回的内容是一个视图
    var body: some View {
        VStack{
            //返回结果是一个视图
            ScrollView{
                cards
                    .animation(.default,value: viewModel.cards)
            }
            Button("Shuffle"){
                viewModel.shuffle()
            }
            .padding()
        }
    }
    
    var cards:some View{
        //自定义网格项,这个网格项的工作方式是尽可能多地将乐高盒里的东西放在一行
        LazyVGrid(columns:[GridItem(.adaptive(minimum: 90),spacing: 0)],spacing: 0){
            //让每张卡片不再按照索引，而是根据每张卡片本身进行关联
            ForEach(viewModel.cards){card in
                    CardView(card)
                        .aspectRatio(2/3,contentMode: .fit)
                        .padding(4)
                        .onTapGesture {
                            viewModel.choose(card)
                        }
            }
        }
        .foregroundStyle(Color.orange)
    }
    
}

struct CardView:View {
    let card: MemoryGame<String>.Card
    
    init(_ card: MemoryGame<String>.Card) {
        self.card = card
    }
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group{
                base.fill(.white)
                //圆角矩形
                base
                //描边，无法同时对形状进行描边或填充
                    .strokeBorder(lineWidth:2)
                Text(card.content).font(.system(size: 200))
                //如果这个字体太大，可以将其缩小
                    .minimumScaleFactor(0.01)
                //通过将这段文字的宽高比设置为1:1，它必须适应我们的2:3宽高比
                    .aspectRatio(1,contentMode: .fit)
            }
            .opacity(card.isFaceUp ? 1 : 0)
            //不透明度,默认为填充
            base.fill().opacity(card.isFaceUp ? 0 : 1)
        }
    }
}

#Preview {
    //动态创建
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
