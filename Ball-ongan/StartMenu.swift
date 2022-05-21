//
//  StartMenu.swift
//  Ball-ongan
//
//  Created by Muhammad Aleandro on 20/05/22.
//

import SpriteKit
import GameplayKit
import CoreMotion

class StartMenu: SKScene, SKPhysicsContactDelegate {
    private var startButton = SKSpriteNode(imageNamed: "Start")
    private var background = SKSpriteNode(imageNamed: "background")
    private var title = SKSpriteNode(imageNamed: "Title")
    override func didMove(to view: SKView) {
        background.zPosition = -1
        background.size = CGSize(width: frame.maxY*1.2, height: frame.maxX)
        addChild(background)
        startButton.zPosition = 0
        startButton.size = CGSize(width: 100, height: 100)
        addChild(startButton)
        title.position.y = 100
        title.size = CGSize(width: 195,height: 39)
        addChild(title)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            //let startNode = atPoint(location)
            
            if location.y < 50 && location.y > -50 && location.x < 50 && location.x > -50{
               
                let game = GameScene(fileNamed: "GameScene")
                game!.scaleMode = .aspectFill
                let test1 = frame.size
                let transition = SKTransition.fade(withDuration: 0.3)
                self.view?.presentScene(game!,transition: transition)
                
            }
            
        }
    }
}
