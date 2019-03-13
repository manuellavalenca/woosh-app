//
//  GameScene.swift
//  woosh
//
//  Created by Manuella Valença on 11/03/19.
//  Copyright © 2019 Manuella Valença. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {
    
    var comet : SKSpriteNode?
    var motionManager = CMMotionManager()
    var destX : CGFloat = 0.0
    
    override func didMove(to view: SKView) {

        self.comet = self.childNode(withName: "woosh") as? SKSpriteNode
        if let comet = self.comet {
            comet.alpha = 0.0
            comet.run(SKAction.fadeIn(withDuration: 2.0))
            if let cometImage = UIImage(named: "wooshComet-12.png"){
                comet.texture = SKTexture(image: cometImage)
            }
        }
        
        if motionManager.isAccelerometerAvailable {
            print("Tem acelerometro")
            
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates(to: OperationQueue.main) { (data, error) in
                if let accelerometerData = data{
                    let accelerationx = accelerometerData.acceleration.x
                    //let accelerationy = accelerometerData.acceleration.y
                    let currentX = self.comet?.position.x
                    self.destX =  currentX! + CGFloat(accelerationx * 500)
//                    self.physicsWorld.gravity = CGVector(CGFloat(accelerationx) * 10, CGFloat(accelerationy) * 10)
                }
            }
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        let action = SKAction.moveTo(x: self.destX, duration: 1)
        self.comet?.run(action)
    }

    
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
}
