//
//  GameViewController.swift
//  Salto
//
//  Created by Rosario Rascuna on 16/11/2015.
//  Copyright (c) 2015 Cirneco. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure the view.
        let skView = self.view as! SKView
    
        skView.showsFPS = true
        skView.showsNodeCount = true
        if #available(iOS 8.0, *) {
            skView.showsPhysics = true
        } else {
            // Fallback on earlier versions
        }
    
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        let scene = GameScene()
        scene.scaleMode = SKSceneScaleMode.ResizeFill
        scene.size = skView.bounds.size
    
        if scene.size.width < 480 {
            scene.size.width = 480

        } else if scene.size.height < 320 {
            scene.size.height = 320
        }
        skView.presentScene(scene)
    }


    override func shouldAutorotate() -> Bool {
        return true
    }
    
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
