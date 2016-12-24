//
//  Gesture.swift
//  Salto
//
//  Created by Rosario Rascuna on 17/11/2015.
//  Copyright © 2015 Cirneco. All rights reserved.
//

import SpriteKit

struct Gesture {
    
    func longPressure(target target:AnyObject?, view:SKView) {
        let longPressureTouch = UILongPressGestureRecognizer(target: target, action: Selector("longPressureTouch:"))
        longPressureTouch.minimumPressDuration = 0.1
        view.addGestureRecognizer(longPressureTouch)
    }

    func swipeRight(target target:AnyObject?, view:SKView) {
        let swipedRight = UISwipeGestureRecognizer(target: target, action: Selector("swipedRight:"))
        swipedRight.direction = .Right
        view.addGestureRecognizer(swipedRight)
    }
    
    func swipeUp(target target:AnyObject?, view:SKView) {
        let swipedUp = UISwipeGestureRecognizer(target: target, action: Selector("swipedUp:"))
        swipedUp.direction = .Up
        view.addGestureRecognizer(swipedUp)
    }
    
    func swipeDown(target target:AnyObject?, view:SKView) {
        let swipedDown = UISwipeGestureRecognizer(target: target, action: Selector("swipedDown:"))
        swipedDown.direction = .Down
        view.addGestureRecognizer(swipedDown)
    }
    
    func touchesBegan(touches: Set<UITouch>, node:SKNode, callback:(CGPoint) -> ()){
        for touch: AnyObject in touches {
            let location = touch.locationInNode(node)
            callback(location)
        }
    }
    
    func touchesMoved(touches: Set<UITouch>, node:SKNode, callback:(CGPoint) -> () ) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(node)
            callback(location)
        }
    }
    
    func touchesEnded(touches: Set<UITouch>, node:SKNode, callback:(CGPoint) -> ()) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(node)
            callback(location)
        }
    }
    
    func touchesCancelled(touches: Set<UITouch>?, node:SKNode, callback:(CGPoint) -> ()) {
        for touch: AnyObject in touches! {
            let location = touch.locationInNode(node)
            callback(location)
        }
    }
}





