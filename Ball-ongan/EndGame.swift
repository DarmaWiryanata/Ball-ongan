//
//  EndGame.swift
//  Ball-ongan
//
//  Created by Muhammad Aleandro on 21/05/22.
//

import SpriteKit
import GameplayKit
import CoreMotion

class EndGame: SKScene, SKPhysicsContactDelegate {
    private var startButton = SKSpriteNode(imageNamed: "Start")
    private var homeButton = SKSpriteNode(imageNamed: "home")
    private var background = SKSpriteNode(imageNamed: "background")
    private var score = SKLabelNode(fontNamed: "IM FELL DW Pica SC")
    private var highScore = SKLabelNode(fontNamed: "IM FELL DW Pica SC")
    private var level = SKLabelNode(fontNamed: "IM FELL DW Pica SC")
    private var highLevel = SKLabelNode(fontNamed: "IM FELL DW Pica SC")
    private var text = SKLabelNode(fontNamed: "IM FELL DW Pica SC")
    private var playAgain = SKLabelNode(fontNamed: "IM FELL DW Pica SC")
    private var home = SKLabelNode(fontNamed: "IM FELL DW Pica SC")
    private var modeText = SKLabelNode(fontNamed: "IM FELL DW Pica SC")
    var levelVal : Int?
    var scoreVal : Int?
    var gameMode : String?
    override func didMove(to view: SKView) {
        
        background.zPosition = -1
        background.size = CGSize(width: frame.maxY * 1.2, height: frame.maxX)
        addChild(background)
        
        startButton.zPosition = 0
        startButton.position.y = -10
        startButton.position.x = 85
        startButton.size = CGSize(width: 100, height: 100)
        addChild(startButton)
        
        homeButton.zPosition = 0
        homeButton.position.y = -10
        homeButton.position.x = -85
        homeButton.size = CGSize(width: 100, height: 100)
        addChild(homeButton)
        
        if gameMode == "timeattack"{
            let highScoreVal  = highScore(score: scoreVal!)
            highScore.position.y = 67
            highScore.fontSize = 18
            highScore.text = "high Score : \(highScoreVal) pts"
            addChild(highScore)
            
            
            score.position.y = 100
            score.fontSize = 40
            let scoreText : String = String(scoreVal!)
            score.text = "your score : \(scoreText) pts"
            addChild(score)
        }else if gameMode == "survival"{
            Utility.shared.setHighLevel(level: levelVal!)
            let highLevelVal = Utility.shared.getHighLevel()
            highLevel.position.y = 67
            highLevel.fontSize = 18
            highLevel.text = "high level : \(highLevelVal)"
            addChild(highLevel)
            
            
            level.position.y = 100
            level.fontSize = 40
            let levelText : String = String(levelVal!)
            level.text = "your latest level : \(levelText)"
            addChild(level)
        }
        
        
        playAgain.position.y = -100
        playAgain.position.x = 85
        playAgain.fontSize = 20
        playAgain.text = "PLAY AGAIN"
        addChild(playAgain)
        
        home.position.y = -100
        home.position.x = -85
        home.fontSize = 20
        home.text = "MAIN MENU"
        addChild(home)
        
        modeText.position.y = -140
        modeText.fontSize = 20
        let gametext: String = String(gameMode!)
        modeText.text = gametext
        addChild(modeText)
        
        
        
        
    }
    
    func highScore( score: Int) -> Int{
        let currentScore = score
        let highScore  = UserDefaults.standard.integer(forKey: "highScore")

        if(currentScore > highScore){
            UserDefaults.standard.set(currentScore, forKey: "highScore")
            
        }
        let gethighScoreNow  = UserDefaults.standard.integer(forKey: "highScore")
        
        return gethighScoreNow
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            let location = touch.location(in: self)
            
            if location.y < 50 && location.y > -50 && location.x > -135 && location.x < -35 {
                text.text = "loading..."
                text.fontColor = SKColor.white
                text.position.x = CGFloat(0)
                text.position.y = CGFloat(-160)
                addChild(text)
                
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    let scene = StartMenu(fileNamed: "StartMenu")
                    scene!.scaleMode = .aspectFill
                    let transition = SKTransition.fade(withDuration: 0.5)
                    self.view?.presentScene(scene!,transition: transition)
                }
            }
            
            if location.y < 50 && location.y > -50 && location.x < 135 && location.x > 35 {
                text.text = "loading..."
                text.fontColor = SKColor.white
                text.position.x = CGFloat(0)
                text.position.y = CGFloat(-160)
                addChild(text)
                
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    let game = GameScene(fileNamed: "GameScene")
                    game!.scaleMode = .aspectFill
                    game!.gameMode = self.gameMode
                    let transition = SKTransition.fade(withDuration: 0.5)
                    self.view?.presentScene(game!,transition: transition)
                }
            }
            
        }
    }
}
