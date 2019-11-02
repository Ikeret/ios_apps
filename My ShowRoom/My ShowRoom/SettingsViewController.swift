//
//  SettingsViewController.swift
//  My ShowRoom
//
//  Created by Сергей Коршунов on 02.11.2019.
//  Copyright © 2019 Сергей Коршунов. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var switchesOutletCollection: [UISwitch]!
    override func viewDidLoad() {
        super.viewDidLoad()
        for Switch in switchesOutletCollection {
            Switch.setOn(!checkIsHidden(sender: Switch), animated: false)
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func switchAction(_ sender: UISwitch) {
        let name = categories[sender.tag]
        UserDefaults.standard.set(!sender.isOn, forKey: name)
        
        categoriesVisibilityIsChanged = true
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
