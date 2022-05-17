//
//  GameScene.swift
//  Ball-ongan
//
//  Created by Darma Wiryanata on 10/05/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var player = SKSpriteNode(imageNamed: "player")
    private var background = SKSpriteNode(imageNamed: "background")
    private var obstacle = SKSpriteNode(imageNamed: "obstacle")
    private var point = SKSpriteNode(imageNamed: "point")
    
    private var level = 1
    private var score = 0
    
    func screenWidth() -> CGFloat {
        return self.view!.bounds.width
    }
    
    func screenHeight() -> CGFloat {
        return self.view!.bounds.height
    }
    
    override func didMove(to view: SKView) {
        
        background.zPosition = -1
        background.size = CGSize(width: screenWidth(), height: screenHeight())
        addChild(background)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
