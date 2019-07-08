//
//  FirstViewController.swift
//  Numbers
//
//  Created by Сергей Коршунов on 08/07/2019.
//  Copyright © 2019 Sergey Korshunov. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.firstInput.delegate = self
        self.secondInput.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
  
    
    var firstNum = 0
    var secondNum = 100
    
    @IBOutlet weak var firstInput: UITextField!
    @IBOutlet weak var secondInput: UITextField!
    
    @IBOutlet weak var randomNum: UILabel!
    
    @IBAction func firstNumInput(_ sender: UITextField) {
        let value = Int(firstInput.text!)
        guard value != nil else {
            firstNum = 0
            firstInput.text = ""
            return
        }
        firstNum = value!
    }
   
    @IBAction func secondNumInput(_ sender: UITextField) {
        let value = Int(secondInput.text!)
        guard value != nil else {
            secondNum = 0
            secondInput.text = ""
            return
        }
        secondNum = value!
    }
    @IBAction func generate(_ sender: UIButton) {
        guard firstNum < secondNum else {
            randomNum.text = "Error"
            randomNum.textColor = .red
            return
        }
        
        let randomValue = Int.random(in: firstNum...secondNum)
        randomNum.text = "\(randomValue)"
        randomNum.textColor = .black
    }

}

