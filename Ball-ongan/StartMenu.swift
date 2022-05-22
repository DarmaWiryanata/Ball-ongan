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
    private var text = SKLabelNode(fontNamed: "IM FELL DW Pica SC")
    
    override func didMove(to view: SKView) {
        
        background.zPosition = -1
        background.size = CGSize(width: frame.maxY * 1.2, height: frame.maxX)
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
            
            if location.y < 50 && location.y > -50 && location.x < 50 && location.x > -50 {
                
                text.text = "loading..."
                text.fontColor = SKColor.white
                text.position.x = CGFloat(0)
                text.position.y = CGFloat(-100)
                text.zPosition = 120
                addChild(text)
                
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    let game = GameScene(fileNamed: "GameScene")
                    game!.scaleMode = .aspectFill
                    let transition = SKTransition.fade(withDuration: 0.3)
                    self.view?.presentScene(game!,transition: transition)
                }
                
            }
            
        }
    }
}
