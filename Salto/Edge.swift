//
//  Edge.swift
//  Salto
//
//  Created by Rosario Rascuna on 24/11/2015.
//  Copyright © 2015 Cirneco. All rights reserved.
//

import SpriteKit

class Edge:SKSpriteNode {
    
    func pointFromString(s:String) -> CGPoint? {
        let values = s.characters.split{$0 == ","}
        if let x = Int(String(values[0])), y = Int(String(values[1])) {
            
            return CGPoint(x:CGFloat(x), y:CGFloat(y))
        } else {
            return nil
        }
    }
    
    func createPathFromPolyline(polylinePoints:String, offset:CGPoint) -> CGPath {
        let ref = CGPathCreateMutable()
        let points = polylinePoints.componentsSeparatedByString(" ")
        let cgpoints = points.map{self.pointFromString(String($0))}
        
        for var i = 0; i < cgpoints.count; ++i {
            let point = cgpoints[i]
            if  point != nil {
                let pointX = point!.x + offset.x
                let pointY = (point!.y * -1) + offset.y
                if (i == 0 ) {
                    CGPathMoveToPoint(ref, nil, pointX, pointY)
                } else {
                    CGPathAddLineToPoint(ref, nil, pointX, pointY)
                }
            }
        }
        return ref
    }

    convenience init(offset:CGPoint, polyline:String) {
        self.init()
            let path = createPathFromPolyline(polyline,offset: offset)
            let physicsBody = SKPhysicsBody(edgeChainFromPath: path)

            physicsBody.allowsRotation = false
            physicsBody.restitution = 0.0
            physicsBody.friction = 0.0
            physicsBody.angularDamping = 0.0
            physicsBody.linearDamping = 0.0
            physicsBody.affectedByGravity = false
            physicsBody.categoryBitMask = ColliderType.Edge        
            self.physicsBody = physicsBody
        
    }

    
}