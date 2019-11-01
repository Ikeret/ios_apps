//
//  CryptoSearchTableViewController.swift
//  CryptoSearch
//
//  Created by Сергей Коршунов on 31.10.2019.
//  Copyright © 2019 Сергей Коршунов. All rights reserved.
//

import UIKit

enum sortType {
    case liked
    case expensive
    case cheapest
    case growth
    case decline
    case rank
}

class CryptoSearchTableViewController: UITableViewController {
        
    
    var resultSearchController = UISearchController()
    
    var currentSortType = sortType.liked {
        didSet {
            data = sortData()
        }
    }
    
    var detailCoin: ParserObject!
    
    var data: [ParserObject] = []
    {
        didSet {
            tableView.reloadData()
        }
    }
    
    var filteredData: [ParserObject] = []
    {
        didSet {
            tableView.reloadData()
        }
    }
    
    @objc func refresh(sender:AnyObject)
    {
        serverRequest()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self

            controller.obscuresBackgroundDuringPresentation = false
            controller.searchBar.placeholder = "Search cryptocurrency"
            tableView.keyboardDismissMode = .onDrag
            if #available(iOS 11.0, *) {
                navigationItem.searchController = controller
            }
            definesPresentationContext = true
            return controller
        })()
        
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        serverRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func sortButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "Sort by", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(.init(title: "Liked", style: .default, handler: { (action) in
            self.currentSortType = .liked
        }))
        alert.addAction(.init(title: "Expensive", style: .default, handler: { (action) in
            self.currentSortType = .expensive
        }))
        alert.addAction(.init(title: "Cheapest", style: .default, handler: { (action) in
            self.currentSortType = .cheapest
        }))
        alert.addAction(.init(title: "Rank", style: .default, handler: { (action) in
            self.currentSortType = .rank
        }))
        alert.addAction(.init(title: "Growth", style: .default, handler: { (action) in
            self.currentSortType = .growth
        }))
        alert.addAction(.init(title: "Decline", style: .default, handler: { (action) in
            self.currentSortType = .decline
        }))
        
        alert.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    func serverRequest() {
        ServerManager.shared.tickerReguest(complition: {(serverArray) in
            self.data = serverArray
            self.data = self.sortData()
            self.refreshControl?.endRefreshing()
        })
    }
    
    func sortData() -> [ParserObject] {
        switch currentSortType {
        case .liked:
            return data.sorted { (obj1, obj2) -> Bool in
                return UserDefaults.standard.bool(forKey: obj1.coinName)
            }
        case .expensive:
            return data.sorted { return $0.coinPriceUSD > $1.coinPriceUSD }
        case .cheapest:
            return data.sorted { return $0.coinPriceUSD < $1.coinPriceUSD }
        case .growth:
            return data.sorted { return $0.coinWeeklyChange > $1.coinWeeklyChange }
        case .decline:
            return data.sorted { return $0.coinWeeklyChange < $1.coinWeeklyChange }
        case .rank:
            return data.sorted { return $0.coinRank < $1.coinRank }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if  resultSearchController.isActive {
            return filteredData.count
        } else {
            return data.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CurrencyTableViewCell
        
        if resultSearchController.isActive {
            cell.coinNameLabel.text = filteredData[indexPath.row].coinName
            cell.likeImage.isHidden = !UserDefaults.standard.bool(forKey: filteredData[indexPath.row].coinName)
            cell.coinPriceLabel.text! = String(filteredData[indexPath.row].coinPriceUSD)
        } else {
            cell.coinNameLabel.text = data[indexPath.row].coinName
            cell.likeImage.isHidden = !UserDefaults.standard.bool(forKey: data[indexPath.row].coinName)
            cell.coinPriceLabel.text! = String(data[indexPath.row].coinPriceUSD)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard tableView.refreshControl!.isRefreshing == false else {
            return
        }
        if resultSearchController.isActive {
            detailCoin = filteredData[indexPath.row]
        } else {
            detailCoin = data[indexPath.row]
        }
        
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDetail" {
            let destinationVC = segue.destination as! DetailViewController
            destinationVC.detailCoin = detailCoin
        }
    }
}

extension CryptoSearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        if searchText.isEmpty {
            filteredData = data
            return
        }
        filteredData = data.filter { $0.coinName.lowercased().contains(searchText.lowercased()) }
    }

}
