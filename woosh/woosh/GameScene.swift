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
    //var sky : SKSpriteNode?
    var motionManager = CMMotionManager()
    var destX : CGFloat = 0.0
    
    override func didMove(to view: SKView) {
        createSky()
        createComet()
        moveComet()
        createPlanets()
        
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
        self.comet = self.childNode(withName: "woosh") as? SKSpriteNode
        if let comet = self.comet {
            comet.alpha = 0.0
            comet.zPosition = 2.0
            comet.run(SKAction.fadeIn(withDuration: 2.0))
            if let cometImage = UIImage(named: "wooshComet-12.png"){
                comet.texture = SKTexture(image: cometImage)
            }
        }
    }
    
    func moveComet(){
        if motionManager.isAccelerometerAvailable {
            print("Tem acelerometro")
            
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates(to: OperationQueue.main) { (data, error) in
                if let accelerometerData = data{
                    let accelerationx = accelerometerData.acceleration.x
                    let currentX = self.comet?.position.x
                    self.destX =  currentX! + CGFloat(accelerationx * 500)
                }
            }
        }
    }
    
    func createPlanets(){
        
//        Primeira ideia: distancia entre planetas
//        let randomDistanceHeight = 0.0
//        let randomDistanceWidth = 0.0
        
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
        let maxLimit = self.size.width/2 - (bluePlanetImage.size.width)/4
        let minLimit = -(self.size.width/2 + (bluePlanetImage.size.width)/4)
        let randomX = CGFloat.random(in: minLimit ... maxLimit)
        let randomPosition = CGPoint(x: randomX, y:  5)
        
        // Create planet node
        let planet  = SKSpriteNode(texture: planetRandomTexture)
        planet.name = "planet"
        planet.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        planet.size = CGSize(width: (bluePlanetImage.size.width)/4, height: (bluePlanetImage.size.height)/4)
        planet.position = randomPosition
        planet.zPosition = 2.0
        planet.run(SKAction.fadeIn(withDuration: 2.0))
        self.addChild(planet)

    }
    
    override func update(_ currentTime: TimeInterval) {
        let action = SKAction.moveTo(x: self.destX, duration: 1)
        self.comet?.run(action)
        moveSky()
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
