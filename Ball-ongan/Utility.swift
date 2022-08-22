//
//  GameMode.swift
//  Ball-ongan
//
//  Created by Muhammad Aleandro on 18/08/22.
//

import Foundation

class Utility{
    static let shared = Utility()
    
    func setLevel( level: Int) -> Void{
        let currentLevel = level
        let level  = UserDefaults.standard.integer(forKey: "level")

        if(currentLevel > level){
            UserDefaults.standard.set(currentLevel, forKey: "level")
            
        }
    }
    func restartLevel() -> Void{
        UserDefaults.standard.set(1, forKey: "level")
    }
    func getLevel() -> Int{
        return UserDefaults.standard.integer(forKey: "level")
    }
    func setScore( score: Int) -> Void{
        UserDefaults.standard.set(score, forKey: "survivalScore")
    }
    func getScore() -> Int{
        return UserDefaults.standard.integer(forKey: "survivalScore")
    }
    func restartScore() -> Void{
        UserDefaults.standard.set(0, forKey: "survivalScore")
    }
    func setControl( control: Bool ) -> Void{
        UserDefaults.standard.set(control, forKey: "control")
    }
    func getControl() -> Bool{
        return UserDefaults.standard.bool(forKey: "control")
    }
}
