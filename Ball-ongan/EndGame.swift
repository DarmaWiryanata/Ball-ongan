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
    private var background = SKSpriteNode(imageNamed: "background")
    private var score = SKLabelNode(fontNamed: "IM FELL DW Pica SC")
    private var highScore = SKLabelNode(fontNamed: "IM FELL DW Pica SC")
    private var text = SKLabelNode(fontNamed: "IM FELL DW Pica SC")
    private var playAgain = SKLabelNode(fontNamed: "IM FELL DW Pica SC")
    var scoreVal : Int?
    override func didMove(to view: SKView) {
        
        background.zPosition = -1
        background.size = CGSize(width: frame.maxY * 1.2, height: frame.maxX)
        addChild(background)
        
        startButton.zPosition = 0
        startButton.position.y = -10
        startButton.size = CGSize(width: 100, height: 100)
        addChild(startButton)
        
        
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
        
        playAgain.position.y = -100
        playAgain.fontSize = 20
        playAgain.text = "PLAY AGAIN"
        addChild(playAgain)
        
        
        
        
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
            
            if location.y < 50 && location.y > -50 && location.x < 50 && location.x > -50 {
                
                text.text = "loading..."
                text.fontColor = SKColor.white
                text.position.x = CGFloat(0)
                text.position.y = CGFloat(-100)
                text.zPosition = 120
                addChild(text)
                
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    let game = GameScene(fileNamed: "GameScene")
                    game!.scaleMode = .aspectFill
                    let transition = SKTransition.fade(withDuration: 0.5)
                    self.view?.presentScene(game!,transition: transition)
                }
                
            }
            
        }
    }
    
}
