//
//  GameScene.swift
//  Ball-ongan
//
//  Created by Darma Wiryanata on 10/05/22.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var player = SKSpriteNode(imageNamed: "player")
    private var background = SKSpriteNode(imageNamed: "background")
    private var obstacle = SKSpriteNode(imageNamed: "obstacle")
    private var point = SKSpriteNode(imageNamed: "point")
    private var scoreLabel = SKLabelNode()
    
    private var stageScore = 0
    private var score = 0 {
        didSet {
            scoreLabel.text = "\(score) pts"
        }
    }
    
    let motionManager = CMMotionManager()
    var xAcceleration:CGFloat = 0
    var yAcceleration:CGFloat = 0
    
    private var pointsTotal = GKRandomDistribution(lowestValue: 1, highestValue: 10)
    private var obstaclesTotal = GKRandomDistribution(lowestValue: 1, highestValue: 3)
    
    func screenWidth() -> CGFloat {
        return frame.size.width
    }
    
    func screenHeight() -> CGFloat {
        return frame.size.height
    }
    
    override func didMove(to view: SKView) {
        scoreLabel.zPosition = 10
        scoreLabel.position.x = -screenWidth()/2 + 75
        scoreLabel.position.y = screenWidth()/2 - 250
        scoreLabel.fontColor = SKColor.black
        addChild(scoreLabel)
        score = 0
        
        background.zPosition = -1
        background.size = CGSize(width: screenWidth(), height: screenHeight())
        addChild(background)
        
        physicsWorld.contactDelegate = self
        
        createPlayer()
        motionManager.startAccelerometerUpdates()
        createPoint()
        createObstacle()
        
    }
    
    func createPlayer() {
      
        player = SKSpriteNode(imageNamed: "player")
        player.size = CGSize(width: 50, height: 50)
        player.position = CGPoint(x: -screenWidth()/4, y: 0)
        player.name = "player"
        player.zPosition = 1
      
        player.physicsBody?.affectedByGravity = true
        player.physicsBody?.allowsRotation = true
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = 1
        player.physicsBody?.collisionBitMask = 2
        player.physicsBody?.fieldBitMask = 1
        player.physicsBody?.contactTestBitMask = 2
        
        addChild(player)
      
    }
    
    override func update(_ currentTime: TimeInterval ){
        
        let screenMinX = frame.minX + 55
        let screenMaxX = frame.maxX - 25
        let screenMinY = frame.minY + 515
        let screenMaxY = frame.maxY - 520
        
        if let accelerometerData = motionManager.accelerometerData{
            let changeX = CGFloat(accelerometerData.acceleration.y) * 15
            let changeY = CGFloat(accelerometerData.acceleration.x) * 15
            
            player.position.x -= changeX
            player.position.y += changeY
        }
        
        if player.position.x <  screenMinX {
            player.position.x = screenMinX
        } else if player.position.x > screenMaxX {
            player.position.x = screenMaxX
        }
        
        if player.position.y < screenMinY {
            player.position.y = screenMinY
        } else if player.position.y > screenMaxY {
            player.position.y = screenMaxY
        }
        
    }
    
    func createPoint() {
        
        let randomDistributionX = GKRandomDistribution(lowestValue: -Int(screenWidth()/2 - 75), highestValue: Int(screenWidth()/2 - 50))
        let randomDistributionY = GKRandomDistribution(lowestValue: -Int(screenHeight()/2 - 30), highestValue: Int(screenHeight()/2 - 30))
        
        for _ in 0..<self.pointsTotal.nextInt() {
            
            let sprite = SKSpriteNode(imageNamed: "point")
            sprite.position = CGPoint(x: randomDistributionX.nextInt(), y: randomDistributionY.nextInt())
            sprite.size = CGSize(width: 25, height: 25)
            sprite.name = "point"
            sprite.zPosition = 1
            addChild(sprite)
            
            sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
            sprite.physicsBody?.affectedByGravity = false
            
            sprite.physicsBody?.contactTestBitMask = 1
            sprite.physicsBody?.categoryBitMask = 0
            sprite.physicsBody?.collisionBitMask = 0
            
        }
        
    }
    
    func createObstacle() {
        
        let randomDistributionX = GKRandomDistribution(lowestValue: -Int(screenWidth()/2 - 75), highestValue: Int(screenWidth()/2 - 50))
        let randomDistributionY = GKRandomDistribution(lowestValue: -Int(screenHeight()/2 - 30), highestValue: Int(screenHeight()/2 - 30))
        
        for _ in 0..<self.obstaclesTotal.nextInt() {
            
            let sprite = SKSpriteNode(imageNamed: "obstacle")
            sprite.position = CGPoint(x: randomDistributionX.nextInt(), y: randomDistributionY.nextInt())
            sprite.size = CGSize(width: 25, height: 25)
            sprite.name = "obstacle"
            sprite.zPosition = 1
            addChild(sprite)
            
            sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
            sprite.physicsBody?.affectedByGravity = false

            sprite.physicsBody?.contactTestBitMask = 1
            sprite.physicsBody?.categoryBitMask = 0
            
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {

        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }

        if nodeA == player {
            playerHit(nodeB)
        } else {
            playerHit(nodeA)
        }

    }

    func playerHit(_ node: SKNode) {
        
        switch node.name {
        case "point":
            stageScore += 1
        case "obstacle":
            print("obstacle")
        default:
            print("empty node")
        }
        
        node.removeFromParent()
        
    }
    
}
