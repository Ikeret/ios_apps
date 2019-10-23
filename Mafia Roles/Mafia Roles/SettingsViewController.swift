//
//  SettingsViewController.swift
//  Mafia Roles
//
//  Created by Сергей Коршунов on 22.10.2019.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var playersLabel: UILabel!
    @IBOutlet weak var mafiasLabel: UILabel!
    
    @IBOutlet weak var playersSliderOutlet: UISlider!
    @IBOutlet weak var mafiasSliderOutlet: UISlider!
    
    @IBOutlet weak var medicSwitchOutlet: UISwitch!
    @IBOutlet weak var sherifSwitchOutlet: UISwitch!
    @IBOutlet weak var maniacSwitchOutlet: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playersLabel.text = "Количество мирных: \(players)"
        mafiasLabel.text = "Количество мафиози: \(mafias)"
        playersSliderOutlet.value = Float(players)
        mafiasSliderOutlet.value = Float(mafias)
        medicSwitchOutlet.isOn = medic
        maniacSwitchOutlet.isOn = maniac
        sherifSwitchOutlet.isOn = sherif
    }
    
    @IBAction func playersSlider(_ sender: UISlider) {
        players = Int(sender.value)
        playersLabel.text = "Количество мирных: \(players)"
        
    }
    
    @IBAction func mafiasSlider(_ sender: UISlider) {
        mafias = Int(sender.value)
        mafiasLabel.text = "Количество мафиози: \(mafias)"
    }
    
    @IBAction func medicSwitch(_ sender: UISwitch) {
        medic = sender.isOn
    }
    
    @IBAction func sherifSwitch(_ sender: UISwitch) {
        sherif = sender.isOn
    }
    
    @IBAction func maniacSwitch(_ sender: UISwitch) {
        maniac = sender.isOn
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
