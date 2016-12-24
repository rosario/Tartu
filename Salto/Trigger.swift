//
//  Trigger.swift
//  Salto
//
//  Created by Rosario Rascuna on 25/11/2015.
//  Copyright © 2015 Cirneco. All rights reserved.
//

import SpriteKit

class Trigger:Edge {
    
    convenience init(offset:CGPoint, polyline:String, name:String) {
        self.init()
        let path = createPathFromPolyline(polyline,offset: offset)
        let physicsBody = SKPhysicsBody(edgeChainFromPath: path)
        physicsBody.allowsRotation = false
        physicsBody.restitution = 0.0
        physicsBody.friction = 0.0
        physicsBody.angularDamping = 0.0
        physicsBody.linearDamping = 0.0
        physicsBody.affectedByGravity = false
        physicsBody.categoryBitMask = ColliderType.Trigger
        self.physicsBody = physicsBody   
    }
}
