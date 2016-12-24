//
//  Sea.swift
//  Salto
//
//  Created by Rosario Rascuna on 17/11/2015.
//  Copyright © 2015 Cirneco. All rights reserved.
//

extension SKColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}

enum GrowDirection {
    case Up, Down
}

struct SeaColors {
    var top:String
    var middle:String
    var bottom:String
}

class Sea:SKSpriteNode {
    
    let growMax:CGFloat = 5
    let growMin:CGFloat = -5
    var growing:CGFloat = 0
    var direction = GrowDirection.Up
    
    convenience init(size: CGSize, sea:SeaColors) {
        self.init()
        self.size = size
        
        let top = SKSpriteNode(color: SKColor(hex: Int(sea.top, radix: 16)!), size: size)
        let middle = SKSpriteNode(color: SKColor(hex: Int(sea.middle, radix: 16)!), size: size)
        let bottom = SKSpriteNode(color: SKColor(hex: Int(sea.bottom, radix: 16)!), size: size)
        
        addChild(top)
        top.zPosition = 1
        
        let middlePoint = CGFloat(-(1.2*40))
        middle.position = position + CGPoint(x: 0, y: middlePoint)
        middle.zPosition = 2
        addChild(middle)

        let bottomPoint = CGFloat(-(2*40))
        bottom.position = position + CGPoint(x: 0, y: bottomPoint)
        bottom.zPosition = 3
        addChild(bottom)
        zPosition = -200
    }
    
}



