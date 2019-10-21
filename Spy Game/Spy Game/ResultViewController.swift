//
//  ResultViewController.swift
//  Spy Game
//
//  Created by Сергей Коршунов on 21.10.2019.
//  Copyright © 2019 Сергей Коршунов. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func restartGame(_ sender: Any) {
        performSegue(withIdentifier: "unwind1", sender: self)
    }
}
