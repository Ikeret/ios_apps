//
//  DifficultyViewController.swift
//  Rock Paper Scissors
//
//  Created by Сергей Коршунов on 15/07/2019.
//  Copyright © 2019 Sergey Korshunov. All rights reserved.
//

import UIKit

class DifficultyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var difficult: UISlider!
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let destinationVC : ViewController = segue.destination as! ViewController
        destinationVC.difficult = Int(round(difficult.value))
    }
    

}
