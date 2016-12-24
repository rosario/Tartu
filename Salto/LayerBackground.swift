//
//  LayerBackground.swift
//  Salto
//
//  Created by Rosario Rascuna on 25/10/2015.
//  Copyright (c) 2015 Neil North. All rights reserved.
//

import SpriteKit

class LayerBackground: Layer {
    
    override func updateNodes(delta: CFTimeInterval, childNumber: Int, childNode: SKNode) {
        if let node = childNode as? SKSpriteNode {
            // Magic Number: We set 1.5 because anchor point is (0.5, 0,5) from view.frame
            if node.position.x <= (-(node.size.width)*1.5) {
                if node.name == "A" && childNodeWithName("B") != nil {
                    node.position = CGPoint(
                        x: childNodeWithName("B")!.position.x + node.size.width,
                        y: node.position.y)
                } else if node.name == "B" && childNodeWithName("A") != nil {
                    node.position = CGPoint(
                        x: childNodeWithName("A")!.position.x + node.size.width,
                        y: node.position.y)
                }
            }
        }
    }
    
    func backgroundImage(name:String, color:SKColor, blendFactor:CGFloat ){
        let imageA = SKSpriteNode(imageNamed: name)
        imageA.position = CGPoint(x: -imageA.size.width, y: 0)
        imageA.anchorPoint = CGPointZero
        imageA.zPosition = 1
        imageA.name = "A"
        imageA.color = color
        imageA.colorBlendFactor = blendFactor
        addChild(imageA)
        
        let imageB = SKSpriteNode(imageNamed: name)
        imageB.position = CGPoint(x: 0, y: 0)
        imageB.anchorPoint = CGPointZero
        imageB.zPosition = 1
        imageB.name = "B"
        imageB.color = color
        imageB.colorBlendFactor = blendFactor
        addChild(imageB)
    }
    
    func backgroundImage(name:String) {
        let imageA = SKSpriteNode(imageNamed: name)
        imageA.position = CGPoint(x: -imageA.size.width, y: 0)
        imageA.anchorPoint = CGPointZero
        imageA.zPosition = 1
        imageA.name = "A"
        addChild(imageA)
        
        let imageB = SKSpriteNode(imageNamed: name)
        imageB.position = CGPoint(x: 0, y: 0)
        imageB.anchorPoint = CGPointZero
        imageB.zPosition = 1
        imageB.name = "B"
        addChild(imageB)
    }

}

