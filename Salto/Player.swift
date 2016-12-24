//
//  Player.swift
//
//  Created by Rosario Rascuna on 25/10/2015.
//

import SpriteKit

class Player:Entity {

    // Controls
    var playerIndex = 0
    var startPoint = CGPoint.zero
    var jumpCounts = 0
    var completed = false // I don't this this should be part of Player... Keep it for now
    var jumpASAP = false 
    var jumpPosition = CGPoint.zero
    var spikeTouched = false
    
    enum State {
        case Jumping
        case OnGround
        case Death
        case InTheAir
    }
    
    var currentState = State.OnGround
    
    var health = 1.0
    
    // Sounds
    var soundJump:SKAction?
    var soundSpike:SKAction?
    var soundWater:SKAction?
    var soundGround:SKAction?
    var soundCompleted:SKAction?
    let sprite = SKSpriteNode()    
    
    
    convenience init(size: CGSize) {
        self.init()
        self.size = size
        
        configureCollisionBody()
        setupSounds()

        sprite.size = size
        sprite.runAction(runningAnimation(), withKey: "running")
        addChild(sprite)
        sprite.position = CGPoint(x:0, y: TileSize.height)
        jumpPosition = position

    }
    
    func setupSounds() {
        soundSpike = SKAction.playSoundFileNamed("spike.wav", waitForCompletion: false)
        soundWater = SKAction.playSoundFileNamed("spash.mp3", waitForCompletion: false)
        soundJump = SKAction.playSoundFileNamed("jump2.wav", waitForCompletion: false)
        soundGround = SKAction.playSoundFileNamed("ground.wav", waitForCompletion: false)
        soundCompleted = SKAction.playSoundFileNamed("complete.mp3", waitForCompletion: false)
    }

    func runningAnimation() -> SKAction {
        let atlas:SKTextureAtlas = SKTextureAtlas(named: "koko")
        let timePerFrame:NSTimeInterval = Double(1.0/20.0)
        let textures = [
            atlas.textureNamed("frame1"),
            atlas.textureNamed("frame2"),
            atlas.textureNamed("frame3"),
            atlas.textureNamed("frame4"),
            atlas.textureNamed("frame3"),
            atlas.textureNamed("frame2")]
        
        let anim:SKAction = SKAction.animateWithTextures(textures, timePerFrame: timePerFrame)
        return SKAction.repeatActionForever(anim)
    }

    func playSpikeSound() {
        runAction(soundSpike!)
    }
    func playWaterSound() {
        runAction(soundWater!)
    }
    func playJumpSound() {
        runAction(soundJump!)
    }
    func playGroundSound() {
        runAction(soundGround!)
    }
    func playCompletedSound(){
        runAction(soundCompleted!)
    }
 
    
    func collidedWith(body:SKPhysicsBody, contact:SKPhysicsContact) {
        if body.categoryBitMask == ColliderType.Wall {
            currentState = State.OnGround
            playGroundSound()
        } else if body.categoryBitMask == ColliderType.Spike {
            spikeTouched = true
            playSpikeSound()
        } else if body.categoryBitMask == ColliderType.Edge {
            spikeTouched = true
            playWaterSound()
        } else if body.categoryBitMask == ColliderType.Trigger {
            completed = true
        }
    }
    
    
    func deathAnimation() {
        physicsBody?.collisionBitMask = ColliderType.None
        sprite.color = SKColor.redColor()
        sprite.colorBlendFactor = 1
        physicsBody!.applyImpulse(CGVector(dx: -10, dy: 50.0))
    }
    
    func happyAnimation() {
        physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        let move = SKAction.moveByX(0, y: 550, duration: 0.5)
        move.timingMode = .EaseOut
        let rotate = SKAction.rotateByAngle(180, duration: 0.5)
        let fade = SKAction.fadeOutWithDuration(0.5)
        let sequence = SKAction.group([move, rotate, fade])
        runAction(sequence, withKey: "happy")
        playCompletedSound()

    }

    func addJumpBoost() {
        if currentState == .Jumping  || currentState == .InTheAir {
            physicsBody!.applyImpulse(CGVector(dx: 0, dy: 250.0))
        }
    }
    
    func rememberToJump(){
        let threshold = size.height + size.height*0.25 + jumpPosition.y
        if position.y < threshold {
            jumpASAP = true
        }
    }
    
    
    func startJump(){
        if currentState == .OnGround {
            playJumpSound()
            jumpPosition = position
            currentState = .Jumping
            physicsBody!.applyImpulse(CGVector(dx: 0, dy: 70.0))
            jumpCounts += 1
            jumpASAP = false
        } else {
            // We are still in the air, but we'll remember to jump
            rememberToJump()
        }
    }
    
    
    // MARK: Collisions
    func configureCollisionBody() {
        let smallRect = CGSize(width: size.width*0.5  , height: size.height*0.8)
        let center = CGPointZero
        
        physicsBody = SKPhysicsBody(rectangleOfSize: smallRect, center: center)
        physicsBody?.dynamic = true
        physicsBody?.allowsRotation = false
        physicsBody?.restitution = 0.0
        physicsBody?.angularDamping = 0.0
        physicsBody?.linearDamping = 0.0
        physicsBody?.usesPreciseCollisionDetection = false
        physicsBody?.affectedByGravity = true
        physicsBody?.mass = 0.2
        physicsBody?.categoryBitMask = ColliderType.Player
        physicsBody?.collisionBitMask = ColliderType.Wall
        physicsBody?.contactTestBitMask =  ColliderType.Wall |
            ColliderType.Spike | ColliderType.Edge | ColliderType.Trigger | ColliderType.Sensor
    
    }
    
    func resetPosition(position:CGPoint){
        jumpCounts = 0
        spikeTouched = false
        jumpASAP = false
        self.position = position
        physicsBody!.velocity = CGVector.zero
        physicsBody!.affectedByGravity = true
        physicsBody!.categoryBitMask = ColliderType.Player
        physicsBody!.collisionBitMask = ColliderType.Wall
        sprite.colorBlendFactor = 0
    }

    func update(delta: CFTimeInterval) {
        if jumpASAP  == true {
            startJump()
        }
        let offset = CGFloat(GeneralSpeed)  * CGFloat(delta)
        position.x += offset
    }
}
