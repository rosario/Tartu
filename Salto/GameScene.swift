//
//  GameScene.swift
//  Salto
//
//  Created by Rosario Rascuna on 16/11/2015.
//  Copyright (c) 2015 Cirneco. All rights reserved.
//

import SpriteKit


let GeneralSpeed:Double = 150
let SceneOffset = CGPoint(x: 0, y: 40)
let settings = GameSettings()
let gesture = Gesture()

enum GameState {
    case Intro
    case Paused
    case Active
    case Death
    case Completed
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var currentLevel = 1
    
    let layerBackgroundSlow = LayerBackground()
    let layerBackgroundFast = LayerBackground()
    let layerGameWorld = LayerWorld(
        tileSize: CGSize(width: 20, height: 20),
        gridSize: CGSize(width: 200, height: 15))

    let player = Player(size: CGSize(width: 30 , height: 45))
    
    var currentGameState = GameState.Intro

    var lastUpdateTime:NSTimeInterval = 0
    var dt:NSTimeInterval = 0
    var playerStartPoint:CGPoint?


    override func didMoveToView(view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -7)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        if let level = settings.levelData(currentLevel) {
            addSun()
            addSea(images: level.sea)
            addSky(color: level.skyColor)
            addBackground(parallax: level.parallax)
            addGameWorld(tmxfile: level.tmxfile)
            
            if currentGameState == .Intro {
                displayTapToStart()
            } else {
                addPlayer()
            }
        }
    }
    
    
    func addPlayer(){
        playerStartPoint = CGPoint(x:TileSize.width*5, y:frame.height)
        player.position = playerStartPoint!
        layerGameWorld.addChild(player)
    }
    
    func addGameWorld(tmxfile tmxfile:String) {
        layerGameWorld.addTileMap(tmxfile)
        layerGameWorld.layerVelocity = CGPoint(x: -GeneralSpeed, y: 0.0)
        layerGameWorld.position = CGPoint(x: -frame.size.width/2, y: -SceneOffset.y - 60)
        addChild(layerGameWorld)
    }


    func addSun() {
        let sun = Sun(position: CGPoint(
            x: frame.size.width/2 - 40,
            y: frame.size.height/2 - 40),
            size: CGSize(width: 120, height: 120))
        sun.zPosition = -550
        addChild(sun)
    }
    
    
    func addSea(images images:SeaColors) {
        let sea = Sea(size: frame.size, sea: images)
        sea.position = CGPoint(x: 0, y: -frame.size.height/2 - SceneOffset.y)
        addChild(sea)
    }
    
    
    func addSky(color color:String) {
        let size = CGSize(width:frame.size.width, height: (frame.size.height))
        let hexcolor = SKColor(hex: Int(color, radix: 16)!)
        let sky = SKSpriteNode(color: hexcolor , size: size)
        sky.size = size
        sky.position = CGPoint(x:0,y: SceneOffset.y + SceneOffset.y/2)
        sky.zPosition = -600
        addChild(sky)
    }

    
    func addBackground(parallax parallax:(slow:String, fast:String)) {
        layerBackgroundSlow.layerVelocity = CGPoint(x: -35.0, y: 0.0)
        layerBackgroundSlow.position = CGPoint(x: 0, y: -SceneOffset.y)
        layerBackgroundSlow.zPosition = -500
        layerBackgroundSlow.xScale = 1.2
        layerBackgroundSlow.yScale = 1.2
        layerBackgroundSlow.backgroundImage(parallax.slow, color: SKColor(hex: 0x555555), blendFactor: 0.2)
        addChild(layerBackgroundSlow)
        
        layerBackgroundFast.layerVelocity = CGPoint(x: -100.0, y: 0)
        layerBackgroundFast.position = CGPoint(x: 0, y: -SceneOffset.y)
        layerBackgroundFast.zPosition = -500
        layerBackgroundFast.xScale = 1
        layerBackgroundFast.yScale = 1
        layerBackgroundFast.backgroundImage(parallax.fast)
        addChild(layerBackgroundFast)

    }
    
    func longPressureTouch(sender: UILongPressGestureRecognizer){
        if (sender.state == .Began) {
            player.addJumpBoost()
        }
    }

    
    
    
    
    // MARK: Update
    override func update(currentTime: CFTimeInterval) {
        // Delta Time
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        
        //Update Game
        switch currentGameState {
        case .Active:
            layerBackgroundSlow.update(dt, affectAllNodes: true, parallax: true)
            layerBackgroundFast.update(dt, affectAllNodes: true, parallax: true)
            player.update(dt)
                        
            if player.spikeTouched {
                currentGameState = .Death
            } else if player.completed {
                currentGameState = .Completed
            }

        case .Death:
            player.deathAnimation()
            displayPostScreen()
            currentGameState = .Paused
        case .Completed:
            player.happyAnimation()
            displayNextScreen()
            currentGameState = .Paused
        default:
            break
        }
    }
    
    func centerOnNode(node:SKNode){
        let cameraPosition:CGPoint = convertPoint(node.position, fromNode: layerGameWorld)
        layerGameWorld.position.x -= cameraPosition.x + 150
    }
    
    override func didSimulatePhysics() {
        centerOnNode(player)
    }

    func displayTapToStart() {
        let node = tapToStart()
        addChild(node)
    }

    func displayNextScreen() {
        let node = nextScreen()
        addChild(node)
    }

    
    func displayPostScreen() {
        let node = postScreen()
        node.name = "retryScreen"
        addChild(node)
    }
    
    func nextScreen() -> SKNode {
        let node = SKNode()
        let retry = SKSpriteNode(imageNamed: "bluesquare")
        retry.alpha = 0.5
        retry.zPosition = 500
        retry.size = view!.scene!.size
        node.addChild(retry)
        
        let text = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
        text.zPosition = 501
        text.text = "LEVEL COMPLETED!"
        text.horizontalAlignmentMode = .Center
        text.position = CGPoint(x:0, y: frame.size.height/3)
        node.addChild(text)
        
        let button = SKSpriteNode(imageNamed: "next")
        button.name = "next"
        button.zPosition = 501
        button.position = CGPoint(x: frame.size.width/2 - button.size.width/2, y: 0)
        node.addChild(button)
        
        let buttonRate = SKSpriteNode(imageNamed: "rate")
        buttonRate.name = "rate"
        buttonRate.zPosition = 501
        buttonRate.position = CGPoint(x: -frame.size.width/2 + buttonRate.size.width/2, y: 0)
        node.addChild(buttonRate)
        
        return node
    }
    
    
    func tapToStart() -> SKNode {
        let node = SKNode()
        node.name = "TapToStart"
        
        let retry = SKSpriteNode(imageNamed: "bluesquare")
        retry.alpha = 0.5
        retry.zPosition = 500
        retry.size = view!.scene!.size
        node.addChild(retry)
        
        let text = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
        text.zPosition = 501
        text.text = "TAP TO START!"
        text.horizontalAlignmentMode = .Center
        text.position = CGPoint(x:0, y: frame.size.height/3)
        node.addChild(text)
        
        let button = SKSpriteNode(imageNamed: "next")
        button.name = "start"
        button.zPosition = 501
        button.position = CGPoint(x: frame.size.width/2 - button.size.width/2, y:0)
        node.addChild(button)
        
        let buttonRate = SKSpriteNode(imageNamed: "rate")
        buttonRate.name = "rate"
        buttonRate.zPosition = 501
        buttonRate.position = CGPoint(x: -frame.size.width/2 + buttonRate.size.width/2, y: 0)
        node.addChild(buttonRate)

        return node
    }
    
    func postScreen() -> SKNode {
        
        let node = SKNode()
        let retry = SKSpriteNode(imageNamed: "bluesquare")
        retry.alpha = 0.5
        retry.zPosition = 500
        retry.size = view!.scene!.size
        node.addChild(retry)
        
        let text = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
        text.zPosition = 501
        text.text = "RETRY!"
        text.horizontalAlignmentMode = .Center
        text.position = CGPoint(x:0, y: frame.size.height/3)
        node.addChild(text)
        
        let button = SKSpriteNode(imageNamed: "replay")
        button.name = "replay"
        button.zPosition = 501
        button.position = CGPoint(x: frame.size.width/2 - button.size.width/2, y: 0)
        node.addChild(button)
        
        let buttonRate = SKSpriteNode(imageNamed: "rate")
        buttonRate.name = "rate"
        buttonRate.zPosition = 501
        buttonRate.position = CGPoint(x: -frame.size.width/2 + buttonRate.size.width/2, y: 0)
        node.addChild(buttonRate)

        return node
    }
    
    // MARK: Contact and collisions
    func didBeginContact(contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        if let entity = nodeA as? Player {
            entity.collidedWith(contact.bodyB, contact: contact)
        } else if let entity = nodeB as? Player {
            entity.collidedWith(contact.bodyA, contact: contact)
        }
    }
    
    // MARK: Touch
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        gesture.touchesBegan(touches, node: self, callback: screenInteractionStarted)
    }

    func hidePostScreen(){
        if let node = childNodeWithName("retryScreen") {
            node.removeFromParent()
        }
    }
    
    func restartLevel() {
        layerGameWorld.resetMap()
        player.resetPosition(playerStartPoint!)
        hidePostScreen()
        currentGameState = .Active
    }
    
    func loadNextLevel() {
        let next = GameScene(size: scene!.size)
        next.currentGameState = .Active
        next.scaleMode = scaleMode
        next.currentLevel = (currentLevel + 1) % 4
        let transition = SKTransition.fadeWithDuration(0.6)
        view?.presentScene(next, transition: transition)
    }
    
    func startLevel() {
        if let node = childNodeWithName("TapToStart") {
            node.removeFromParent()
            addPlayer()
            currentGameState = .Active
        }
    }
    
    func screenInteractionStarted(location:CGPoint) {
        if currentGameState == .Active {
            player.startJump()
        } else if currentGameState == .Paused {
            for node in nodesAtPoint(location) {
                if let button = node as? SKSpriteNode {
                    if button.name == "replay" {
                        restartLevel()
                    } else if button.name == "next" {
                        loadNextLevel()
                    }
                
                }
            }
        } else if currentGameState == .Intro {
            startLevel()
        }
    }
}

