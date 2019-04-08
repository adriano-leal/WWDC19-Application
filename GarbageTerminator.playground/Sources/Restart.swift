//
//  Restart.swift
//  WWDC19Application
//
//  Created by Adriano Leal De Freitas Ramos on 22/03/19.
//  Copyright © 2019 Adriano Ramos. All rights reserved.
//

import SpriteKit

public class Restart: SKScene {
    
    var score = 0
    
    public convenience init?(fileName: String, score: Int) {
        self.init(fileNamed: fileName)
        self.score = score
    }
    
    override public func didMove(to view: SKView) {
        super.didMove(to: view)
        
        guard let labelNode = childNode(withName: "finalScore") as? SKLabelNode else { return }
        
        labelNode.text = String(score)
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            touchDown(position: t.location(in: self))
        }
    }
    
    public func touchDown(position: CGPoint){
        if self.nodes(at: position).contains(self.childNode(withName: "restart")!){
            let selectPlayerScene = SelectPlayerScene(fileNamed: "SelectPlayerScene")!
            selectPlayerScene.scaleMode = .aspectFit
            let transition = SKTransition.flipVertical(withDuration: 0.5)
            view?.presentScene(selectPlayerScene, transition: transition)
        }
    }
}


