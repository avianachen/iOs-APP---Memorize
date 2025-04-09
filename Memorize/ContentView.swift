//
//  ContentView.swift
//  Memorize
//
//  Created by cxq on 2025/4/8.
//

import SwiftUI

struct ContentView: View {
    let emojis:Array<String> = ["😎","😴","😜","🙈","😎","😴","😜","🙈"]
    @State var cardCount = 4
    //计算属性，计算的意思是这个变量的值并没有存储在某个地方，它被计算，每次有人请求获取body的值时，都会运行这段代码。some view意味着这个变量的类型可以是任何结构体，只要它的行为像视图一样，它确保返回的内容是一个视图
    var body: some View {
        //返回结果是一个视图
        VStack {
            ScrollView{
                cards
            }
            Spacer()
            cardCountAdjusters
        }
        .padding()
    }
    
    var cards:some View{
        //自定义网格项,这个网格项的工作方式是尽可能多地将乐高盒里的东西放在一行
        LazyVGrid(columns:[GridItem(.adaptive(minimum: 120))]){
            ForEach(0..<cardCount,id: \.self){index in
                CardView(content: emojis[index])
                    .aspectRatio(2/3,contentMode: .fit)
            }
        }
        .foregroundStyle(.orange)
    }
    
    var cardCountAdjusters : some View{
        HStack{
            cardRemover
            Spacer()
            cardAdder
        }
        .imageScale(.large)
        .font(.largeTitle)
    }
    
    func cardCountAdjuster(by offset:Int,symbol:String) -> some View{
        Button(action: {
            if cardCount < emojis.count{
                cardCount += offset
            }
        }, label: {
            Image(systemName: symbol)
        })
        //禁用用户界面控制
        .disabled(cardCount + offset < 1 || cardCount + offset > emojis.count)
    }
    
    var cardRemover: some View{
        cardCountAdjuster(by:-1,symbol: "rectangle.stack.badge.minus.fill")
    }
    
    var cardAdder: some View{
        cardCountAdjuster(by:+1,symbol: "rectangle.stack.badge.plus.fill")
    }
    
}

struct CardView:View {
    let content:String
    @State var isFaceUp: Bool = true
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group{
                base.fill(.white)
                //圆角矩形
                base
                //描边，无法同时对形状进行描边或填充
                    .strokeBorder(lineWidth:2)
                Text(content).font(.largeTitle)
            }
            //.opacity(isFaceUp ? 1 : 0)
            //不透明度,默认为填充
            base.fill().opacity(isFaceUp ? 0 : 1)
        }
        .onTapGesture{
            //isFaceUp = !isFaceUp
            isFaceUp.toggle()
        }
    }
}

#Preview {
    ContentView()
}
