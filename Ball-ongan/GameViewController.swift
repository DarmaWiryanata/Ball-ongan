//
//  GameViewController.swift
//  Ball-ongan
//
//  Created by Darma Wiryanata on 10/05/22.
//

import UIKit
import SpriteKit
import GameplayKit
import GameKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let scene = GameScene(size: CGSize(width: 1536, height: 2048))
//        let skView = self.view as! SKView
//        skView.showsFPS = true
//        skView.showsNodeCount = true
//        skView.ignoresSiblingOrder = true
//        scene.scaleMode = .aspectFill
//        skView.presentScene(scene)
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "StartMenu") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill

                // Present the scene
                view.presentScene(scene)
                
                if #available(iOS 14.0, *) {
                    GKAccessPoint.shared.location = .topLeading
                    GKAccessPoint.shared.showHighlights = true
                    GKAccessPoint.shared.isActive = true
                }
            }
          
            view.ignoresSiblingOrder = true

            view.showsFPS = false
            view.showsNodeCount = false
        }
        
        // MARK: Game Center integration
        GameKitHelper.sharedInstance.authenticateLocalPlayer(view: self.view as! SKView)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
