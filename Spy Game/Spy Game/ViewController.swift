//
//  ViewController.swift
//  Spy Game
//
//  Created by Сергей Коршунов on 21.10.2019.
//  Copyright © 2019 Сергей Коршунов. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var amountTimeLabel: UILabel!
    @IBOutlet weak var numberPlayersLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func amountTime(_ sender: UISlider) {
        time = Int(sender.value)
        amountTimeLabel.text = "Amount of time: \(time) min"
        time *= 60
        
    }
    
    @IBAction func numberPlayers(_ sender: UISlider) {
        players = Int(sender.value)
        numberPlayersLabel.text = "Number of players: \(players)"
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {

    }
}

