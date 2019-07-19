//
//  FirstPageViewController.swift
//  Checker
//
//  Created by Сергей Коршунов on 19/07/2019.
//  Copyright © 2019 Sergey Korshunov. All rights reserved.
//

import UIKit

class FirstPageViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var addButton: UIButton!
    
    var tableViewController: ListsTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAddButton()
    }
    
    func setupAddButton() {
        let deviceName = UIDevice.current.name
        
        for model in deprecatedModels {
            if deviceName.contains(model) {
                addButton.isHidden = true
                return
            }
        }
        
        let notificationHide = Notification.Name(rawValue: "HideButton")
        let notificationShow = Notification.Name(rawValue: "ShowButton")
        NotificationCenter.default.addObserver(self, selector: #selector(hideButton), name: notificationHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showButton), name: notificationShow, object: nil)
        
        addButton.layer.cornerRadius = addButton.frame.width / 2
    }
    
    @objc func hideButton() {
        addButton.isHidden = true
    }
    
    @objc func showButton() {
        addButton.isHidden = false
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
