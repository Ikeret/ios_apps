//
//  SecondViewController.swift
//  Numbers
//
//  Created by Сергей Коршунов on 08/07/2019.
//  Copyright © 2019 Sergey Korshunov. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var numOfDice: UILabel!
    @IBOutlet weak var randomNumLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    var randomNum = 0
    var countDice = 1
    
    @IBAction func changeNum(_ sender: Any) {
        countDice = Int(stepper.value)
        numOfDice.text = "Number of Dice: \(countDice)"
    }
    @IBAction func generate(_ sender: Any) {
        randomNum = 0
        
        for _ in 1...countDice {
            randomNum += Int.random(in: 1...6)
        }
                
        randomNumLabel.text = "\(randomNum)"
    }
}

