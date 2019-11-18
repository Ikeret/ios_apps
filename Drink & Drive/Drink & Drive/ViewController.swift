//
//  ViewController.swift
//  Drink & Drive
//
//  Created by Сергей Коршунов on 14.11.2019.
//  Copyright © 2019 Сергей Коршунов. All rights reserved.
//

import UIKit
import SPAlert
import CountdownLabel
class ViewController: UIViewController {

    @IBOutlet weak var timerLabel: CountdownLabel!
    
    @IBOutlet weak var dateToDriveLabel: UILabel!
    
    @IBOutlet weak var drinkInfoLabel: UILabel!
    
    @IBOutlet weak var addDrinkButtonOutlet: UIButton!
    @IBOutlet weak var resetTimerButton: UIButton!
    
    @IBOutlet weak var drinkPicker: UIPickerView!
    
//    var currentTime = 0.0 {
//        didSet {
//            timerLabel.setCountDownTime(minutes: currentTime)
//
//            if currentTime > 0 {
//                timerLabel.start()
//                resetTimerButton.isHidden = false
//
//            } else {
//                resetTimerButton.isHidden = true
//                timerLabel.cancel()
//            }
//        }
//    }
    
    var currentDrink: drink = .init(name: "", amount: 0, persent: 0) {
        didSet  {
            var text = ""
            if !currentDrink.name.isEmpty {
                text = "Your drink: \(currentDrink.name) \(currentDrink.persent)%"
                if currentDrink.amount != 0 {
                    text += " \(currentDrink.amount) ml"
                }
                
            } else {
                text = "Choose your drink:"
            }
            drinkInfoLabel.text = text
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDrinkButtonOutlet.layer.cornerRadius = 15
        addDrinkButtonOutlet.layer.borderWidth = 3
        addDrinkButtonOutlet.layer.borderColor = pinkCGColor
        
        
        let timerFinishTime = UserDefaults.standard.double(forKey: "timerFinishTime")
        let currentTime = Date().timeIntervalSince1970
        if timerFinishTime != 0 && currentTime < timerFinishTime {
            timerLabel.addTime(time: timerFinishTime - currentTime)
            timerLabel.start()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !UserDefaults.standard.bool(forKey: "isRunnedBefore") {
            let alert = configureAlert(title: "Warning!", message: "This application shows the approximate time for alcohol to leave your body and is not a 100% guarantee. For a more accurate determination of the amount of alcohol in your body, use a breathalyzer")
            present(alert, animated: true)
            UserDefaults.standard.set(true, forKey: "isRunnedBefore")
        }
    }
    
    @IBAction func resetTimer(_ sender: Any) {
        timerLabel.setCountDownTime(minutes: 0)
        timerLabel.cancel()
        UserDefaults.standard.set(0, forKey: "timerFinishTime")
    }
    

    @IBAction func addDrink(_ sender: UIButton) {
        guard weight != nil else {
            let alert = configureAlert(title: "Error", message: "You need to define your weight in settings")
            present(alert, animated: true)
            return
        }
        
        
        if !currentDrink.name.isEmpty && currentDrink.amount != 0 {
            let currentTime = getTimeForDrink(degree: currentDrink.persent, volume: Double(currentDrink.amount))
//            if currentTime + timerLabel.timeRemaining > 24 * 60 * 60 {
//                let alert = configureAlert(title: "You're completely drunk!", message: "You can't drive more than 24 hours, you need to stop drink")
//                present(alert, animated: true)
//                timerLabel.setCountDownTime(minutes: 24*60*60 - 1)
//                let timerFinishTime = Date().timeIntervalSince1970 + timerLabel.timeRemaining
//                UserDefaults.standard.set(timerFinishTime, forKey: "timerFinishTime")
//                return
//            }
            timerLabel.addTime(time: currentTime)
            timerLabel.start()
            
            let timerFinishTime = Date().timeIntervalSince1970 + timerLabel.timeRemaining
            UserDefaults.standard.set(timerFinishTime, forKey: "timerFinishTime")
            SPAlert.present(title: "Added", preset: .done)
        } else {
            let alert = configureAlert(title: "Error", message: "Choose drink and volume")
            present(alert, animated: true)
        }
    }

}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return drinks.count
        } else if component == 1 {
            return amounts.count
        } else {
            fatalError()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(drinks[row].name) \(drinks[row].persent)%"
        } else if component == 1 {
            return "\(amounts[row]) ml"
        } else {
            fatalError()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == drinks.count - 1 && component == 0 {
            let alert = UIAlertController(title: "Custom drink", message: nil, preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                textField.placeholder = "Name"
            }
            
            alert.addTextField { (textField) in
                textField.placeholder = "%"
            }
            
            alert.addAction(.init(title: "OK", style: .default, handler: { (action) in
                if let persent = Double(alert.textFields![1].text!) {
                    let name = alert.textFields![0].text!
                    self.currentDrink.name = name
                    self.currentDrink.persent = persent
                }
            }))
            alert.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
            
            present(alert, animated: true)
        } else {
            if component == 0 {
                currentDrink.name = drinks[row].name
                currentDrink.persent = drinks[row].persent
            } else if component == 1 {
                currentDrink.amount = amounts[row]
            }
        }
    }
}

