//
//  GameViewController.swift
//  WWDC19Application
//
//  Created by Adriano Leal De Freitas Ramos on 18/03/19.
//  Copyright © 2019 Adriano Ramos. All rights reserved.
//

import UIKit
import GameplayKit
import SpriteKit

public class GameViewController: UIViewController {
    
    static var sceneView: SKView?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        let scene = StartGameScene(size: view.bounds.size)
        let skView = view as! SKView
        GameViewController.sceneView = skView
        skView.showsNodeCount = true
        scene.scaleMode = .aspectFit
        skView.presentScene(scene)
    }
    override public var prefersStatusBarHidden: Bool {
        return true
    }
    
}

