//
//  ViewController.swift
//  Password Generator
//
//  Created by Сергей Коршунов on 19.10.2019.
//  Copyright © 2019 Сергей Коршунов. All rights reserved.
//

import UIKit
import SPAlert
import Spring

class ViewController: UIViewController {
    
    var length = 12
    let num = "0123456789"
    let lowaplha = "abcdefghijklmnopqrstuvwxyz"
    let uppaplha = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    
    var password = String()

    @IBOutlet weak var passwordLabel: SpringLabel!
    
    
    @IBOutlet weak var settingsView: UIView!
    
    @IBOutlet weak var lenghtLabel: UILabel!
    
    @IBOutlet weak var upperLettersSwitch: UISwitch!
    @IBOutlet weak var digitsSwitch: UISwitch!
    
    
    
    
    @IBOutlet weak var copyToClipboardButton: SpringButton!
    @IBOutlet weak var generatePasswordButton: SpringButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsView.layer.cornerRadius = 10
        generatePasswordButton.layer.cornerRadius = 10
        copyToClipboardButton.layer.cornerRadius = 10
        
        
        
    }
    
    @IBAction func lenghtSliderAction(_ sender: UISlider!) {
        length = Int(sender.value)
        lenghtLabel.text = "Lenght: \(length)"
    }
    

    @IBAction func copyToClipboardAction(_ sender: Any) {
        if passwordLabel.isHidden { return }
        SPAlert.present(title: "Copied", preset: .done)
        UIPasteboard.general.string = password
        
        copyToClipboardButton.animation = "fadeIn"
        copyToClipboardButton.animate()
    }
    
    @IBAction func generatePasswordAction(_ sender: Any) {
        if copyToClipboardButton.isHidden {
            copyToClipboardButton.isHidden = false
            copyToClipboardButton.animate()

        }
        if passwordLabel.isHidden {
            passwordLabel.isHidden = false
            passwordLabel.animate()
        } else {
            passwordLabel.animation = "fadeIn"
            passwordLabel.animate()
        }
        
        generatePasswordButton.animation = "fadeIn"
        generatePasswordButton.animate()
        
        
        password = randomString(length: length)
        
        passwordLabel.text = "Your password: \(password)"
    }
    
    private func randomString(length: Int) -> String {
        var string = lowaplha
        if upperLettersSwitch.isOn {
            string += uppaplha
        }
        if digitsSwitch.isOn {
            string += num
        }
        return String((0..<length).map{ _ in string.randomElement()! })
    }
}

