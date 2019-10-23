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
        icons_dice = [leftDice, centralDice, rightDice]
    }

    @IBOutlet weak var numOfDice: UILabel!
    @IBOutlet weak var randomNumLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var leftDice: UIImageView!
    @IBOutlet weak var centralDice: UIImageView!
    @IBOutlet weak var rightDice: UIImageView!
    
    let all_dice = [ #imageLiteral(resourceName: "dice_1"),#imageLiteral(resourceName: "dice_2"),#imageLiteral(resourceName: "dice_3"),#imageLiteral(resourceName: "dice_4"),#imageLiteral(resourceName: "dice_5"),#imageLiteral(resourceName: "dice_6") ]
    var icons_dice : [UIImageView]?
    
    var randomNum = 0
    var countDice = 1
    
    @IBAction func changeNum(_ sender: Any) {
        countDice = Int(stepper.value)
        numOfDice.text = "Number of Dice: \(countDice)"
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            generate(0)
        }
    }
    
    @IBAction func generate(_ sender: Any) {
        if !launchedBefore {
            let alert = UIAlertController(title: "You can shake your iPhone instead of pushing button.", message: nil, preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            launchedBefore = true
        }
        randomNum = 0
        hide_dice()
        for i in 0..<countDice {
            let randomValue = Int.random(in: 1...6)
            randomNum += randomValue
            
            if countDice <= 3 {
                icons_dice![i].image = all_dice[randomValue-1]
                icons_dice![i].isHidden = false
                stackView.isHidden = false
            }
        }
        randomNumLabel.text = "\(randomNum)"
    }
    
    func hide_dice() {
        stackView.isHidden = true
        for img in icons_dice! {
            img.isHidden = true
        }
    }
}

