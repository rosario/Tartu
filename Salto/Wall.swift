//
//  Wall.swift
//  Salto
//
//  Created by Rosario Rascuna on 24/11/2015.
//  Copyright © 2015 Cirneco. All rights reserved.
//

import SpriteKit

class Wall:SKSpriteNode {
    
    convenience init(offset:CGPoint, size:CGSize) {
        self.init()
        let rect = CGRect(
            x: offset.x, y: offset.y,
            width: size.width, height: size.height)
        
        let physicsBody = SKPhysicsBody(rectangleOfSize: rect.size,
            center: CGPoint(x:offset.x + size.width/2, y:offset.y + size.height/2))

        physicsBody.allowsRotation = false
        physicsBody.dynamic = true
        physicsBody.restitution = 0.0
        physicsBody.friction = 0.0
        physicsBody.angularDamping = 0.0
        physicsBody.linearDamping = 0.0
        physicsBody.affectedByGravity = false
        physicsBody.categoryBitMask = ColliderType.Wall
        self.physicsBody = physicsBody
    }
}
