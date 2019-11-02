//
//  SecondViewController.swift
//  My ShowRoom
//
//  Created by Сергей Коршунов on 02.11.2019.
//  Copyright © 2019 Сергей Коршунов. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    @IBOutlet var buttonsOutletCollection: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for button in buttonsOutletCollection {
            button.isHidden = checkIsHidden(sender: button)
        }
    }
    
    @IBAction func buttonAction(sender: UIButton) {
        performSegue(withIdentifier: "ClothesVC", sender: sender.tag)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ClothesVC" {
            let destinationVC = segue.destination as! ClothesTableViewController
            let tag = sender as! Int

            destinationVC.tableView.allowsSelection = false
            destinationVC.navigationItem.title = categories[tag]
            destinationVC.tag = tag
            let dataNames = UserDefaults.standard.array(forKey: categories[tag]) as? [String] ?? []
            destinationVC.dataNames = dataNames
            destinationVC.data = loadAllImages(imageNames: dataNames)
        }
    }
}

