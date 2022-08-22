//
//  TutorialScene1.swift
//  Ball-ongan
//
//  Created by Muhammad Aleandro on 22/05/22.
//

import SpriteKit
import GameplayKit
import CoreMotion

class TutorialScene1: SKScene, SKPhysicsContactDelegate {
    private var tutorialScene : SKSpriteNode!
    private var text = SKLabelNode(fontNamed: "IM FELL DW Pica SC")
    var gameMode: String?
    override func didMove(to view: SKView) {
        setTutorial(count: 1)
    }
    func setTutorial(count:Int){
        tutorialScene = SKSpriteNode(imageNamed: "tutorial"+String(count))
        tutorialScene.zPosition = CGFloat(count)
        tutorialScene.size = CGSize(width: frame.maxY * 1.2, height: frame.maxX)
        addChild(tutorialScene)
    }
    private var count = 1
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for _ in touches {
            if count == 6{
                text.text = "loading..."
                text.fontColor = SKColor.white
                text.position.x = CGFloat(0)
                text.position.y = CGFloat(-100)
                text.zPosition = 120
                addChild(text)
                
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    let game = ControlMenu(fileNamed: "ControlMenu")
                    game!.scaleMode = .aspectFill
                    let transition = SKTransition.fade(withDuration: 0.5)
                    self.view?.presentScene(game!,transition: transition)
                }
            }else{
                count += 1
                setTutorial(count: count)
            }
        }
    }
    
}
