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
    
    override func didMove(to view: SKView) {
        
        let screenWidth = self.view!.bounds.width
        let screenHeight = self.view!.bounds.height
        
        background.zPosition = -1
        background.size = CGSize(width: screenWidth, height: screenHeight)
        addChild(background)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
