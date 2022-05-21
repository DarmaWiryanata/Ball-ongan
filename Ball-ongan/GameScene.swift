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
    private var scoreLabel = SKLabelNode()
    
    private var stageScore = 0
    private var stagePoint = 0
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
    
    override func didMove(to view: SKView) {
        
        addCircleObstacle(divider: 10, glow: 3, circle_rotation: 0.47)
        
        scoreLabel.zPosition = 10
        scoreLabel.position.x = CGFloat(Int(frame.minY) + 342)
        scoreLabel.position.y = CGFloat(Int(frame.maxX) - 240)
        scoreLabel.fontColor = SKColor.black
        addChild(scoreLabel)
        score = 0
        
        background.zPosition = -1
        background.size = CGSize(width: frame.maxX * 2, height: frame.maxY * 2)
        addChild(background)
        
        physicsWorld.contactDelegate = self
        
        createPlayer()
        motionManager.startAccelerometerUpdates()
        createPoint()
        createObstacle()
                
    }

    func createPlayer() {
      
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
        stagePoint = ptTotal
      
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
            print("obstacle")
        default:
            print("empty node")
        }

        node.removeFromParent()

    }

    func nextStage() {
        
        // Store score to next stage
        if stageScore == stagePoint {
            score += stageScore
        }
        stageScore = 0
        stagePoint = 0
        
        // Remove point & children nodes
        for c in children {
            if c.name == "point" || c.name == "obstacle" {
                c.removeFromParent()
            }
        }
        
        // Reset player
        player.position = CGPoint(x: -100, y: 0)
        
        // Create new point & children nodes
        createPoint()
        createObstacle()
        
    }
    
    //Longan
    
    func addCircleObstacle(divider : Int, glow : Int, circle_rotation : Double) {
        
        //circle outline
        var path = UIBezierPath()
        let one_part : Double = 2 / Double(divider)
        let down_degree = circle_rotation * Double.pi
        path.addArc(withCenter: CGPoint.zero,
                    radius: 40,
                    startAngle: CGFloat(down_degree),
                    endAngle: CGFloat(down_degree + (2.05-one_part) * Double.pi),
                    clockwise: false)
        let circle_outline = obstacleByDuplicatingPath(path, clockwise: true, divider: divider, glow: glow)
        circle_outline.position = CGPoint(x: 0, y: 0)
        circle_outline.zPosition = 10
        addChild(circle_outline)
        
        //circle inside
        path = UIBezierPath()
        path.addArc(withCenter: CGPoint.zero,
                    radius: 30,
                    startAngle: CGFloat(0.0),
                    endAngle: CGFloat(2 * Double.pi),
                    clockwise: false)
        
        let section = SKShapeNode(path: path.cgPath)
        section.position = CGPoint(x: 0, y: 0)
        let color : SKColor
        if divider == glow{
            color = .orange
        }else{
            color = .purple
        }
        section.fillColor = color
        section.strokeColor = color
        section.zPosition = 10
        addChild(section)
        
    }
    
    
    func obstacleByDuplicatingPath(_ path: UIBezierPath, clockwise: Bool, divider : Int, glow: Int) -> SKNode {
        let container = SKNode()
        let one_part : Double = 2 / Double(divider) * Double.pi

        var rotationFactor = CGFloat(one_part)
        if !clockwise {
            rotationFactor *= -1
        }

        for i in 0...Int(divider-1) {
            let section = SKShapeNode(path: path.cgPath)
            section.lineWidth = 5
            if i < glow{
                section.strokeColor = .orange
            }else{
                section.strokeColor = .purple
            }
            section.zRotation = -((rotationFactor) * CGFloat(i));

            container.addChild(section)
        }

        return container
    }
    
}
