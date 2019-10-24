//
//  SpinViewController.swift
//  Numbers
//
//  Created by Сергей Коршунов on 24.10.2019.
//  Copyright © 2019 Sergey Korshunov. All rights reserved.
//

import UIKit
import SpinWheelControl
class SpinViewController: UIViewController {


    @IBOutlet weak var spinWheel: SpinWheelControl!
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinWheel.addTarget(self, action: #selector(spinWheelDidChangeValue), for: UIControl.Event.valueChanged)
        spinWheel.dataSource = self
        
        spinWheel.reloadData()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        spinWheel.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        spinWheel.reloadData()
    }
    
    @IBAction func spinButton(_ sender: Any) {
        spinWheel.randomSpin()
    }
    
    @objc func spinWheelDidChangeValue(sender: AnyObject) {
        resultLabel.text = wheelStrings[spinWheel.selectedIndex]
        resultLabel.isHidden = false
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

extension SpinViewController: SpinWheelControlDataSource, SpinWheelControlDelegate {
    func numberOfWedgesInSpinWheel(spinWheel: SpinWheelControl) -> UInt {
        return UInt(wheelStrings.count)
    }
    
    func wedgeForSliceAtIndex(index: UInt) -> SpinWheelWedge {
        let wedge = SpinWheelWedge()
              
        wedge.shape.fillColor = colorForIndex(index: Int(index))
        wedge.label.text = wheelStrings[Int(index)]
              
        return wedge
    }
    
    
}
