//
//  MenuViewController.swift
//  Rock Paper Scissors
//
//  Created by Сергей Коршунов on 15/07/2019.
//  Copyright © 2019 Sergey Korshunov. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var user_face: UIButton!
    @IBOutlet weak var hint: UILabel!
    
    var user_stored_face : String {
        set {
            UserDefaults.standard.set(newValue, forKey: "UserFace")
            UserDefaults.standard.synchronize()
        }
        get {
            if let face = UserDefaults.standard.value(forKey: "UserFace") as? String {
                return face
            } else {
                UserDefaults.standard.set("👱🏼‍♂️", forKey: "UserFace")
                UserDefaults.standard.synchronize()
                return "👱🏼‍♂️"
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        user_face.setTitle(user_stored_face, for: .normal)
        
        hide_hint()
    }
    
    @IBAction func Change_user_face(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Rock Paper Scissors", message: "Choose your avatar", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Only one emoji"
        }
        
        let alertActionDone = UIAlertAction(title: "Done", style: .default) { (alert) in
            if let new_user_face = alertController.textFields![0].text, new_user_face.count == 1 {
                self.user_stored_face = new_user_face
                self.user_face.setTitle(new_user_face, for: .normal)
                self.hide_hint()
            }
        }
        
        let alertActionCancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addAction(alertActionDone)
        alertController.addAction(alertActionCancel)
        present(alertController, animated: true, completion: nil)
    }
    
    func hide_hint() {
        if (UserDefaults.standard.value(forKey: "UserFace") as? String) != nil {
            hint.isHidden = true
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
