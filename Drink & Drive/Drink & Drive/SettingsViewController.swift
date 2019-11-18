//
//  SettingsViewController.swift
//  Drink & Drive
//
//  Created by Сергей Коршунов on 14.11.2019.
//  Copyright © 2019 Сергей Коршунов. All rights reserved.
//

import UIKit
import SPAlert

class SettingsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var metricSegmentControl: UISegmentedControl!
    @IBOutlet weak var genderSegmentControl: UISegmentedControl!
    @IBOutlet weak var saveButtonOutlet: UIButton!
    @IBOutlet weak var weightTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        saveButtonOutlet.layer.cornerRadius = 10
        saveButtonOutlet.layer.borderColor = pinkCGColor
        saveButtonOutlet.layer.borderWidth = 3
        
        if weight != nil {
            weightTextField.text = "\(weight!)"
        }
        
        if UserDefaults.standard.bool(forKey: "isFemale") {
            genderSegmentControl.selectedSegmentIndex = 1
        }
        
        if !UserDefaults.standard.bool(forKey: "isLbs") {
            metricSegmentControl.selectedSegmentIndex = 1
            weightTextField.placeholder = "kg"
        } else {
            weightTextField.placeholder = "lbs"
        }
        
        weightTextField.delegate = self
    }
    

    @IBAction func segmentControlAction(_ sender: UISegmentedControl) {
        let metric = sender.titleForSegment(at: sender.selectedSegmentIndex)
        weightTextField.placeholder = metric
    }
    
    @IBAction func saveButton(_ sender: Any) {
        let text = weightTextField.text!
        if Double(text) == nil || text.isEmpty {
            let alert = configureAlert(title: "Error", message: "Please input the correct information")
            present(alert, animated: true)
            return
        }

        UserDefaults.standard.set(Double(text), forKey: "weight")
        UserDefaults.standard.set(true, forKey: "definedWeight")
        
        if genderSegmentControl.selectedSegmentIndex == 1 {
            UserDefaults.standard.set(true, forKey: "isFemale")
        } else {
            UserDefaults.standard.set(false, forKey: "isFemale")
        }
        
        if metricSegmentControl.selectedSegmentIndex == 0 {
            UserDefaults.standard.set(true, forKey: "isLbs")
        } else {
            UserDefaults.standard.set(false, forKey: "isLbs")
        }
        
        SPAlert.present(title: "Saved", preset: .done)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
