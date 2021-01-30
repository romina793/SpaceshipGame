//
//  GameScene.swift
//  SpaceshipGame
//
//  Created by Romina Pozzuto on 29/01/2021.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var ship = SKSpriteNode()
    var actionMoveUp = SKAction()
    var actionMoveDown = SKAction()
    let shipCategory = 0x1 << 1
    let obstacleCategory = 0x1 << 2
    let backgroundVelocity : CGFloat = 3.0
    let missileVelocity : CGFloat = 5.0
    var lastMissileAdded:TimeInterval = 0

    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.white
        self.initializingScrollingBackground()
        self.addShip()
        self.addMissile()

        // Making self delegate of physics world
        self.physicsWorld.gravity = (CGVector(dx: 0, dy: 0))
        self.physicsWorld.contactDelegate = self

    }
    
    func addShip() {
        // Initializing spaceship node
        ship = SKSpriteNode(imageNamed: "spaceship")
        ship.setScale(0.5)

        // Adding SpriteKit physics body for collision detection
        ship.physicsBody = SKPhysicsBody(rectangleOf: ship.size)
        ship.physicsBody?.categoryBitMask = UInt32(shipCategory)
        ship.physicsBody?.isDynamic = true
        ship.physicsBody?.contactTestBitMask = UInt32(obstacleCategory)
        ship.physicsBody?.collisionBitMask = 0
        ship.name = "ship"
        ship.position = CGPoint(x: 120, y: 120)

        self.addChild(ship)

        actionMoveUp = SKAction.moveBy(x: 30, y: 0, duration: 0.2)
        actionMoveDown = SKAction.moveBy(x: -30, y: 0, duration: 0.2)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            if location.x > ship.position.x {
                if ship.position.x < 300 {
                    ship.run(actionMoveUp)
                }
            } else {
                if ship.position.x > 50 {
                    ship.run(actionMoveDown) 
                }
            }
        }
    }
    
    func initializingScrollingBackground() {
        for index in 0...2 {
            let bg = SKSpriteNode(imageNamed: "bg")
            bg.position = CGPoint(x: 0, y: index * Int(bg.size.height))
            bg.anchorPoint = .zero
            bg.name = "background"
            self.addChild(bg)
        }
    }
    
    func moveBackground() {
        self.enumerateChildNodes(withName: "background", using: { (node, stop) -> Void in
            if let bg = node as? SKSpriteNode {
                bg.position = CGPoint(x: bg.position.x, y: bg.position.y - self.backgroundVelocity)

                // Checks if bg node is completely scrolled off the screen, if yes, then puts it at the end of the other node.
                if bg.position.y <= -bg.size.height {
                    bg.position = CGPoint(x: bg.position.x , y: bg.position.y + bg.size.height * 2)
                }
            }
        })
    }
    
    override func update(_ currentTime: TimeInterval) {
        if currentTime - self.lastMissileAdded > 1 {
            self.lastMissileAdded = currentTime + 1
            self.addMissile()
        }
        self.moveBackground()
        self.moveObstacle()
    }
    
    func addMissile() {
        // Initializing spaceship node
        let missile = SKSpriteNode(imageNamed: "red-missile")
        missile.setScale(0.15)
        missile.zRotation = CGFloat(Double.pi/2)

        // Adding SpriteKit physics body for collision detection
        missile.physicsBody = SKPhysicsBody(rectangleOf: missile.size)
        missile.physicsBody?.categoryBitMask = UInt32(obstacleCategory)
        missile.physicsBody?.isDynamic = true
        missile.physicsBody?.contactTestBitMask = UInt32(shipCategory)
        missile.physicsBody?.collisionBitMask = 0
        missile.physicsBody?.usesPreciseCollisionDetection = true
        missile.name = "missile"

        // Selecting random y position for missile
        let random : CGFloat = CGFloat(arc4random_uniform(300))
        missile.position = CGPoint(x: random, y: self.frame.size.height + 20)
        self.addChild(missile)
    }
    
    func moveObstacle() {
        self.enumerateChildNodes(withName: "missile", using: { (node, stop) -> Void in
            if let obstacle = node as? SKSpriteNode {
                obstacle.position = CGPoint(x: obstacle.position.x , y: obstacle.position.y - self.missileVelocity)
                if obstacle.position.y < 0 {
                    obstacle.removeFromParent()
                }
            }
        })
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()

        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.categoryBitMask & UInt32(shipCategory)) != 0 && (secondBody.categoryBitMask & UInt32(obstacleCategory)) != 0 {
            ship.removeFromParent()
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let scene = GameOverScene(size: self.size)
            self.view?.presentScene(scene, transition: reveal)
        }
    }

}
