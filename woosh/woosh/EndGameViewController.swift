//
//  EndGameViewController.swift
//  woosh
//
//  Created by Manuella Valença on 15/03/19.
//  Copyright © 2019 Manuella Valença. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import GameplayKit

class EndGameViewController: UIViewController {
    
    @IBOutlet weak var newGameButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func newGamePressed(_ sender: Any) {
        performSegue(withIdentifier: "newGameSegue", sender: self)
    }
    
    
}
