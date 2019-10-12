//
//  ViewController.swift
//  devIstanbul
//
//  Created by serpil tok on 8.10.2019.
//  Copyright © 2019 SelimSelcuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var buttonOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        buttonOutlet.layer.cornerRadius = 5
    }


}

