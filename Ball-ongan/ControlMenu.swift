//
//  ControlMenu.swift
//  Ball-ongan
//
//  Created by Muhammad Aleandro on 22/08/22.
//

import SpriteKit
import GameplayKit
import CoreMotion

class ControlMenu: SKScene, SKPhysicsContactDelegate {
    private var background = SKSpriteNode(imageNamed: "background")
    private var gyroscope = SKSpriteNode(imageNamed: "gyroscope")
    private var virtualpad = SKSpriteNode(imageNamed: "virtualpad")
    private var loading = SKLabelNode(fontNamed: "IM FELL DW Pica SC")
    private var gText = SKLabelNode(fontNamed: "IM FELL DW Pica SC")
    private var vText = SKLabelNode(fontNamed: "IM FELL DW Pica SC")
    private var title = SKLabelNode(fontNamed: "IM FELL DW Pica SC")
    override func didMove(to view: SKView) {
        
        background.zPosition = -1
        background.size = CGSize(width: frame.maxY * 1.2, height: frame.maxX)
        addChild(background)
        
        gyroscope.zPosition = 0
        gyroscope.position.y = -10
        gyroscope.position.x = 85
        gyroscope.size = CGSize(width: 100, height: 100)
        addChild(gyroscope)
        
        gText.text = "gyroscope"
        gText.fontSize = 24
        gText.zPosition = 0
        gText.position.x = 85
        gText.position.y = -85
        addChild(gText)
        
        virtualpad.zPosition = 0
        virtualpad.position.y = -10
        virtualpad.position.x = -85
        virtualpad.size = CGSize(width: 100, height: 100)
        addChild(virtualpad)
        
        vText.text = "virtual pad"
        vText.fontSize = 24
        vText.zPosition = 0
        vText.position.x = -85
        vText.position.y = -85
        addChild(vText)
        
        title.text = "control configuration"
        title.fontSize = 48
        title.zPosition = 0
        title.position.y = 100
        addChild(title)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            let gyroscope = touch.location(in: self.gyroscope)
            let virtual = touch.location(in: self.virtualpad)
            
            if gyroscope.y < 50 && gyroscope.y > -50 && gyroscope.x < 50 && gyroscope.x > -50 {
                Utility.shared.setControl(control: false)
                submit()
            }
            if virtual.y < 50 && virtual.y > -50 && virtual.x < 50 && virtual.x > -50 {
                Utility.shared.setControl(control: true)
                submit()
            }
            
        }
    }
    func submit(){
        loading.text = "loading..."
        loading.fontColor = SKColor.white
        loading.position.x = CGFloat(0)
        loading.position.y = CGFloat(-120)
        loading.zPosition = 120
        addChild(loading)
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            let game = StartMenu(fileNamed: "StartMenu")
            game!.scaleMode = .aspectFill
            let transition = SKTransition.fade(withDuration: 0.3)
            self.view?.presentScene(game!,transition: transition)
        }
    }
}
