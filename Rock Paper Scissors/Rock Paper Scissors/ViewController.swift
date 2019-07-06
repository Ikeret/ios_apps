//
//  ViewController.swift
//  Rock Paper Scissors
//
//  Created by Сергей Коршунов on 06/07/2019.
//  Copyright © 2019 Sergey Korshunov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    let arms : [String] = ["✊🏼", "🤚🏼", "✌🏼"]
    @IBOutlet weak var top_label: UILabel!
    @IBOutlet weak var new_game: UIButton!
    
    @IBOutlet weak var first_arm: UIButton!
    @IBOutlet weak var second_arm: UIButton!
    @IBOutlet weak var third_arm: UIButton!
    
    @IBOutlet weak var human_face: UILabel!
    @IBOutlet weak var robot_face: UILabel!
    
    @IBOutlet weak var score: UILabel!
    var user_score = 0
    var computer_score = 0
    
    var user_choose : String?
    var computer_choose : String?
    
    @IBAction func rock_button(_ sender: UIButton) {
        user_choosed(value: 0)
    }
    @IBAction func paper_button(_ sender: UIButton) {
        user_choosed(value: 1)
    }
    @IBAction func scissors_button(_ sender: UIButton) {
        user_choosed(value: 2)
    }
    
    func user_choosed(value : Int) {
        user_choose = arms[value]
        let randomInt = Int.random(in: 0..<3)
        computer_choose = arms[randomInt]
        
        first_arm.setTitle(user_choose, for: .normal)
        third_arm.setTitle(computer_choose, for: .normal)
        
        human_face.isHidden = false
        robot_face.isHidden = false
        new_game.isHidden = false
        
        if user_choose == computer_choose {
            top_label.text = "Draw!"
            second_arm.setTitle("=", for: .normal)
        }
        else if is_user_won() {
            second_arm.setTitle(">", for: .normal)
            second_arm.setTitleColor(.green, for: .normal)
            
            top_label.text = "You won!"
            top_label.textColor = .green
            
            user_score += 1
        }
        else {
            second_arm.setTitle("<", for: .normal)
            second_arm.setTitleColor(.red, for: .normal)
            
            top_label.text = "You lose!"
            top_label.textColor = .red
            
            computer_score += 1
        }
        
        score.text = "\(user_score) : \(computer_score)"
        score.isHidden = false
        
        first_arm.isEnabled = false
        second_arm.isEnabled = false
        third_arm.isEnabled = false
    }
    
    func is_user_won() -> Bool {
        switch user_choose {
        case "✊🏼":
            if computer_choose == "✌🏼" {
                return true
            }
        case "🤚🏼":
            if computer_choose == "✊🏼" {
                return true
            }
        case "✌🏼":
            if computer_choose == "🤚🏼" {
                return true
            }
        default: break
        }
        return false
    }
    
    @IBAction func new_game_button(_ sender: UIButton) {
        top_label.text = "Choose one"
        top_label.textColor = .black
        
        human_face.isHidden = true
        robot_face.isHidden = true
        
        first_arm.setTitle("✊🏼", for: .normal)
        second_arm.setTitle("🤚🏼", for: .normal)
        second_arm.setTitleColor(.black, for: .normal)
        third_arm.setTitle("✌🏼", for: .normal)
    
        first_arm.isEnabled = true
        second_arm.isEnabled = true
        third_arm.isEnabled = true
        
        new_game.isHidden = true
    }
}

