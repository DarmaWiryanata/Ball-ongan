//
//  GameCenterHelper.swift
//  Ball-ongan
//
//  Created by Darma Wiryanata on 23/08/22.
//

import Foundation
import GameKit

let singleton = GameKitHelper()

class GameKitHelper: NSObject, GKGameCenterControllerDelegate {
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    static let PresentAuthenticationViewController = "PresentAuthenticationViewController"
    
    var authenticationViewController: UIViewController?
    var lastError: NSError?
    
    var gameCenterEnabled: Bool
    
    override init() { gameCenterEnabled = true
        super.init()
    }
    
    func resetAchievements() {
        if GKLocalPlayer.local.isAuthenticated {
            
            let localPlayer = GKLocalPlayer.local
            
            if localPlayer.isAuthenticated {
                
                GKAchievement.resetAchievements(completionHandler: {(error : Error?) -> Void in
                    if error != nil {
                        print("error")
                    }
                    else {
                        print("Achievements Reset?")
                    }
                })
            }
            
        }
    }
    
    func authenticateLocalPlayer (view: SKView) {
        print("authenticating!")
        let localPlayer = GKLocalPlayer.local
        
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            
            if (viewController != nil) {
                let vc: UIViewController = view.window!.rootViewController!
                vc.present(viewController!, animated: true, completion: nil)
            }
            else if localPlayer.isAuthenticated {
                self.gameCenterEnabled = true
                print((GKLocalPlayer.local.isAuthenticated))
            } else {
                self.gameCenterEnabled = false
                print("User not authenticated")
            }
        }
    }
    
    func showLeader(view: UIViewController) {
        
        if GKLocalPlayer.local.isAuthenticated {
            
            let localPlayer = GKLocalPlayer.local
            
            if localPlayer.isAuthenticated {
                
                let vc = view
                let gc = GKGameCenterViewController()
                gc.gameCenterDelegate = self
                vc.present(gc, animated: true, completion: nil)
                
            }
        }
    }
    
    func reportAchievements(achievements: [GKAchievement]) {
        
        if !gameCenterEnabled {
            print("Local player is not authenticated")
            return
        }
        GKAchievement.report(achievements, withCompletionHandler: {(error : Error?) -> Void in
            if error != nil {
                print("error")
            }
            else {
                print("acheivements reported")
            }
        })
        
    }
    
    class var sharedInstance: GameKitHelper { return singleton }
}
