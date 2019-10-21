//
//  RolesViewController.swift
//  Spy Game
//
//  Created by Сергей Коршунов on 21.10.2019.
//  Copyright © 2019 Сергей Коршунов. All rights reserved.
//

import UIKit

class RolesViewController: UIViewController {
    @IBOutlet weak var LocationLabel: UILabel!
    @IBOutlet weak var orderLabel: UILabel!
    
    var intSpy = Int.random(in: 1..<players)
    var numberOfPlayers = 1
    var selector = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        intSpy = Int.random(in: 1..<players)
        numberOfPlayers = 1
        selector = false
        location = arrayOfLocations.randomElement()!
        
        LocationLabel.text = "Pass the device to the first player"
        orderLabel.text = "Click OK when ready"
    }
    

    @IBAction func okAction(_ sender: Any) {
        if numberOfPlayers > players {
            performSegue(withIdentifier: "toTimerVC", sender: self)
        }else{
            if selector == false {
                LocationLabel.text = location
                orderLabel.text = "All players except the spy know this location. Ask questions to other players to understand who does not know the location"
                if numberOfPlayers == intSpy {
                    LocationLabel.text = "You are spy"
                    orderLabel.text = "Try to understand what location other players are talking about"
                    selector = !selector
                }
                numberOfPlayers = numberOfPlayers + 1
                selector = true
            } else {
                LocationLabel.text = "Transfer the device to the next player"
                orderLabel.text = "Click OK when ready"
                selector = false
            }
        }
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
