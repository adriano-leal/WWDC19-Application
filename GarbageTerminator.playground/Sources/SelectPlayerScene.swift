//
//  SelectPlayerScene.swift
//  WWDC19Application
//
//  Created by Adriano Leal De Freitas Ramos on 22/03/19.
//  Copyright © 2019 Adriano Ramos. All rights reserved.
//

import GameKit
import SpriteKit


public class SelectPlayerScene: SKScene {
    var player: String = "player"
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches{
            touchDown(position: t.location(in: self))
        }
    }
    
    let transition = SKTransition.moveIn(with: .up, duration: 0.5)
    let transitionBack = SKTransition.doorsCloseHorizontal(withDuration: 0.8)
    let selection = SKSpriteNode(imageNamed: "selection")
    
    public func touchDown(position: CGPoint){
        
        if self.nodes(at: position).contains(self.childNode(withName: "back")!){
            if let startGameScene = StartGameScene(fileNamed: "StartGameScene"){
                startGameScene.scaleMode = .aspectFit
                view?.presentScene(startGameScene, transition: transitionBack)
            }
        }
        
        if self.nodes(at: position).contains(self.childNode(withName: "startGame")!){
            if let gameScene = GameScene(fileName: "GameScene", player: player){
                gameScene.scaleMode = .aspectFit
                view?.presentScene(gameScene, transition: transition)
            }
        }
        
        if let playerNode = self.childNode(withName: "player") {
            if self.nodes(at: position).contains(playerNode){
                player = "player"
                let p1 = self.childNode(withName: "player")?.position ?? .zero
                selection.position = p1
                if selection.parent == nil {
                    addChild(selection)
                }
            }
        }
        
        if self.nodes(at: position).contains(self.childNode(withName: "player2")!){
            selection.removeFromParent()
            player = "player2"
            let p2 = self.childNode(withName: "player2")!
            selection.position = p2.position
            selection.size = CGSize(width: p2.frame.size.width*1.5, height: p2.frame.size.height*1.5)
            addChild(selection)
        }
        
        if self.nodes(at: position).contains(self.childNode(withName: "player3")!){
            selection.removeFromParent()
            player = "player3"
            let p3 = self.childNode(withName: "player3")!
            selection.position = p3.position
            selection.size = CGSize(width: p3.frame.size.width*1.5, height: p3.frame.size.height*1.5)
            addChild(selection)
        }
        
        if self.nodes(at: position).contains(self.childNode(withName: "player4")!){
            selection.removeFromParent()
            player = "player4"
            let p4 = self.childNode(withName: "player4")!
            selection.position = p4.position
            selection.size = CGSize(width: p4.frame.size.width*1.5, height: p4.frame.size.height*1.5)
            addChild(selection)
        }
    }
}

