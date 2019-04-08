//
//  StartGameScene.swift
//  WWDC19Application
//
//  Created by Adriano Leal De Freitas Ramos on 18/03/19.
//  Copyright © 2019 Adriano Ramos. All rights reserved.
//
import UIKit
import SpriteKit

public class StartGameScene: SKScene {
    override public func didMove(to view: SKView) {
        super.didMove(to: view)
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        for t in touches {
            touchDown(position: t.location(in: self))
        }
    }
    
    public func touchDown(position: CGPoint){
        if self.nodes(at: position).contains(self.childNode(withName: "play")!){
            let selectPlayerScene = SelectPlayerScene(fileNamed: "SelectPlayerScene")!
            selectPlayerScene.scaleMode = .aspectFit
            let transition = SKTransition.doorsOpenHorizontal(withDuration: 0.9)
            view?.presentScene(selectPlayerScene, transition: transition)
        }
        
    }
}
