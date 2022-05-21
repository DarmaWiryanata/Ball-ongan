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
    public var background = SKSpriteNode(imageNamed: "background")
    private var obstacle = SKSpriteNode(imageNamed: "obstacle")
    private var point = SKSpriteNode(imageNamed: "point")
    private var scoreLabel = SKLabelNode()
    private var stageScore = 0
    private var score = 0 {
        didSet {
            scoreLabel.text = "\(score) pts"
        }
    }
    private var timerNode = SKLabelNode()
    private var minute: Int = 0
    private var second: Int = 60
    private var time: Int = 21
    {
        didSet
        {
            
            if time <= 120 && time % 60 < 10
            {
                timerNode.text = "0\(time / 60 % 60) : 0\(time % 60)"
            }
            else if time <= 120 && time > 60
            {
                timerNode.text = "0\(time / 60 % 60) : \(time % 60)"
            }
            else if time < 10
            {
                timerNode.text = "00 : 0\(time)"
            }
            else if time <= 60
            {
                timerNode.text = "00 : \(time)"
            }
            
        }
    }
    private func countdown() -> Void
    {
        
        time -= 1
        
        if (time <= 0 )
        {
            endGame()
        }
    }
    let motionManager = CMMotionManager()
    var xAcceleration:CGFloat = 0
    var yAcceleration:CGFloat = 0
    
    private var pointsTotal = GKRandomDistribution(lowestValue: 3, highestValue: 10)
    private var obstaclesTotal = GKRandomDistribution(lowestValue: 3, highestValue: 7)
    
    override func didMove(to view: SKView) {
     //   let test2 = frame.size
        let test1 = frame.size
        // Add Timer
        timerNode.zPosition =  2
        timerNode.position.x = CGFloat(Int(frame.minY) + 950)
        timerNode.position.y = CGFloat(Int(frame.maxX) - 240)
        timerNode.fontColor = SKColor.white
        addChild(timerNode)
        time = 120
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(countdown),SKAction.wait(forDuration: 1)])))
        // Add Score
        scoreLabel.zPosition = 10
        scoreLabel.position.x = CGFloat(Int(frame.minY) + 342)
        scoreLabel.position.y = CGFloat(Int(frame.maxX) - 240)
        scoreLabel.fontColor = SKColor.white
        addChild(scoreLabel)
        score = 0
        
        background.zPosition = -1
        background.size = CGSize(width: frame.maxY*1.2, height: frame.maxX)
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
        player.position = CGPoint(x: -150, y: 0)
        player.name = "player"
        player.zPosition = 1
        
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.allowsRotation = true
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = 1
        
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
        
        // Go to next stage
        if player.position.x > -25 && player.position.x < 25 && player.position.y > -25 && player.position.y < 25 {
            nextStage()
        }
        
    }
    
    enum playerPosition: Int {
    case minX = -200
    case maxX = -100
    case minY = -50
    case maxY = 50
    }
    
    enum goalPosition: Int {
    case min = -100
    case max = 100
    }
    
    func randomDistribution() -> [String : Int] {
        
        var randomDistributionX: GKRandomDistribution?
        var randomDistributionY: GKRandomDistribution?
        
        repeat {
            randomDistributionX = GKRandomDistribution(lowestValue: Int(frame.minY) + 342, highestValue: Int(frame.maxY) - 307)
            randomDistributionY = GKRandomDistribution(lowestValue: Int(frame.minX) + 215, highestValue: Int(frame.maxX) - 215)
        } while // Compare with player position
                (randomDistributionX!.nextInt() > playerPosition.minX.rawValue && randomDistributionX!.nextInt() < playerPosition.maxX.rawValue)
             || (randomDistributionY!.nextInt() > playerPosition.minY.rawValue && randomDistributionY!.nextInt() < playerPosition.maxY.rawValue)
                // Compare with goal position
             || (randomDistributionX!.nextInt() > goalPosition.min.rawValue && randomDistributionX!.nextInt() < goalPosition.max.rawValue)
             || (randomDistributionY!.nextInt() > goalPosition.min.rawValue && randomDistributionY!.nextInt() < goalPosition.max.rawValue)
        
        return [
            "x": randomDistributionX!.nextInt(),
            "y": randomDistributionY!.nextInt()
        ]
        
    }
    
    func createPoint() {
        
        let ptTotal: Int = self.pointsTotal.nextInt()
        
        for _ in 0..<ptTotal {
            
            let position = randomDistribution()
            guard let posX = position["x"] else { continue }
            guard let posY = position["y"] else { continue }
            
            let sprite = SKSpriteNode(imageNamed: "point")
            sprite.position = CGPoint(x: posX, y: posY)
            
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
        
        let obTotal: Int = self.obstaclesTotal.nextInt()
        
        for _ in 0..<obTotal {
            
            let position = randomDistribution()
            guard let posX = position["x"] else { continue }
            guard let posY = position["y"] else { continue }
            
            let sprite = SKSpriteNode(imageNamed: "obstacle")
            sprite.position = CGPoint(x: posX, y: posY)
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
            time -= 10
        default:
            print("empty node")
        }
        
        node.removeFromParent()
        
    }
    
    func nextStage() {
        score += stageScore
        stageScore = 0
    }
    
    func endGame(){
        let endGame = EndGame(fileNamed: "EndGame")
        endGame!.scaleMode = .aspectFill
        let transition = SKTransition.fade(withDuration: 0.3)
        self.view?.presentScene(endGame!,transition: transition)
    }
    
}
