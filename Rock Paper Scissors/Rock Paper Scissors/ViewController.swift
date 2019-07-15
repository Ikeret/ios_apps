//
//  ViewController.swift
//  Rock Paper Scissors
//
//  Created by Сергей Коршунов on 06/07/2019.
//  Copyright © 2019 Sergey Korshunov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var difficult: Int?
    var previous_user_choice = ""
    var count_identical_choices = 0
    
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
    
    var user_choice : String?
    var computer_choice : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
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
        user_choice = arms[value]
        if user_choice == previous_user_choice {
            count_identical_choices += 1
        } else {
            previous_user_choice = user_choice!
            count_identical_choices = 0
        }
        
        if (count_identical_choices >= difficult!) {
            computer_choice = chooseWinState(user_choice: user_choice!)
        } else {
            let randomInt = Int.random(in: 0..<3)
            computer_choice = arms[randomInt]
        }
        
        first_arm.setTitle(user_choice, for: .normal)
        third_arm.setTitle(computer_choice, for: .normal)
        
        human_face.isHidden = false
        robot_face.isHidden = false
        new_game.isHidden = false
        
        if user_choice == computer_choice {
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
        switch user_choice {
        case "✊🏼":
            if computer_choice == "✌🏼" {
                return true
            }
        case "🤚🏼":
            if computer_choice == "✊🏼" {
                return true
            }
        case "✌🏼":
            if computer_choice == "🤚🏼" {
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
    
    
    func chooseWinState(user_choice : String) -> String {
        switch user_choice {
        case "✊🏼":
            return "🤚🏼"
        case "🤚🏼":
            return "✌🏼"
        case "✌🏼":
            return "✊🏼"
        default:
            return ""
        }
    }
    
}

