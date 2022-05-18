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
        return frame.size.width
    }
    
    func screenHeight() -> CGFloat {
        return frame.size.height
    }
    
    override func didMove(to view: SKView) {
        
        background.zPosition = -1
        background.size = CGSize(width: screenWidth(), height: screenHeight())
        addChild(background)
        
        createPlayer()
        createPoint()
        createObstacle()
        
    }
    
    func createPlayer() {
        let sprite = SKSpriteNode(imageNamed: "player")
        sprite.position = CGPoint(x: -screenWidth()/4, y: 0)
        sprite.size = CGSize(width: 50, height: 50)
        sprite.name = "player"
        sprite.zPosition = 1
        addChild(sprite)
    }
    
    func createPoint() {
        
        let pointsTotal = level + 2
        
        let randomDistributionX = GKRandomDistribution(lowestValue: -Int(screenWidth()/2 - 75), highestValue: Int(screenWidth()/2 - 50))
        let randomDistributionY = GKRandomDistribution(lowestValue: -Int(screenHeight()/2 - 30), highestValue: Int(screenHeight()/2 - 30))
        
        for _ in 0..<pointsTotal {
            let sprite = SKSpriteNode(imageNamed: "point")
            sprite.position = CGPoint(x: randomDistributionX.nextInt(), y: randomDistributionY.nextInt())
            sprite.size = CGSize(width: 25, height: 25)
            sprite.name = "point"
            sprite.zPosition = 1
            addChild(sprite)
        }
        
    }
    
    func createObstacle() {
        
        let obstaclesTotal = 5 + (level * 2)
        
        let randomDistributionX = GKRandomDistribution(lowestValue: -Int(screenWidth()/2 - 75), highestValue: Int(screenWidth()/2 - 50))
        let randomDistributionY = GKRandomDistribution(lowestValue: -Int(screenHeight()/2 - 30), highestValue: Int(screenHeight()/2 - 30))
        
        for _ in 0..<obstaclesTotal {
            let sprite = SKSpriteNode(imageNamed: "obstacle")
            sprite.position = CGPoint(x: randomDistributionX.nextInt(), y: randomDistributionY.nextInt())
            sprite.size = CGSize(width: 25, height: 25)
            sprite.name = "obstacle"
            sprite.zPosition = 1
            addChild(sprite)
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
