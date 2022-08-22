//
//  GameScene.swift
//  Ball-ongan
//
//  Created by Darma Wiryanata on 10/05/22.
//

import SpriteKit
import GameplayKit
import CoreMotion
import Foundation
import AudioToolbox

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var player = SKSpriteNode(imageNamed: "player")
    public var background = SKSpriteNode(imageNamed: "background")
    private var music = SKAudioNode(fileNamed: "music.wav")
    
    //Pause Node
    private var pauseBtn = SKSpriteNode()
    private var continueBtn = SKSpriteNode()
    private var homeBtn = SKSpriteNode()
    private var restartBtn = SKSpriteNode()
    private var pauseBG = SKSpriteNode()
    
    private var touchControl = Utility.shared.getControl()
    private var scoreLabel = SKLabelNode(fontNamed: "IM FELL DW Pica SC")
    private var stageScore = 0
    private var stagePoint = 0
    
    private var score = 0 {
        didSet {
            if gameMode == "timeattack"{
                scoreLabel.text = "\(score) pts"
            }
            else if gameMode == "survival"{
                Utility.shared.setScore(score: score)
                let currentScore = Utility.shared.getScore()
                if currentScore <= 0{
                    scoreLabel.text = "\(score) pts"
                }else{
                scoreLabel.text = "\(String(currentScore)) pts"
                }
            }
        }
    }
    
    var gameMode : String?
    private var timerNode = SKLabelNode(fontNamed: "IM FELL DW Pica SC")
    private var levelNode = SKLabelNode(fontNamed: "IM FELL DW Pica SC")
    private var minute: Int = 0
    private var second: Int = 60
    private var level: Int = UserDefaults.standard.integer(forKey: "level") {
        didSet{
            levelNode.text = String(level)
        }
    }
    private var time: Int = 21 {
        didSet {
            if time >= 0{
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
    }
    
    private func pauseButton() -> SKSpriteNode {
        let image = UIImage(systemName: "pause.circle.fill")!.withTintColor(.white)

        let data = image.pngData()!
        let newImage = UIImage(data:data)
        let texture = SKTexture(image: newImage!)
        pauseBtn = SKSpriteNode(texture: texture,size: CGSize(width: 32, height: 32))
        pauseBtn.zPosition = 2
        pauseBtn.position.x = CGFloat(Int(frame.minY) + 1000)
        pauseBtn.position.y = CGFloat(Int(frame.maxX) - 230)
        
        return pauseBtn
    }
    
    private func pauseSymbolToSprite(symbol : String, xPos : CGFloat) -> SKSpriteNode {
        let image = UIImage(systemName: symbol)!.withTintColor(.white)

        let data = image.pngData()!
        let newImage = UIImage(data:data)
        let texture = SKTexture(image: newImage!)
        let sprite = SKSpriteNode(texture: texture,size: CGSize(width: 70, height: 70))
        sprite.zPosition = 101
        sprite.position.y = -10
        sprite.position.x = xPos
        
        return sprite
    }
  
    private func countdown() -> Void {

        time -= 1

        if (time <= 0 ) {
            endGame()
        }

    }
    
    private var pointsTotal = GKRandomDistribution(lowestValue: 3, highestValue: 10)
    private var obstaclesTotal = GKRandomDistribution(lowestValue: 3, highestValue: 7)
    
    var touchControl = true
    
    // Accelerometer control
    let motionManager = CMMotionManager()
    var xAcceleration:CGFloat = 0
    var yAcceleration:CGFloat = 0
    
    // Touch control
    let joystick = SKSpriteNode(imageNamed: "jSubstrate")
    let knob = SKSpriteNode(imageNamed: "jStick")
    var joystickIsActivated = false
    
    override func didMove(to view: SKView) {
        if Firstimer.shared.isNewUser() {
            // First launch
            Firstimer.shared.isNotNewuser()
            let tutorial = TutorialScene1(fileNamed: "TutorialScene1")
            tutorial!.scaleMode = .aspectFill
            tutorial!.gameMode = self.gameMode
            let transition = SKTransition.fade(withDuration: 0.3)
            self.view?.presentScene(tutorial!,transition: transition)
        } else {    
            // Pause button
            addChild(pauseButton())
                
            if gameMode == "timeattack" {
                // Add Timer
                timerNode.zPosition =  2
                // timerNode.position.x = CGFloat(Int(frame.minY) + 950)
                timerNode.position.x = CGFloat(Int(frame.minY) + 400)
                timerNode.position.y = CGFloat(Int(frame.maxX) - 240)
                timerNode.fontColor = SKColor.white
                addChild(timerNode)
                time = 120
                run(SKAction.repeatForever(SKAction.sequence([SKAction.run(countdown),SKAction.wait(forDuration: 1)])))
            } else if gameMode == "survival" {
                // Add level
                if level == 0 {
                    level += 1
                    Utility.shared.setLevel(level: level)
                }
                levelNode.text = String(level)
                levelNode.zPosition =  2
                // levelNode.position.x = CGFloat(Int(frame.minY) + 950)
                // levelNode.position.y = CGFloat(Int(frame.maxX) - 240)
                levelNode.position.x = CGFloat(Int(frame.minY) + 342)
                levelNode.position.y = CGFloat(Int(frame.maxX) - 240)
                levelNode.fontColor = SKColor.white
                addChild(levelNode)
            }
          
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
            createPoint()
            createObstacle()
            
            if !touchControl {
                // Accelerometer control
                motionManager.startAccelerometerUpdates()
            } else {
                // Touch control
                self.addChild(joystick)
                joystick.position = CGPoint(x: -275, y: -110)
                
                self.addChild(knob)
                knob.position = joystick.position
                
                joystick.alpha = 0.4
                knob.alpha = 0.4
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            joystickIsActivated = knob.frame.contains(location) ? true : false
        }
    }
    
    var normalizedPoint = CGPoint()
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            guard joystickIsActivated else { return }
            
            let v = CGVector(dx: location.x - joystick.position.x, dy: location.y - joystick.position.y)
            let angle = atan2(v.dy, v.dx)
            
            let deg = angle * CGFloat(180 / Double.pi)
            
            let length: CGFloat = joystick.frame.size.height / 2
            
            // Revert knob position
            let xDist: CGFloat = sin(angle - 1.57079633) * length
            let yDist: CGFloat = cos(angle - 1.57079633) * length
            
            if joystick.frame.contains(location) {
                knob.position = location
            } else {
                knob.position = CGPoint(x: joystick.position.x - xDist, y: joystick.position.y + yDist)
            }
            
            // Move player
            player.zRotation = angle - 1.57079633
            
            normalizedPoint = CGPoint(x: v.dx/length, y: v.dy/length)
            
            let speed = 5.0
            player.position.x += (normalizedPoint.x * speed)
            player.position.y += (normalizedPoint.y * speed)
            
            player.physicsBody?.velocity = v
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard joystickIsActivated else { return }
        
        let move: SKAction = SKAction.move(to: joystick.position, duration: 0.1)
        move.timingMode = .easeOut
        
        let speed = 5.0
        player.position.x += (normalizedPoint.x * speed)
        player.position.y += (normalizedPoint.y * speed)
        
        knob.run(move)
        
        player.physicsBody?.velocity = CGVector()
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // this method is called when the user touches the screen
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        if tappedNodes.contains(pauseBtn) {
            isPaused = true
            
            pauseBG = SKSpriteNode(imageNamed: "Rectangle.png")
            pauseBG.zPosition = 100
            pauseBG.size = CGSize(width: frame.maxY * 1.2, height: frame.maxX)
            addChild(pauseBG)
            
            //Continue Button
            let imageCon = UIImage(systemName: "play.circle.fill")!.withTintColor(.white)
            let dataCon = imageCon.pngData()!
            let newImageCon = UIImage(data:dataCon)
            let textureCon = SKTexture(image: newImageCon!)
            continueBtn = SKSpriteNode(texture: textureCon,size: CGSize(width: 80, height: 80))
            continueBtn.zPosition = 101
            continueBtn.position.y = 0
            continueBtn.position.x = 0
            
            addChild(continueBtn)
            
            //Home button
            let imageHome = UIImage(systemName: "house.circle.fill")!.withTintColor(.white)
            let dataHome = imageHome.pngData()!
            let newImageHome = UIImage(data:dataHome)
            let textureHome = SKTexture(image: newImageHome!)
            homeBtn = SKSpriteNode(texture: textureHome,size: CGSize(width: 80, height: 80))
            homeBtn.zPosition = 101
            homeBtn.position.y = 0
            homeBtn.position.x = -120

            addChild(homeBtn)

            //restart button
            let imageRes = UIImage(systemName: "arrow.counterclockwise.circle.fill")!.withTintColor(.white)
            let dataRes = imageRes.pngData()!
            let newImageRes = UIImage(data:dataRes)
            let textureRes = SKTexture(image: newImageRes!)
            restartBtn = SKSpriteNode(texture: textureRes,size: CGSize(width: 80, height: 80))
            restartBtn.zPosition = 101
            restartBtn.position.y = 0
            restartBtn.position.x = 120

            addChild(restartBtn)
        }
        
        //if continue button is pressed
        if tappedNodes.contains(continueBtn) {
            print("been here!")
            continueBtn.removeFromParent()
            restartBtn.removeFromParent()
            homeBtn.removeFromParent()
            pauseBG.removeFromParent()
            isPaused = false
          
        //if home button is pressed
        } else if tappedNodes.contains(homeBtn){
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                let scene = StartMenu(fileNamed: "StartMenu")
                scene!.scaleMode = .aspectFill
                let transition = SKTransition.fade(withDuration: 0.5)
                self.view?.presentScene(scene!,transition: transition)
            }
           
        //if restart button is pressed
        } else if tappedNodes.contains(restartBtn){
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                let game = GameScene(fileNamed: "GameScene")
                game!.scaleMode = .aspectFill
                game!.gameMode = self.gameMode
                let transition = SKTransition.fade(withDuration: 0.5)
                self.view?.presentScene(game!,transition: transition)
            }
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
            
            //TODO: feedback when hitting the node
            if let particles = SKEmitterNode(fileNamed: "Blast.sks"){
                particles.position = player.position
                particles.zPosition = 3
                addChild(particles)
                
                //Haptic feedback when hitting a node
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                
            }
            
            //TODO: Sound buat obstacle
            let sound = SKAction.playSoundFileNamed("hitObstacle", waitForCompletion: false)
            run(sound)
            
            if gameMode == "timeattack"{
                time -= 10
            }
            else if gameMode == "survival"{
                endGame()
            }
            
        default:
            print("empty node")
        }

        node.removeFromParent()

    }
    
    func playerHitPoint() {
        
        let sound = SKAction.playSoundFileNamed("hitStar", waitForCompletion: false)
        run(sound)
        
        stageScore += 1
        if let particles = SKEmitterNode(fileNamed: "Spark.sks"){
            particles.position = player.position
            particles.zPosition = 3
            addChild(particles)
        }
        
        // Remove point & children nodes
        for c in children {
            if c.name == "goal" || c.name == "goalPoints" {
                c.removeFromParent()
            }
        }
        
        addCircleObstacle(divider: stagePoint, glow: stageScore, circle_rotation: 0.47)

    }

    func nextStage() {
        
        let sound = SKAction.playSoundFileNamed("nextLevel", waitForCompletion: false)
        run(sound)
        
        // Store score to next stage
        if stageScore == stagePoint {
            if gameMode == "timeattack"{
                score += stageScore
            }
            else if gameMode == "survival"{
                score += stageScore
                level += 1
                Utility.shared.setLevel(level: level)
            }
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
        
        addChild(section)
        
    }
    
    
    func obstacleByDuplicatingPath(_ path: UIBezierPath, clockwise: Bool, divider : Int, glow: Int) -> SKNode {
        let container = SKNode()
        let one_part : Double = 2 / Double(divider) * Double.pi

        var rotationFactor = CGFloat(one_part)
        if !clockwise {
            rotationFactor *= -1
        }

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
        if gameMode == "survival"{
            Utility.shared.restartScore()
            Utility.shared.restartLevel()
        }
        let endGame = EndGame(fileNamed: "EndGame")
        endGame?.scoreVal = score
        endGame?.gameMode = gameMode
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
