//
//  ContentView.swift
//  Memorize
//
//  Created by cxq on 2025/4/8.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel:EmojiMemoryGame
    private let aspectRatio: CGFloat = 2/3
    private let spacing:CGFloat = 4
    
    //计算属性，计算的意思是这个变量的值并没有存储在某个地方，它被计算，每次有人请求获取body的值时，都会运行这段代码。some view意味着这个变量的类型可以是任何结构体，只要它的行为像视图一样，它确保返回的内容是一个视图
    var body: some View {
        VStack{
            //返回结果是一个视图
            cards
                .foregroundStyle(viewModel.color)
                .animation(.default,value: viewModel.cards)
            Button("Shuffle"){
                viewModel.shuffle()
            }
        }
        .padding()
    }
        
        
    private var cards:some View{
        
//            GeometryReader{ geometry in
//                let gridItemSize = gridItemWidthThatFits(count: viewModel.cards.count, size: geometry.size,atAspectRatio: aspectRatio)
//                //自定义网格项,这个网格项的工作方式是尽可能多地将乐高盒里的东西放在一行
//                LazyVGrid(columns:[GridItem(.adaptive(minimum: gridItemSize),spacing: 0)],spacing: 0){
//                    //让每张卡片不再按照索引，而是根据每张卡片本身进行关联
//                    ForEach(viewModel.cards)
        AspectVGrid(viewModel.cards,aspectRatio:aspectRatio){card in
                        CardView(card)
                            .padding(spacing)
                            .onTapGesture {
                                viewModel.choose(card)
                            }
            }
        
        }
        
        
        
    }


#Preview {
    //动态创建
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
