//
//  StartMenu.swift
//  Ball-ongan
//
//  Created by Muhammad Aleandro on 20/05/22.
//

import SpriteKit
import GameplayKit
import CoreMotion

class StartMenu: SKScene, SKPhysicsContactDelegate {
    private var timeAttack = SKSpriteNode(imageNamed: "timeattack")
    private var taText = SKLabelNode(fontNamed: "IM FELL DW Pica SC")
    private var survival = SKSpriteNode(imageNamed: "survival")
    private var svText = SKLabelNode(fontNamed: "IM FELL DW Pica SC")
    private var background = SKSpriteNode(imageNamed: "background")
    private var title = SKSpriteNode(imageNamed: "Title")
    private var loading = SKLabelNode(fontNamed: "IM FELL DW Pica SC")
    private var gameMode: String?
    override func didMove(to view: SKView) {
        
        background.zPosition = -1
        background.size = CGSize(width: frame.maxY * 1.2, height: frame.maxX)
        addChild(background)
        
        timeAttack.zPosition = 0
        timeAttack.position.x = 85
        timeAttack.size = CGSize(width: 100, height: 100)
        addChild(timeAttack)
        taText.text = "time attack"
        taText.fontSize = 24
        taText.zPosition = 0
        taText.position.x = 85
        taText.position.y = -85
        addChild(taText)
        
        survival.zPosition = 0
        survival.position.x = -85
        survival.size = CGSize(width: 100, height: 100)
        addChild(survival)
        svText.text = "survival"
        svText.fontSize = 24
        svText.zPosition = 0
        svText.position.x = -85
        svText.position.y = -85
        addChild(svText)
        
        title.position.y = 100
        title.size = CGSize(width: 195,height: 39)
        addChild(title)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            let location = touch.location(in: self)
            
            if location.y < 50 && location.y > -50 && location.x < 135 && location.x > 35 {
                playGame(mode: "timeattack")
            }
            
            if location.y < 50 && location.y > -50 && location.x > -135 && location.x < -35 {
                playGame(mode: "survival")
            }
            
        }
    }
    func playGame( mode: String ){
        loading.text = "loading..."
        loading.fontColor = SKColor.white
        loading.position.x = CGFloat(0)
        loading.position.y = CGFloat(-100)
        loading.zPosition = 120
        addChild(loading)
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            let game = GameScene(fileNamed: "GameScene")
            game!.scaleMode = .aspectFill
            game!.gameMode = mode
            let transition = SKTransition.fade(withDuration: 0.3)
            self.view?.presentScene(game!,transition: transition)
        }
    }
}
