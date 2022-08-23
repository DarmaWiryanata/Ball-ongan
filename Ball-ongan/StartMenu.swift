//
//  StartMenu.swift
//  Ball-ongan
//
//  Created by Muhammad Aleandro on 20/05/22.
//

import SpriteKit
import GameplayKit
import GameKit
import CoreMotion

class StartMenu: SKScene, SKPhysicsContactDelegate {
    private var timeAttack = SKSpriteNode(imageNamed: "timeattack")
    private var control = SKSpriteNode(imageNamed: "control")
    private var taText = SKLabelNode(fontNamed: "IM FELL DW Pica SC")
    private var survival = SKSpriteNode(imageNamed: "survival")
    private var svText = SKLabelNode(fontNamed: "IM FELL DW Pica SC")
    private var background = SKSpriteNode(imageNamed: "background")
    private var title = SKLabelNode(fontNamed: "IM FELL DW Pica SC")
    private var loading = SKLabelNode(fontNamed: "IM FELL DW Pica SC")
    private var gameMode: String?
    override func didMove(to view: SKView) {
        
        background.zPosition = -1
        background.size = CGSize(width: frame.maxY * 1.2, height: frame.maxX)
        addChild(background)
        
        control.zPosition = 1
        control.position.x = frame.maxY/2
        control.position.y = (frame.maxX/(-2))+50
        control.size = CGSize(width: 45, height: 45)
        addChild(control)
        
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
        
        title.text = "Ball-ongan"
        title.fontSize = 48
        title.zPosition = 0
        title.position.y = 100
        addChild(title)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            let timeAttack = touch.location(in: self.timeAttack)
            let survival = touch.location(in: self.survival)
            let control = touch.location(in: self.control)
            if timeAttack.y < 50 && timeAttack.y > -50 && timeAttack.x < 50 && timeAttack.x > -50 {
                playGame(mode: "timeattack")
                let sound = SKAction.playSoundFileNamed("pickMode", waitForCompletion: false)
                run(sound)
            }
            if survival.y < 50 && survival.y > -50 && survival.x > -50 && survival.x < 50 {
                playGame(mode: "survival")
                let sound = SKAction.playSoundFileNamed("pickMode", waitForCompletion: false)
                run(sound)
            }
            if control.y < 25 && control.y > -25 && control.x > -25 && control.x < 25{
                changeControl()
            }
            
        }
    }
    func playGame( mode: String ){
        loading.text = "loading..."
        loading.fontColor = SKColor.white
        loading.position.x = CGFloat(0)
        loading.position.y = CGFloat(-120)
        loading.zPosition = 120
        addChild(loading)
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            let game = GameScene(fileNamed: "GameScene")
            game!.scaleMode = .aspectFill
            game!.gameMode = mode
            let transition = SKTransition.fade(withDuration: 0.3)
            self.view?.presentScene(game!,transition: transition)
            
            if #available(iOS 14.0, *) {
                GKAccessPoint.shared.isActive = false
            }
        }
    }
    func changeControl(){
        loading.text = "loading..."
        loading.fontColor = SKColor.white
        loading.position.x = CGFloat(0)
        loading.position.y = CGFloat(-120)
        loading.zPosition = 120
        addChild(loading)
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            let game = ControlMenu(fileNamed: "ControlMenu")
            game!.scaleMode = .aspectFill
            let transition = SKTransition.fade(withDuration: 0.3)
            self.view?.presentScene(game!,transition: transition)
        }
    }
}
