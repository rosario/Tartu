//
//  Sun.swift
//  Salto
//
//  Created by Rosario Rascuna on 17/11/2015.
//  Copyright © 2015 Cirneco. All rights reserved.
//

class Sun:SKSpriteNode {
    
    // Animations
    var animStanding:SKAction?
    
    convenience init(position: CGPoint, size: CGSize) {
        self.init()
        self.position = position
        self.size = size
        buildSprite()
    }
    
    func circleOfRadius(width:CGFloat) -> SKShapeNode {
        if #available(iOS 8.0, *) {
            return SKShapeNode(circleOfRadius: width)
        } else {
            let shape = SKShapeNode()
            shape.path = UIBezierPath(ovalInRect: CGRectMake(0, 0, width, width)).CGPath
            shape.position = CGPoint.zero
            shape.lineWidth = 10
            return shape
        }
    }
    
    func buildSprite() {
        let innerCircle:SKShapeNode? = circleOfRadius(size.width/2)
        innerCircle!.fillColor = SKColor.whiteColor()
        addChild(innerCircle!)
        
        runAnimation()
    }
    
    func runAnimation(){
        
        let scaleUp = SKAction.scaleBy(1.2, duration: 1)
        let scaleDown = SKAction.reversedAction(scaleUp)()
        let fadeOut = SKAction.fadeOutWithDuration(1)
        let fadeIn = SKAction.reversedAction(fadeOut)()
        
        let innerBorder = circleOfRadius(size.width/2)
        innerBorder.strokeColor = SKColor.whiteColor()
        innerBorder.lineWidth = 5
        addChild(innerBorder)
        
        let outBorder = circleOfRadius(size.width/2 + size.width*0.1)
        outBorder.fillColor = SKColor.whiteColor()
        outBorder.alpha = 0.2
        addChild(outBorder)

        let outBorderAnim = SKAction.sequence([scaleUp, fadeOut, scaleDown])

        let explosion = SKAction.runBlock({
            outBorder.runAction(outBorderAnim)
            outBorder.alpha = 0.2
        })
        let wait = SKAction.waitForDuration(5)
        
        let innerBorderAnim = SKAction.sequence([
            scaleUp,
            SKAction.group([fadeOut, explosion,wait]),
            scaleDown,
            fadeIn
            ])
        
        innerBorder.runAction(SKAction.repeatActionForever(innerBorderAnim))
    }
}
