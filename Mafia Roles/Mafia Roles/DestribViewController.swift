//
//  DestribViewController.swift
//  Mafia Roles
//
//  Created by Сергей Коршунов on 22.10.2019.
//

import UIKit

class DestribViewController: UIViewController {
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var roles_array: [roles] = []
    var selector = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 1...mafias {
            roles_array.append(.mafia)
        }
        for _ in 0..<players {
            roles_array.append(.player)
        }
        if medic { roles_array.append(.medic) }
        if maniac { roles_array.append(.maniac) }
        if sherif { roles_array.append(.sherif) }
        roles_array.shuffle()
        
        roleLabel.text = "Передайте телефон первому игроку."
        descriptionLabel.text = "Нажмите ОК, когда будете готовы"
    }
    
    @IBAction func okAction(_ sender: Any) {
        if roles_array.isEmpty {
            let alert = UIAlertController (title: "Все роли распределены", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.performSegue(withIdentifier: "unwind", sender: self)
            }))
            present(alert, animated: true)
        }
        
        if selector == false {
            let role = roles_array.popLast()!
            roleLabel.text = "Вы \(role.rawValue)."
            descriptionLabel.text = descriptions[role.rawValue]
            
            
            
            
        } else {
            roleLabel.text = "Передайте телефон следующему игроку."
            descriptionLabel.text = "Нажмите ОК, когда будете готовы"
            
        }
        selector = !selector
        
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
