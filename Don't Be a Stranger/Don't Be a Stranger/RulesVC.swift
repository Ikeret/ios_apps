//
//  RulesVC.swift
//  Don't Be a Stranger
//
//  Created by Сергей Коршунов on 20.10.2019.
//  Copyright © 2019 Сергей Коршунов. All rights reserved.
//

import UIKit

class RulesVC: UIViewController {
    
    @IBOutlet weak var rulesLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView.layer.cornerRadius = 8
        backgroundView.layer.shadowOffset = CGSize(width: 7, height: 7)
        backgroundView.layer.shadowRadius = 5
        backgroundView.layer.shadowOpacity = 0.5
        rulesLabel.text = rulesText
    }

}
