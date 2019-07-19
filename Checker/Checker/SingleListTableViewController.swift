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
    
    @IBOutlet weak var progressView: UIProgressView!
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
        
        updateProgress()
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        let notification = Notification.init(name: Notification.Name(rawValue: "HideButton"), object: nil, userInfo: nil)
        NotificationCenter.default.post(notification)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Settings["AutoSorting"] ?? true {
            sortList()
            tableView.reloadData()
        }
    }
    
    func updateProgress() {
        let countTasks = CurrentList.count
        if countTasks == 0 {
            progressView.isHidden = true
            return
        } else {
            progressView.isHidden = false
        }
        
        var res = 0
        for task in CurrentList {
            if task.checked { res += 1 }
        }
        
        let progress: Float = Float(res) / Float(countTasks)
        progressView.setProgress(progress, animated: true)
        if res == 0 {
            progressView.isHidden = true
        }
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
            updateProgress()
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
            self.presentAlert(indexPath: indexPath)
        }
        editAction.backgroundColor = .blue
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.CurrentList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.updateProgress()
        }
        return [deleteAction, editAction]
    }
    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
        if Settings["AutoSorting"] ?? true {
            sortingWhenChecked(indexPath)
        } else {
            CurrentList[indexPath.row].checked = !CurrentList[indexPath.row].checked
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        updateProgress()
        
    }
    
    func sortingWhenChecked(_ indexPath: IndexPath) {
        var cell = CurrentList[indexPath.row]

        if !cell.checked {
            cell.checked = true
            let endOfList = IndexPath(row: CurrentList.count - 1, section: 0)
            tableView.moveRow(at: indexPath, to: endOfList)
            CurrentList.remove(at: indexPath.row)
            CurrentList.insert(cell, at: CurrentList.count)
            tableView.reloadRows(at: [endOfList], with: .automatic)
        } else {
            var lastUncheck = CurrentList.lastIndex(where: { (item) -> Bool in
                return !item.checked
            })
            if lastUncheck == nil {
                lastUncheck = 0
            } else {
                lastUncheck! += 1
            }
            let destination = IndexPath(row: lastUncheck!, section: 0)
            tableView.moveRow(at: indexPath, to: destination)
            cell.checked = false
            CurrentList.remove(at: indexPath.row)
            CurrentList.insert(cell, at: lastUncheck!)
            tableView.reloadRows(at: [destination], with: .automatic)
        }
    }
    
    func sortList() {
        CurrentList.sort { (first, second) -> Bool in
            return second.checked
        }
    }
    
    func presentAlert(indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Edit task", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let doneAction = UIAlertAction(title: "Done", style: .default) { (action) in
            let text = alertController.textFields![0].text!
            if !text.isEmpty {
                self.CurrentList[indexPath.row].name = text
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "name"
        }
        present(alertController, animated: true, completion: nil)
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
        searchController.searchBar.tintColor = UIColor(named: "ColorScheme")
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
        
        for view in resultsController.view.subviews {
            view.removeFromSuperview()
        }
        
        let ShouldDisplay = Settings["RememberingWords"] ?? true
        if ShouldDisplay {
            searchController.obscuresBackgroundDuringPresentation = true
            filterContentForSearchText(searchController.searchBar.text!)
            displayResults()
        }
        else {
            searchController.obscuresBackgroundDuringPresentation = false
            
        }
        
        
    }
    
    @objc func buttonAction(sender: UIButton?) {
        var name = ""
        if let button = sender, sender?.tag != 1 {
            name = button.title(for: .normal)!
            if name != searchController.searchBar.text {
                searchController.searchBar.text = name
                return
            }
        } else {
            name = searchController.searchBar.text!
        }
        if Settings["RememberingWords"] ?? true {
            Tasks.append(name)
            Tasks = Array(Set(Tasks))
            Tasks.sort()
        }
        CurrentList.insert(Item(name: name, checked: false), at: 0)
        updateProgress()
        searchController.searchResultsController?.dismiss(animated: true, completion: {
            self.searchController.searchBar.text?.removeAll()
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        })
    }
    
    func filterContentForSearchText(_ searchText: String) {
        if searchbarIsEmpty { filteredTasks = Tasks }
        else {
            filteredTasks = Tasks.filter({ (name) -> Bool in
                return name.lowercased().contains(searchText.lowercased())
            })
        }
        filteredTasks.sort()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        buttonAction(sender: nil)
    }
    
    
    func displayResults() {
        
        let window = UIApplication.shared.keyWindow
        let topPadding = (window?.safeAreaInsets.top)!
        var y : CGFloat = topPadding + 110.0
        let button = UIButton(frame: CGRect(x: 20, y: y, width: UIScreen.main.bounds.width - 40, height: 40))
        button.backgroundColor = .white
        button.setTitle("Add New", for: .normal)
        button.setTitleColor(UIColor(named: "ColorScheme"), for: .normal)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 15
        button.alpha = 0.8
        button.tag = 1
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        y += 50.0
        resultsController.view.addSubview(button)

        for name in filteredTasks {
            let task = UIButton(frame: CGRect(x: 20, y: y, width: UIScreen.main.bounds.width - 40, height: 40))
            task.setTitle(name, for: .normal)
            task.setTitleColor(.black, for: .normal)
            task.titleLabel!.textAlignment = .center
            task.layer.cornerRadius = 15
            task.backgroundColor = .white
            task.alpha = 0.8
            task.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

            resultsController.view.addSubview(task)
            y += 50.0
        }
    }
}
