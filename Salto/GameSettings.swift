//
//  GameSettings.swift
//  Salto
//
//  Created by Rosario Rascuna on 09/11/2015.
//  Copyright (c) 2015 Cirneco. All rights reserved.
//

import SpriteKit


struct LevelData {
    var sea:SeaColors
    var tmxfile:String
    var parallax:(String,String)
    var skyColor:String
}

struct GameSettings {
    
    var levels:[NSDictionary] = []
    
    init() {
        if let path = NSBundle.mainBundle().pathForResource("GameSettings", ofType: "plist") {
            if let content = NSDictionary(contentsOfFile: path) {
                if let object =  content.objectForKey("GameParams")?.objectForKey("Levels") as? [NSDictionary] {
                    levels.appendContentsOf(object)
                }
            }
        }
    }
    
    func seaColors(level:Int) -> SeaColors? {
        if  let top = levels[level].objectForKey("seaTop") as? String,
            let middle = levels[level].objectForKey("seaMiddle") as? String,
            let bottom = levels[level].objectForKey("seaBottom") as? String {
                return SeaColors(top:top, middle:middle, bottom: bottom)
        } else {
            return nil
        }
    }
    
    func backgroundColor(level:Int) -> String? {
        return levels[level].objectForKey("background") as? String
    }
    func tmxfile(level:Int) -> String? {
        return levels[level].objectForKey("tmxfile") as? String
    }
    func skyColor(level:Int) -> String? {
        return levels[level].objectForKey("sky") as? String
    }
    
    func parallaxSlowFast(level:Int) -> (slow:String, fast:String)? {
        if let slow = levels[level].objectForKey("parallaxslow") as? String,
            let fast = levels[level].objectForKey("parallaxfast") as? String {
                return (slow, fast)
        } else {
            return nil
        }
    }
    
    func levelData(level:Int) -> LevelData? {
        if let parallax = parallaxSlowFast(level),
               sea = seaColors(level),
               tmxfile = tmxfile(level),
               sky = skyColor(level){
                return LevelData(sea:sea, tmxfile: tmxfile, parallax: parallax, skyColor: sky)
        } else {
            return nil
        }
    }

}
