//
//  GameScene.swift
//  woosh
//
//  Created by Manuella Valença on 11/03/19.
//  Copyright © 2019 Manuella Valença. All rights reserved.
//  Version 1.0

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // SpriteKit
    var cometNode = SKSpriteNode()
    var destX : CGFloat = 0.0
    let planetBitCategory  : UInt32 = 0b01
    let cometBitCategory : UInt32 = 0b01
    
    var motionManager = CMMotionManager()
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        createSky()
        createComet()
        moveComet()
        createPlanetsTimer()
    }
    
    func createSky(){
        for i in 0...3{
            if let image = UIImage(named: "skyTest-17.png"){
                let skyTexture = SKTexture(image: image)
                let skyNode = SKSpriteNode(texture: skyTexture)
                skyNode.name = "sky"
                skyNode.size = CGSize(width: (self.scene?.size.width)!, height: (self.scene?.size.height)!)
                skyNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                skyNode.position = CGPoint(x: 0, y:  CGFloat(i) * skyNode.size.height)
                self.addChild(skyNode)
            }
        }
    }
    
    func moveSky(){
        self.enumerateChildNodes(withName: "sky") { (node, error) in
            node.position.y -= 2
            if node.position.y < -((self.scene?.size.height)!){
                node.position.y += (self.scene?.size.height)! * 3
            }
        }
    }
    
    func createComet(){
        
            cometNode.position = CGPoint(x: 0, y: -20)
            cometNode.zPosition = 2.0
            if let cometImage = UIImage(named: "wooshComet-12.png"){
                print("Texture created")
                cometNode.texture = SKTexture(image: cometImage)
                cometNode.size = CGSize(width: cometImage.size.width/4, height: cometImage.size.height/4)
                cometNode.physicsBody = SKPhysicsBody(texture: SKTexture(image: cometImage), size: CGSize(width: cometImage.size.width/4, height: cometImage.size.height/4))
                cometNode.physicsBody?.affectedByGravity = false
            }
            
            cometNode.physicsBody?.categoryBitMask = cometBitCategory
            cometNode.physicsBody?.collisionBitMask = planetBitCategory
            //comet.physicsBody?.collisionBitMask = cometBitCategory
            
            self.addChild(cometNode)
            
            if motionManager.isAccelerometerAvailable {
                print("Tem acelerometro")
                
                motionManager.accelerometerUpdateInterval = 0.1
                motionManager.startAccelerometerUpdates(to: OperationQueue.main) { (data, error) in
                    if let accelerometerData = data{
                        let accelerationx = accelerometerData.acceleration.x
                        let currentX = self.cometNode.position.x
                        self.destX =  currentX + CGFloat(accelerationx * 500)
                    }
                }
            }
        
    }
    
    func moveComet(){
//        if motionManager.isAccelerometerAvailable {
//            print("Tem acelerometro")
//
//            motionManager.accelerometerUpdateInterval = 0.1
//            motionManager.startAccelerometerUpdates(to: OperationQueue.main) { (data, error) in
//                if let accelerometerData = data{
//                    let accelerationx = accelerometerData.acceleration.x
//                    let currentX = self.comet?.position.x
//                    self.destX =  currentX! + CGFloat(accelerationx * 500)
//                }
//            }
//        }
    }
    
    func createPlanetNode(){
        
        // Create images for textures
        var bluePlanetImage = UIImage()
        var redPlanetImage = UIImage()
        var greenPlanetImage = UIImage()
        
        if let image = UIImage(named: "planeta1-18.png"){
            bluePlanetImage = image
        }
        if let image = UIImage(named: "planeta2-19.png"){
            redPlanetImage = image
        }
        if let image = UIImage(named: "planeta3-20.png"){
            greenPlanetImage = image
        }
        
        // Random textures
        let arrayPlanetImages = [bluePlanetImage, redPlanetImage, greenPlanetImage]
        let planetRandomTexture = SKTexture(image: arrayPlanetImages.randomElement() ?? bluePlanetImage)
        
        // Random position
        let maxLimit = self.size.width/2 - (bluePlanetImage.size.width)/2
        let minLimit = -(self.size.width/2 + (bluePlanetImage.size.width)/2)
        let randomX = CGFloat.random(in: minLimit ... maxLimit)
        let randomPosition = CGPoint(x: randomX, y:  self.size.height/2 + (bluePlanetImage.size.width)/4)
        
        // Create planet node
        let planet  = SKSpriteNode()
        planet.name = "planet"
        planet.size = CGSize(width: (bluePlanetImage.size.width)/4, height: (bluePlanetImage.size.height)/4)
        planet.position = randomPosition
        planet.zPosition = 2.0
        planet.texture = planetRandomTexture
        
        planet.physicsBody = SKPhysicsBody(texture: planetRandomTexture, size: CGSize(width: (bluePlanetImage.size.width)/4, height: (bluePlanetImage.size.height)/4))
        planet.physicsBody?.categoryBitMask = planetBitCategory
        planet.physicsBody?.collisionBitMask = cometBitCategory
        planet.physicsBody?.contactTestBitMask = planetBitCategory
        //planet.physicsBody?.restitution = 0.75
        
        planet.run(SKAction.fadeIn(withDuration: 2.0))
        self.addChild(planet)
        
        // Move planet
        let action = SKAction.moveTo(y: -self.size.height, duration: 5.5)
        planet.run(action)
    }
    
    func createPlanetsTimer(){
        let wait = SKAction.wait(forDuration: 2, withRange: 3)
        let spawn = SKAction.run {
            self.createPlanetNode()
        }
        
        let sequence = SKAction.sequence([wait, spawn])
        self.run(SKAction.repeatForever(sequence))
    }
    
    func deletePlanets(){
        self.enumerateChildNodes(withName: "planet") { (node, error) in
            if node.position.y < -((self.scene?.size.height)!/2 + node.frame.size.height){
                node.removeFromParent()
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("OA A COLISAO")
        self.view!.window!.rootViewController!.performSegue(withIdentifier: "endGameSegue", sender: self)
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        let action = SKAction.moveTo(x: self.destX, duration: 1)
        self.cometNode.run(action)
        moveSky()
        deletePlanets()
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
