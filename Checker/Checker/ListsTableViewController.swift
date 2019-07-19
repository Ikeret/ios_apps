//
//  ListsTableViewController.swift
//  Checker
//
//  Created by Сергей Коршунов on 18/07/2019.
//  Copyright © 2019 Sergey Korshunov. All rights reserved.
//

import UIKit

class ListsTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.reloadData()
        let notification = Notification.init(name: Notification.Name(rawValue: "ShowButton"), object: nil, userInfo: nil)
        NotificationCenter.default.post(notification)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListsArray.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "ListCell")
        cell.textLabel?.text = "  \(ListsArray[indexPath.row].name)"
        cell.detailTextLabel?.text = ListsArray[indexPath.row].category
        
        if let color = str2col(ListsArray[indexPath.row].color) {
            
            let mark = UIView(frame: CGRect(x: 10, y: 17.5, width: 10, height: 10))
            mark.backgroundColor = color
            mark.layer.cornerRadius = mark.frame.size.width / 2

            cell.contentView.addSubview(mark)
        }
        cell.accessoryType = .disclosureIndicator

        return cell
    }
 

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.conformDeletion(ListsArray[indexPath.row].name, indexPath: indexPath)
        }
    }
    

    
//    // Override to support rearranging the table view.
//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//        let item = ListsArray[fromIndexPath.row]
//        ListsArray.remove(at: fromIndexPath.row)
//        ListsArray.insert(item, at: to.row)
//    }
 

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        CurrentListName = ListsArray[indexPath.row].name
        performSegue(withIdentifier: "ShowCurrentList", sender: self)
    }
 
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            // MARK: TODO: Edit Action
        }
        editAction.backgroundColor = .blue
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.conformDeletion(ListsArray[indexPath.row].name, indexPath: indexPath)
        }
        return [deleteAction, editAction]
    }
    
    func conformDeletion(_ name: String, indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Checker", message: #"Do you realy want to delete "\#(name)" list?"#, preferredStyle: .alert)
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAlertAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            SavedData.removeObject(forKey: name)
            ListsArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        alertController.addAction(cancelAlertAction)
        alertController.addAction(deleteAlertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
    }
}
