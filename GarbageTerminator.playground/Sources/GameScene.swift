//
//  GameScene.swift
//  WWDC19Application
//
//  Created by Adriano Leal De Freitas Ramos on 18/03/19.
//  Copyright © 2019 Adriano Ramos. All rights reserved.
//

import SpriteKit
import GameplayKit

public func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

public func -(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

public func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

public func /(point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
public func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
}
#endif

extension CGPoint {
    public func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    public func normalized() -> CGPoint {
        return self / length()
    }
}

public class GameScene: SKScene {

    public convenience init?(fileName: String, player: String) {
        self.init(fileNamed: fileName)
        self.player = SKSpriteNode(imageNamed: player)
        self.score = 0
    }
    
    public struct PhysicsCategory {
        static let none      : UInt32 = 0
        static let all       : UInt32 = UInt32.max
        static let gargabe   : UInt32 = 0b1
        static let projectile: UInt32 = 0b10
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {
            return
        }
        run(SKAction.playSoundFileNamed("shot.mp3", waitForCompletion: false))
        let touchLocation = touch.location(in: self)
        
        let projectile = SKSpriteNode(imageNamed: "projectile")
        
        projectile.position = player.position
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.gargabe
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        
        let offset = touchLocation - projectile.position
        
        addChild(projectile)
        
        if offset.x < 0 { return }
        let direction = offset.normalized()
        let shootAmount = direction * 3000
        let realDest = shootAmount + projectile.position
        let actionMove = SKAction.move(to: realDest, duration: 3.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    var player = SKSpriteNode(imageNamed: "player")
    override public func didMove(to view: SKView) {
        
        if let gameScene = SKScene(fileNamed: "GameScene"),
            let firstLive = gameScene.childNode(withName: "firstLive") as? SKSpriteNode,
            let secondLive = gameScene.childNode(withName: "secondLive") as? SKSpriteNode,
            let thirdLive = gameScene.childNode(withName: "thirdLive") as? SKSpriteNode {
            firstLive.removeFromParent()
            addChild(firstLive)
            firstLive.zPosition = 100
            
            firstLive.position = CGPoint(x: (firstLive.position.x/gameScene.size.width)*size.width,
                                         y: (firstLive.position.y/gameScene.size.height)*size.height)
            
            secondLive.removeFromParent()
            addChild(secondLive)
            secondLive.zPosition = 100
            
            secondLive.position = CGPoint(x: (secondLive.position.x/gameScene.size.width)*size.width,
                                          y: (secondLive.position.y/gameScene.size.height)*size.height)
            
            thirdLive.removeFromParent()
            addChild(thirdLive)
            thirdLive.zPosition = 100
            
            thirdLive.position = CGPoint(x: (thirdLive.position.x/gameScene.size.width)*size.width,
                                         y: (thirdLive.position.y/gameScene.size.height)*size.height)
        }
        
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        
        makeBackground()
        addChild(player)
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addGarbage1), SKAction.wait(forDuration: 1.0),
                SKAction.run(addGarbage2), SKAction.wait(forDuration: 1.0),
                SKAction.run(addGarbage3), SKAction.wait(forDuration: 1.0),
                SKAction.run(addGarbage4), SKAction.wait(forDuration: 1.0),
                SKAction.run(addGarbage5), SKAction.wait(forDuration: 1.0),
                SKAction.run(addGarbage6), SKAction.wait(forDuration: 1.0),
                SKAction.run(addGarbage7), SKAction.wait(forDuration: 1.0),
                SKAction.run(addGarbage8), SKAction.wait(forDuration: 1.0),
                SKAction.run(addGarbage9), SKAction.wait(forDuration: 1.0),
                SKAction.run(addGarbage10), SKAction.wait(forDuration: 1.0),
                SKAction.run(addGarbage11), SKAction.wait(forDuration: 1.0)
                ])))
        
        let backgroundMusic = SKAudioNode(fileNamed: "background-music-aac.caf")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }
    
    public func makeBackground(){
        let backgroundTexture = SKTexture(imageNamed: "background")
        
        let shiftBackground = SKAction.moveBy(x: -backgroundTexture.size().width, y: 0, duration: 9)
        let movingAndReplacingBackground = SKAction.repeatForever(SKAction.sequence([shiftBackground]))
        
        for i in 0...3 {
            var background = SKSpriteNode(imageNamed: "background")
            
            background = SKSpriteNode(texture: backgroundTexture)
            background.size.height = self.frame.height
            background.size.width = backgroundTexture.size().width/backgroundTexture.size().height * self.frame.height
            background.position = CGPoint(x: background.size.width/2  + (background.size.width) * CGFloat(i), y: self.frame.midY)
            background.run(movingAndReplacingBackground)
            
            self.addChild(background)
        }
    }
    
    
    public func projectileDidCollideWithGarbage(projectile: SKSpriteNode, gargabe: SKSpriteNode) {
        self.score += 1
        garbageDestroyed += 1
        projectile.removeFromParent()
        gargabe.removeFromParent()
    }
    
    public func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    public func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    var garbageDestroyed = 0
    var gameOverCondition = 3;
    
    var score = 0 {
        didSet {
            if score >= 35 {
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let wonScene = Restart(fileName: "WON", score: score)!
                view?.presentScene(wonScene, transition: reveal)
            }
        }
    }
    
    var count = 0 {
        didSet {
            let scoreString = String(score)
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let dead = SKTexture(imageNamed: "dead")
            
            if count == 1 {
                if let gameScene = SKScene(fileNamed: "GameScene"),
                    let firstLive = gameScene.childNode(withName: "firstLive") as? SKSpriteNode {
                    firstLive.removeFromParent()
                    addChild(firstLive)
                    firstLive.zPosition = 100
                    
                    firstLive.position = CGPoint(x: (firstLive.position.x/gameScene.size.width)*size.width,
                                                 y: (firstLive.position.y/gameScene.size.height)*size.height)
                    firstLive.texture = dead
                }
            } else if count == 2 {
                if let gameScene = SKScene(fileNamed: "GameScene"),
                    let secondLive = gameScene.childNode(withName: "secondLive") as? SKSpriteNode {
                    secondLive.removeFromParent()
                    addChild(secondLive)
                    secondLive.zPosition = 100
                    
                    secondLive.position = CGPoint(x: (secondLive.position.x/gameScene.size.width)*size.width,
                                                  y: (secondLive.position.y/gameScene.size.height)*size.height)
                    secondLive.texture = dead
                }
            }
            
            if count >= gameOverCondition {
                let gameOverScene = Restart(fileName: "LOSE", score: score)!
                view?.presentScene(gameOverScene, transition: reveal)
            }
        }
    }
    
    public func addGarbage1(){
        let gb1 = SKSpriteNode(imageNamed: "gb1")
        
        gb1.physicsBody = SKPhysicsBody(rectangleOf: gb1.size)
        gb1.physicsBody?.isDynamic = true
        gb1.physicsBody?.categoryBitMask = PhysicsCategory.gargabe
        gb1.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
        gb1.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        let actualY = random(min: gb1.size.height/2, max: size.height - gb1.size.height/2)
        gb1.position = CGPoint(x: size.width + gb1.size.width/2, y: actualY)
        
        addChild(gb1)
        
        let actualDuration = random(min: CGFloat(1.5), max: CGFloat(6.0))
        let actionMove = SKAction.move(to: CGPoint(x: -gb1.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
        
        gb1.run(actionMove) {
            self.count+=1
        }
    }
    
    public func addGarbage2(){
        let gb2 = SKSpriteNode(imageNamed: "gb2")
        gb2.physicsBody = SKPhysicsBody(rectangleOf: gb2.size)
        gb2.physicsBody?.isDynamic = true
        gb2.physicsBody?.categoryBitMask = PhysicsCategory.gargabe
        gb2.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
        gb2.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        let actualY = random(min: gb2.size.height/2, max: size.height - gb2.size.height/2)
        gb2.position = CGPoint(x: size.width + gb2.size.width/2, y: actualY)
        
        addChild(gb2)
        
        let actualDuration = random(min: CGFloat(1.5), max: CGFloat(6.0))
        let actionMove = SKAction.move(to: CGPoint(x: -gb2.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
        
        
        gb2.run(actionMove) {
            self.count+=1
        }
    }
    
    public func addGarbage3(){
        let gb3 = SKSpriteNode(imageNamed: "gb3")
        gb3.physicsBody = SKPhysicsBody(rectangleOf: gb3.size)
        gb3.physicsBody?.isDynamic = true
        gb3.physicsBody?.categoryBitMask = PhysicsCategory.gargabe
        gb3.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
        gb3.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        let actualY = random(min: gb3.size.height/2, max: size.height - gb3.size.height/2)
        gb3.position = CGPoint(x: size.width + gb3.size.width/2, y: actualY)
        
        addChild(gb3)
        
        let actualDuration = random(min: CGFloat(1.5), max: CGFloat(6.0))
        let actionMove = SKAction.move(to: CGPoint(x: -gb3.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
        
        gb3.run(actionMove) {
            self.count+=1
        }
    }
    
    public func addGarbage4(){
        let gb4 = SKSpriteNode(imageNamed: "gb4")
        gb4.physicsBody = SKPhysicsBody(rectangleOf: gb4.size)
        gb4.physicsBody?.isDynamic = true
        gb4.physicsBody?.categoryBitMask = PhysicsCategory.gargabe
        gb4.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
        gb4.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        let actualY = random(min: gb4.size.height/2, max: size.height - gb4.size.height/2)
        gb4.position = CGPoint(x: size.width + gb4.size.width/2, y: actualY)
        
        addChild(gb4)
        
        let actualDuration = random(min: CGFloat(1.5), max: CGFloat(6.0))
        let actionMove = SKAction.move(to: CGPoint(x: -gb4.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
        
        gb4.run(actionMove) {
            self.count+=1
        }
    }
    
    public func addGarbage5(){
        let gb5 = SKSpriteNode(imageNamed: "gb5")
        gb5.physicsBody = SKPhysicsBody(rectangleOf: gb5.size)
        gb5.physicsBody?.isDynamic = true
        gb5.physicsBody?.categoryBitMask = PhysicsCategory.gargabe
        gb5.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
        gb5.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        let actualY = random(min: gb5.size.height/2, max: size.height - gb5.size.height/2)
        gb5.position = CGPoint(x: size.width + gb5.size.width/2, y: actualY)
        
        addChild(gb5)
        
        let actualDuration = random(min: CGFloat(1.5), max: CGFloat(6.0))
        let actionMove = SKAction.move(to: CGPoint(x: -gb5.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
        
        gb5.run(actionMove) {
            self.count+=1
        }
    }
    
    public func addGarbage6(){
        let gb6 = SKSpriteNode(imageNamed: "gb6")
        gb6.physicsBody = SKPhysicsBody(rectangleOf: gb6.size)
        gb6.physicsBody?.isDynamic = true
        gb6.physicsBody?.categoryBitMask = PhysicsCategory.gargabe
        gb6.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
        gb6.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        let actualY = random(min: gb6.size.height/2, max: size.height - gb6.size.height/2)
        gb6.position = CGPoint(x: size.width + gb6.size.width/2, y: actualY)
        
        addChild(gb6)
        
        let actualDuration = random(min: CGFloat(1.5), max: CGFloat(6.0))
        let actionMove = SKAction.move(to: CGPoint(x: -gb6.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
        //        let actionMoveDone = SKAction.removeFromParent()
        
        gb6.run(actionMove) {
            self.count+=1
        }
    }
    
    public func addGarbage7(){
        let gb7 = SKSpriteNode(imageNamed: "gb7")
        gb7.physicsBody = SKPhysicsBody(rectangleOf: gb7.size)
        gb7.physicsBody?.isDynamic = true
        gb7.physicsBody?.categoryBitMask = PhysicsCategory.gargabe
        gb7.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
        gb7.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        let actualY = random(min: gb7.size.height/2, max: size.height - gb7.size.height/2)
        gb7.position = CGPoint(x: size.width + gb7.size.width/2, y: actualY)
        
        addChild(gb7)
        
        let actualDuration = random(min: CGFloat(1.5), max: CGFloat(6.0))
        let actionMove = SKAction.move(to: CGPoint(x: -gb7.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
        
        gb7.run(actionMove) {
            self.count+=1
        }
    }
    
    public func addGarbage8(){
        let gb8 = SKSpriteNode(imageNamed: "gb8")
        gb8.physicsBody = SKPhysicsBody(rectangleOf: gb8.size)
        gb8.physicsBody?.isDynamic = true
        gb8.physicsBody?.categoryBitMask = PhysicsCategory.gargabe
        gb8.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
        gb8.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        let actualY = random(min: gb8.size.height/2, max: size.height - gb8.size.height/2)
        gb8.position = CGPoint(x: size.width + gb8.size.width/2, y: actualY)
        
        addChild(gb8)
        
        let actualDuration = random(min: CGFloat(1.5), max: CGFloat(6.0))
        let actionMove = SKAction.move(to: CGPoint(x: -gb8.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
        //        let actionMoveDone = SKAction.removeFromParent()
        
        gb8.run(actionMove) {
            self.count+=1
        }
    }
    
    public func addGarbage9(){
        let gb9 = SKSpriteNode(imageNamed: "gb9")
        gb9.physicsBody = SKPhysicsBody(rectangleOf: gb9.size)
        gb9.physicsBody?.isDynamic = true
        gb9.physicsBody?.categoryBitMask = PhysicsCategory.gargabe
        gb9.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
        gb9.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        let actualY = random(min: gb9.size.height/2, max: size.height - gb9.size.height/2)
        gb9.position = CGPoint(x: size.width + gb9.size.width/2, y: actualY)
        
        addChild(gb9)
        
        let actualDuration = random(min: CGFloat(1.5), max: CGFloat(6.0))
        let actionMove = SKAction.move(to: CGPoint(x: -gb9.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
        
        gb9.run(actionMove) {
            self.count+=1
        }
    }
    
    public func addGarbage10(){
        let gb10 = SKSpriteNode(imageNamed: "gb10")
        gb10.physicsBody = SKPhysicsBody(rectangleOf: gb10.size)
        gb10.physicsBody?.isDynamic = true
        gb10.physicsBody?.categoryBitMask = PhysicsCategory.gargabe
        gb10.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
        gb10.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        let actualY = random(min: gb10.size.height/2, max: size.height - gb10.size.height/2)
        gb10.position = CGPoint(x: size.width + gb10.size.width/2, y: actualY)
        
        addChild(gb10)
        
        let actualDuration = random(min: CGFloat(1.5), max: CGFloat(6.0))
        let actionMove = SKAction.move(to: CGPoint(x: -gb10.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
        
        gb10.run(actionMove) {
            self.count+=1
        }
    }
    
    
    public func addGarbage11(){
        let gb11 = SKSpriteNode(imageNamed: "gb11")
        gb11.physicsBody = SKPhysicsBody(rectangleOf: gb11.size)
        gb11.physicsBody?.isDynamic = true
        gb11.physicsBody?.categoryBitMask = PhysicsCategory.gargabe
        gb11.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
        gb11.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        let actualY = random(min: gb11.size.height/2, max: size.height - gb11.size.height/2)
        gb11.position = CGPoint(x: size.width + gb11.size.width/2, y: actualY)
        
        addChild(gb11)
        
        let actualDuration = random(min: CGFloat(1.5), max: CGFloat(6.0))
        let actionMove = SKAction.move(to: CGPoint(x: -gb11.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
        
        gb11.run(actionMove) {
            self.count+=1
        }
    }
    
}
extension GameScene: SKPhysicsContactDelegate {
    public func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.gargabe != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.projectile != 0)) {
            if let gargabe = firstBody.node as? SKSpriteNode,
                let projectile = secondBody.node as? SKSpriteNode {
                projectileDidCollideWithGarbage(projectile: projectile, gargabe: gargabe)
            }
        }
    }
}
