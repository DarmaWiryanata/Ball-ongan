//
//  GameScene.swift
//  Ball-ongan
//
//  Created by Darma Wiryanata on 10/05/22.
//

import SpriteKit
import GameplayKit
import CoreMotion
class GameScene: SKScene {
    var wall : SKSpriteNode!
    var player : SKSpriteNode!
    //private var background = SKSpriteNode(imageNamed: "background")
    private var obstacle = SKSpriteNode(imageNamed: "obstacle")
    private var point = SKSpriteNode(imageNamed: "point")
    let motionManager = CMMotionManager()
    var xAcceleration:CGFloat = 0
    var yAcceleration:CGFloat = 0
    private var level = 1
    private var score = 0
    
    func screenWidth() -> CGFloat {
        return self.view!.bounds.width
    }
    
    func screenHeight() -> CGFloat {
        return self.view!.bounds.height
    }
    
    override func didMove(to view: SKView) {
        
//        background.zPosition = -1
//        background.size = CGSize(width: screenWidth(), height: screenHeight())
//        addChild(background)
       
        
        
            
        
        createPlayer()
        motionManager.startAccelerometerUpdates()
        createPoint()
        createObstacle()
        
    }
    
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        player.physicsBody?.affectedByGravity = true
        player.physicsBody?.allowsRotation = true
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = 1
        player.physicsBody?.collisionBitMask = 2
        player.physicsBody?.fieldBitMask = 1
        player.physicsBody?.contactTestBitMask = 2
        player.size = CGSize(width: 50, height: 50)
        
        self.addChild(player)
    }
    
    override func update(_ currentTime: TimeInterval ){
        if let accelerometerData = motionManager.accelerometerData{
            let changeX = CGFloat(accelerometerData.acceleration.y) * 15
            let changeY = CGFloat(accelerometerData.acceleration.x) * 15
            var posisiX = player.position.x
            var posisiY = player.position.y
            var screenMinX = frame.minX
            var screenMaxX = frame.maxX
            var screenMinY = frame.minY
            var screenMaxY = frame.maxY
            if player.position.x <  frame.minX {
                player.position.x = frame.minX
            }else if player.position.x > frame.maxX{
                player.position.x = frame.maxX
            }else{
                player.position.x -= changeX
            }
            if player.position.y < -155{
                player.position.y = -155
            }else if player.position.y > 155{
                player.position.y = 155
            }else{
                player.position.y += changeY
            }
        }
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
    
}
