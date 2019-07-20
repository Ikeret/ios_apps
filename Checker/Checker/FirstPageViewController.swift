//
//  FirstPageViewController.swift
//  Checker
//
//  Created by Сергей Коршунов on 19/07/2019.
//  Copyright © 2019 Sergey Korshunov. All rights reserved.
//

import UIKit

class FirstPageViewController: UIViewController, DetailTableDelegate {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var addButton: UIButton?
    
    var tableViewController: ListsTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAddButton()
    }
    
    func setupAddButton() {        
        addButton!.layer.cornerRadius = addButton!.frame.width / 2
    }
    
    func hideButton() {
        addButton?.isHidden = true
    }
    
     func showButton() {
        addButton?.isHidden = false
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
        if segue.identifier == "toListsTVC" {
            let delegateController = (segue.destination as! UINavigationController).children[0] as! ListsTableViewController
            delegateController.delegate = self
        }
        
     }
 
    
}
