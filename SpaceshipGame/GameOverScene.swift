//
//  GameOverScene.swift
//  SpaceshipGame
//
//  Created by Romina Pozzuto on 29/01/2021.
//

import UIKit
import SpriteKit

class GameOverScene: SKScene {
    
    override init(size: CGSize) {
        super.init(size: size)
        self.backgroundColor = SKColor.black

        let message = "Game over"
        let label = SKLabelNode(fontNamed: "Helvetica-Bold")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.red
        label.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(label)
        
        //4
        let replayMessage = "Volver a jugar"
        let replayButton = SKLabelNode(fontNamed: "Helvetica-Bold")
        replayButton.text = replayMessage
        replayButton.fontColor = SKColor.white
        replayButton.position = CGPoint(x: self.size.width/2, y: 50)
        replayButton.name = "replay"
        self.addChild(replayButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            if node.name == "replay" {
                let reveal : SKTransition = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = GameScene(size: self.view!.bounds.size)
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: reveal)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
