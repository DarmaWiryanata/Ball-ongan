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
    private var music = SKAudioNode(fileNamed: "music.wav")
  
    private var scoreLabel = SKLabelNode(fontNamed: "IM FELL DW Pica SC")
    private var stageScore = 0
    private var stagePoint = 0
    private var score = 0 {
        didSet {
            scoreLabel.text = "\(score) pts"
        }
    }
  
    private var timerNode = SKLabelNode(fontNamed: "IM FELL DW Pica SC")
    private var minute: Int = 0
    private var second: Int = 60
    private var time: Int = 21 {
        didSet {
            if time <= 120 && time % 60 < 10 {
                timerNode.text = "0\(time / 60 % 60) : 0\(time % 60)"
            } else if time <= 120 && time > 60 {
                timerNode.text = "0\(time / 60 % 60) : \(time % 60)"
            } else if time < 10 {
                timerNode.text = "00 : 0\(time)"
            } else if time <= 60 {
                timerNode.text = "00 : \(time)"
            }
        }
    }
  
    private func countdown() -> Void {

        time -= 1

        if (time <= 0 ) {
            endGame()
        }

    }
  
    let motionManager = CMMotionManager()
    var xAcceleration:CGFloat = 0
    var yAcceleration:CGFloat = 0
    
    private var pointsTotal = GKRandomDistribution(lowestValue: 3, highestValue: 10)
    private var obstaclesTotal = GKRandomDistribution(lowestValue: 3, highestValue: 7)
    override func didMove(to view: SKView) {
        // First launch
        
        if Firstimer.shared.isNewUser() {
            Firstimer.shared.isNotNewuser()
            let tutorial = TutorialScene1(fileNamed: "TutorialScene1")
            tutorial!.scaleMode = .aspectFill
            let transition = SKTransition.fade(withDuration: 0.3)
            self.view?.presentScene(tutorial!,transition: transition)
        }else{
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
        
        addChild(music)
        
        physicsWorld.contactDelegate = self
        
        createPlayer()
        motionManager.startAccelerometerUpdates()
        createPoint()
        createObstacle()
        }
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
        if player.position.x > -40 && player.position.x < 40 && player.position.y > -40 && player.position.y < 40 {
            nextStage()
        }

    }

    enum playerPosition: Int {
    case minX = -160
    case maxX = -140
    case minY = -10
    case maxY = 10
    }

    enum goalPosition: Int {
    case min = -25
    case max = 25
    }

    func randomDistribution() -> [String : Int] {

        var randomDistributionX: GKRandomDistribution?
        var randomDistributionY: GKRandomDistribution?
        
        var x: Int
        var y: Int

        repeat {
            randomDistributionX = GKRandomDistribution(lowestValue: Int(frame.minY) + 342, highestValue: Int(frame.maxY) - 307)
            randomDistributionY = GKRandomDistribution(lowestValue: Int(frame.minX) + 215, highestValue: Int(frame.maxX) - 215)
            
            x = randomDistributionX!.nextInt()
            y = randomDistributionY!.nextInt()
        } while // Compare with player position
                (x > playerPosition.minX.rawValue && x < playerPosition.maxX.rawValue)
             || (y > playerPosition.minY.rawValue && y < playerPosition.maxY.rawValue)
                // Compare with goal position
             || (x > goalPosition.min.rawValue && x < goalPosition.max.rawValue)
             || (y > goalPosition.min.rawValue && y < goalPosition.max.rawValue)

        return [
            "x": x,
            "y": y
        ]

    }

    func createPoint() {

        stagePoint = self.pointsTotal.nextInt()
        
        addCircleObstacle(divider: stagePoint, glow: stageScore, circle_rotation: 0.47)
      
        for _ in 0..<stagePoint {

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
            playerHitPoint()
        case "obstacle":
            time -= 10
        default:
            print("empty node")
        }

        node.removeFromParent()

    }
    
    func playerHitPoint() {
        
        stageScore += 1
        
        // Remove point & children nodes
        for c in children {
            if c.name == "goal" || c.name == "goalPoints" {
                c.removeFromParent()
            }
        }
        
        addCircleObstacle(divider: stagePoint, glow: stageScore, circle_rotation: 0.47)

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
            if c.name == "point" || c.name == "obstacle" || c.name == "goal" || c.name == "goalPoints" {
                c.removeFromParent()
            }
        }
        
        // Reset player
        player.position = CGPoint(x: -100, y: 0)
        
        // Create new point & children nodes
        createPoint()
        createObstacle()
        
    }
    
    // Longan
    func addCircleObstacle(divider : Int, glow : Int, circle_rotation : Double) {
        
        // Circle outline
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
        circle_outline.zPosition = 0
        circle_outline.name = "goalPoints"
        addChild(circle_outline)
        
        // Circle inside
        path = UIBezierPath()
        path.addArc(withCenter: CGPoint.zero,
                    radius: 30,
                    startAngle: CGFloat(0.0),
                    endAngle: CGFloat(2 * Double.pi),
                    clockwise: false)
        
        let section = SKShapeNode(path: path.cgPath)
        section.position = CGPoint(x: 0, y: 0)
        let color : SKColor
        if divider == glow {
            color = .orange
        } else {
            color = .purple
        }
        section.fillColor = color
        section.strokeColor = color
        section.zPosition = 0
        section.name = "goal"
        
//        section.physicsBody = SKPhysicsBody(circleOfRadius: 20)
//        section.physicsBody?.affectedByGravity = false
//        section.physicsBody?.contactTestBitMask = 1
//        section.physicsBody?.categoryBitMask = 0
//        section.physicsBody?.collisionBitMask = 0
        
        addChild(section)
        
    }
    
    
    func obstacleByDuplicatingPath(_ path: UIBezierPath, clockwise: Bool, divider : Int, glow: Int) -> SKNode {
        let container = SKNode()
        let one_part : Double = 2 / Double(divider) * Double.pi

        var rotationFactor = CGFloat(one_part)
        if !clockwise {
            rotationFactor *= -1
        }
        
        print(divider)
        print(glow)

        for i in 0...divider-1 {
            let section = SKShapeNode(path: path.cgPath)
            section.lineWidth = 5
            if i < glow {
                section.strokeColor = .orange
            } else {
                section.strokeColor = .purple
            }
            section.zRotation = -((rotationFactor) * CGFloat(i));

            container.addChild(section)
        }

        return container
    }
    
    func endGame() {
        music.removeFromParent()
        
        let endGame = EndGame(fileNamed: "EndGame")
        endGame?.scoreVal = score
        endGame!.scaleMode = .aspectFill
        let transition = SKTransition.fade(withDuration: 0.3)
        self.view?.presentScene(endGame!,transition: transition)
    }
    
}

class Firstimer {
    static let shared = Firstimer()
    
    func isNewUser() -> Bool{
        return !UserDefaults.standard.bool(forKey: "isNewUser")
    }
    func isNotNewuser(){
        UserDefaults.standard.set(true ,forKey: "isNewUser")
    }
}
