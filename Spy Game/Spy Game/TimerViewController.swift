//
//  TimerViewController.swift
//  Spy Game
//
//  Created by Сергей Коршунов on 21.10.2019.
//  Copyright © 2019 Сергей Коршунов. All rights reserved.
//

import UIKit
import SRCountdownTimer

class TimerViewController: UIViewController {

    @IBOutlet weak var timerView: SRCountdownTimer!
    override func viewDidLoad() {
        super.viewDidLoad()
        timerView.delegate = self
        timerView.labelFont = .systemFont(ofSize: 24.0)
        timerView.start(beginingValue: time)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func restartButton(_ sender: Any) {
        timerView.start(beginingValue: time)
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

extension TimerViewController: SRCountdownTimerDelegate {
    func timerDidEnd() {
        performSegue(withIdentifier: "toResultVC", sender: self)
    }
}
