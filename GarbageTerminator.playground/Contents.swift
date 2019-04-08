//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit
/*:
 # GarbageTerminator
 
 Four cute robots were created to help destroy all the garbage that pollute the planet and, eventually, can cause huge harms towards the environment.
 
 Select your character and **touch over** the garbage that pop up on the scene. You only have 3 lives so don't let any garbage slip away from you!
 
 *For a better experience, play the game on landscape and widescreen mode*

 ![alternate text](howTo.png)
 
 Shoot multiple times while playing :)
 */




let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 2048, height: 1536))
if let scene = StartGameScene(fileNamed: "StartGameScene") {
    scene.scaleMode = .aspectFit
    sceneView.presentScene(scene)
}
PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
