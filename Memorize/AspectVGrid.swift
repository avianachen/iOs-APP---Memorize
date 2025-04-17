//
//  AspectVGrid.swift
//  Memorize
//
//  Created by cxq on 2025/4/16.
//

import SwiftUI

//因为Layout本身就是一个View，因此仍然像视图一样操作
struct AspectVGrid<Item:Identifiable,ItemView:View>: View{
    var items: [Item]
    var aspectRatio: CGFloat = 1
    
    //不能直接写返回View，因为View是一个协议，在这里需要一个具体的类型，而不是一个抽象类型，也不能写some View ，因为没有大括号可以查看具体返回什么样的视图，所以将返回一个不关心的元素视图
    @ViewBuilder var content: (Item) -> ItemView
    //初始化器要为最后一个函数类型的参数声明为,@ViewBuilder，否则会将最后一个参数作为普通函数处理。不会转换为视图构建器
    init(_ items: [Item], aspectRatio: CGFloat,@ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
    var body: some View{
        GeometryReader{ geometry in
            let gridItemSize = gridItemWidthThatFits(count: items.count, size: geometry.size,atAspectRatio: aspectRatio)
            //自定义网格项,这个网格项的工作方式是尽可能多地将乐高盒里的东西放在一行
            LazyVGrid(columns:[GridItem(.adaptive(minimum: gridItemSize),spacing: 0)],spacing: 0){
                //让每张卡片不再按照索引，而是根据每张卡片本身进行关联
                ForEach(items){ item in
                    content(item)
                        .aspectRatio(aspectRatio,contentMode: .fit)
                }
            }
        }
        
    }
    
    //参数1:适配多少张卡片
    //参数2:要适配的空间,所以类型是计算机图形学的大小
    //参数3:适配的纵横比
//返回卡片的宽度
    func gridItemWidthThatFits(
        count: Int,
        size: CGSize,
        atAspectRatio aspectRatio: CGFloat
    ) -> CGFloat{
        //当卡片增加列数到一定程度时一旦能容纳下提供的空间时，则返回，否则一直增加列数，当列数增加到卡牌到数量都还无法返回，则返回宽度值除以卡牌数或者所用空间的高度乘以纵横比中比较小的值
        let count = CGFloat(count)
        var columnCount = 1.0 //因为只能允许浮点数和CGFloat之间的相互操作
        repeat{
            //计算卡牌的宽度和高度
            let width = size.width / columnCount
            let height = width / aspectRatio
            
            let rowCount = (count / columnCount).rounded(.up) //行数向上取整
            if rowCount * height < size.height{
                return (size.width / columnCount).rounded(.down)
            }
            columnCount += 1
        }while columnCount < count
        return min(size.width / count,size.height * aspectRatio).rounded(.down)
        
    }
}

//#Preview {
//    AspectVGrid()
//}
