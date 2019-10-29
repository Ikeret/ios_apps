//
//  ViewController.swift
//  Truth or Action
//
//  Created by Сергей Коршунов on 29.10.2019.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var changingAvatarIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    @IBAction func startGameAction(_ sender: Any) {
        if players.count < 2 {
            let alert = UIAlertController(title: "Правда или действие", message: "Для начала игры нужно хотя бы 2 игрока.", preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default, handler: { (action) in
                self.showAddAlert()
            }))
            present(alert, animated: true)
        }
        performSegue(withIdentifier: "toGameVC", sender: self)
    }
    

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < players.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell") as! PlayerTableViewCell
            
            let currentPlayer = players[indexPath.row]
            cell.avatarButton.setTitle(currentPlayer.avatar, for: .normal)
            cell.avatarButton.tag = indexPath.row
            cell.avatarButton.addTarget(self, action: #selector(showAvatarsScene), for: .touchUpInside)
            cell.nameLabel.text = currentPlayer.name
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addButtonCell") as! AddButtonTableViewCell

            cell.addButton.addTarget(self, action: #selector(showAddAlert), for: .touchUpInside)
            
            return cell
        }
    }
    
    @objc func showAvatarsScene(_ sender: UIButton) {
        changingAvatarIndex = sender.tag
        performSegue(withIdentifier: "toAvatarsVC", sender: self)
    }
    
    @objc func showAddAlert() {
        let alert = UIAlertController(title: "Правда или Действие", message: "Добавить нового игрока", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Имя"
        }
        
        alert.addAction(.init(title: "Добавить", style: .default, handler: { (action) in
            if let name = alert.textFields![0].text {
                players.append(.init(avatar: String.randomEmoji, name: name))
                self.tableView.insertRows(at: [IndexPath(row: players.count - 1, section: 0)], with: .automatic)
            }
        }))
        alert.addAction(.init(title: "Отмена", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row < players.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            players.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAvatarsVC" {
            let avatarsVC = segue.destination as! AvatarsCollectionViewController
            avatarsVC.changingAvatarIndex = changingAvatarIndex
        }
    }
    
}
