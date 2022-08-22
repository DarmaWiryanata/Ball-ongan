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
    override func didMove(to view: SKView) {
        
        background.zPosition = -1
        background.size = CGSize(width: frame.maxY * 1.2, height: frame.maxX)
        addChild(background)
        
        gyroscope.zPosition = 0
        gyroscope.position.y = -10
        gyroscope.position.x = 85
        gyroscope.size = CGSize(width: 100, height: 100)
        addChild(gyroscope)
        
        virtualpad.zPosition = 0
        virtualpad.position.y = -10
        virtualpad.position.x = -85
        virtualpad.size = CGSize(width: 100, height: 100)
        addChild(virtualpad)
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
