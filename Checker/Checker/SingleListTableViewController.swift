//
//  SingleListTableViewController.swift
//  Checker
//
//  Created by Сергей Коршунов on 18/07/2019.
//  Copyright © 2019 Sergey Korshunov. All rights reserved.
//

import UIKit


class SingleListTableViewController: UITableViewController {
    var CurrentList: [Item] {
        set { setListForName(newValue, CurrentListName!) }
        get { return getListForName(CurrentListName!) }
    }
    
    var resultsController = UIViewController()
    var searchController = UISearchController()
    
    var filteredTasks = [String]()
    
    var searchbarIsEmpty: Bool {
        guard let text = searchController.searchBar.text  else {
            return false
        }
        return text.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = CurrentListName
        searchController = UISearchController(searchResultsController: resultsController)
        performSearchController()
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return CurrentList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ItemCell")
        cell.textLabel?.text = CurrentList[indexPath.row].name
        if (CurrentList[indexPath.row].checked) {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }

        // Configure the cell...

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CurrentList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let item = CurrentList[fromIndexPath.row]
        CurrentList.remove(at: fromIndexPath.row)
        CurrentList.insert(item, at: to.row)
    }

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
 
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            // MARK: TODO: Edit task name
        }
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.CurrentList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        return [deleteAction, editAction]
    }
    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CurrentList[indexPath.row].checked = !CurrentList[indexPath.row].checked
        tableView.deselectRow(at: indexPath, animated: true)
        if AutoSorting {
            CurrentList.sort { (first, second) -> Bool in
                return second.checked
            }
        }
        tableView.reloadData()
        
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

extension SingleListTableViewController : UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    
    func performSearchController() {
        searchController.searchResultsUpdater = self
        
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Enter the task"
        searchController.searchBar.setImage(UIImage(), for: .search, state: .normal)
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.returnKeyType = .done
        searchController.searchBar.autocapitalizationType = .sentences
        searchController.searchBar.isTranslucent = true
        
        searchController.searchBar.delegate = self
        searchController.delegate = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController?.isActive = true
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
        for view in resultsController.view.subviews {
            view.removeFromSuperview()
        }
        var y : CGFloat = 150.0
        
        let button = UIButton(frame: CGRect(x: 20, y: y, width: UIScreen.main.bounds.width - 40, height: 40))
        button.backgroundColor = .white
        button.setTitle("Add new", for: .normal)
        button.setTitleColor(.green, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.alpha = 0.8
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        y += 50.0
        resultsController.view.addSubview(button)
        
        for name in filteredTasks {
            let label = UILabel(frame: CGRect(x: 20, y: y, width: UIScreen.main.bounds.width - 40, height: 40))
            label.text = name
            label.textAlignment = .center
            label.layer.cornerRadius = 15
            label.layer.masksToBounds = true
            label.backgroundColor = .white
            label.alpha = 0.8
            resultsController.view.addSubview(label)
            y += 50.0
        }
    }
    
    @objc func buttonAction(sender: Any?) {
        let name = searchController.searchBar.text!
        Tasks.append(name)
        Tasks.sort { $0 < $1 }
        CurrentList.append(Item(name: name, checked: false))
        searchController.searchResultsController?.dismiss(animated: true, completion: {
            self.searchController.searchBar.text?.removeAll()
            self.tableView.reloadData()
        })
    }
    
    func filterContentForSearchText(_ searchText: String) {
        if searchbarIsEmpty { filteredTasks = Tasks}
        else {
            filteredTasks = Tasks.filter({ (name) -> Bool in
                return name.lowercased().contains(searchText.lowercased())
            })
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        buttonAction(sender: nil)
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        updateSearchResults(for: searchController)
    }
}
