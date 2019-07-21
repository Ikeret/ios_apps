//
//  ListsTableViewController.swift
//  Checker
//
//  Created by Сергей Коршунов on 18/07/2019.
//  Copyright © 2019 Sergey Korshunov. All rights reserved.
//

import UIKit

protocol DetailTableDelegate {
    func hideButton()
    func showButton()
}

class ListsTableViewController: UITableViewController {
    var isEditingList = false
    var editingListIndex : Int?
    var delegate: DetailTableDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if tableView.numberOfSections != ListsArray.count {
            tableView.insertSections(IndexSet(arrayLiteral: 0), with: .automatic)
        }
        else if let index = editingListIndex {
            tableView.reloadSections(IndexSet(arrayLiteral: index), with: .automatic)
            editingListIndex = nil
        }
        
//        DataManager.save(ListsArray, with: "test")
//        let data = DataManager.load("test", with: Array<List>.self)
//        print(data[0].name)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let objectDelegate = delegate {
            objectDelegate.showButton()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let objectDelegate = delegate {
            objectDelegate.hideButton()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return ListsArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! ListTableViewCell
        cell.titleLabel.text = ListsArray[indexPath.section].title
        cell.categoryLabel.text = ListsArray[indexPath.section].category
        
        
        var space : CGFloat = 16.0
        if cell.categoryLabel.text == "" {
            space += 19
        }

        
        if let color = str2col(ListsArray[indexPath.section].color) {
            cell.titleLabel.textColor = .white
            cell.categoryLabel.textColor = .white
            cell.colorIndicator.backgroundColor = .white
            cell.frameView.backgroundColor = color
            cell.frameView.alpha = 0.7
        }
        else {
            if space == 16.0 {
                cell.colorIndicator.backgroundColor = .lightGray
            } else {
                cell.colorIndicator.backgroundColor = .clear
                space += 5
            }
        }
        
        cell.topConstrain.constant = space
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15.0
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 15))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.conformDeletion(ListsArray[indexPath.section].title, indexPath: indexPath)
        }
    }
    
    

    
//    // Override to support rearranging the table view.
//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//        let item = ListsArray[fromIndexPath.section]
//        ListsArray.remove(at: fromIndexPath.section)
//        ListsArray.insert(item, at: to.section)
//    }
 

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        CurrentListName = ListsArray[indexPath.section].title
        performSegue(withIdentifier: "ShowCurrentList", sender: self)
    }
 
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            self.isEditingList = true
            self.editingListIndex = indexPath.section
            self.performSegue(withIdentifier: "showEditWindow", sender: self)
            self.isEditingList = false
        }
        editAction.backgroundColor = .blue
        
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.conformDeletion(ListsArray[indexPath.section].title, indexPath: indexPath)
        }
        return [deleteAction, editAction]
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, complition) in
            self.isEditingList = true
            self.editingListIndex = indexPath.section
            self.performSegue(withIdentifier: "showEditWindow", sender: self)
            self.isEditingList = false
            complition(true)
        }
        editAction.backgroundColor = .blue
        
        let pinAction = UIContextualAction(style: .normal, title: "Pin") { (action, view, complition) in
            // MARK: TODO: Pin action
        }
        pinAction.backgroundColor = .orange
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, complition) in
            self.conformDeletion(ListsArray[indexPath.section].title, indexPath: indexPath)
            complition(false)
        }
        
        // MARK: TODO: Action images
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction, pinAction])
    }
    
    func conformDeletion(_ name: String, indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Checker", message: #"Do you realy want to delete "\#(name)" list?"#, preferredStyle: .alert)
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let deleteAlertAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            SavedData.removeObject(forKey: name)
            ListsArray.remove(at: indexPath.section)
            self.tableView.deleteSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
        }
        alertController.addAction(cancelAlertAction)
        alertController.addAction(deleteAlertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true 
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showEditWindow", isEditingList {
            let destinationController = segue.destination as! AddListViewController
                
            destinationController.editingListIndex = editingListIndex
            
        }
        
    }
}
