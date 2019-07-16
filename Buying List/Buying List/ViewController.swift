//
//  ViewController.swift
//  Buying List
//
//  Created by Сергей Коршунов on 10/07/2019.
//  Copyright © 2019 Sergey Korshunov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    struct data_cell : Codable {
        var name : String?
        var count : UInt?
        var price : Double?
    }
    
    
    var dataArray : [data_cell] //= []
    {
        set {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: "dataKey")
            UserDefaults.standard.synchronize()
            set_sum()
            myTableView.reloadData()
        }
        get {
            if let data = UserDefaults.standard.value(forKey: "dataKey") as? Data  {
                let array = (try? PropertyListDecoder().decode(Array<data_cell>.self, from: data))!
                return array
            } else {
                return []
            }
        }
    }
    
    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var sum: UILabel!
    
    let identifier = "MyCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        set_sum()
    }
    
    func set_sum() {
        var res = 0.0
        for item in dataArray {
            res += (item.price! * Double(item.count!))
        }
        sum.text = String(format: "%8.2f", res)
    }
    
    @IBAction func editTable(_ sender: Any) {
        myTableView.isEditing = !myTableView.isEditing
    }
    
    @IBAction func addCell(_ sender: UIBarButtonItem) {
        myTableView.isEditing = false
        let alertController = UIAlertController(title: "Add new item", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Name (required)"
            textField.autocapitalizationType = .words
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Price (optional)"
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Count (optional)"
        }
        
        
        let alertAction1 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let alertAction2 = UIAlertAction(title: "Add", style: .default) { (alert) in
            if let name = alertController.textFields![0].text, name != "" {
                let count = UInt(alertController.textFields![2].text!) ?? 1
                let price = Double(alertController.textFields![1].text!) ?? 0.0
                self.dataArray.append(data_cell(name: name, count: count, price: price))
            }
            
        }
        
        alertController.addAction(alertAction1)
        alertController.addAction(alertAction2)
        present(alertController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func deleteCells(_ sender: UIBarButtonItem) {
        let alertController =  UIAlertController(title: "Clear all items?", message: nil, preferredStyle: .actionSheet)
        let alertActionClear = UIAlertAction(title: "Clear", style: .destructive) { (alert) in
            self.dataArray.removeAll()
        }
        let alertActionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(alertActionClear)
        alertController.addAction(alertActionCancel)
        present(alertController, animated: true, completion: nil)
        
    }
}




extension ViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MyCustomCell = self.myTableView.dequeueReusableCell(withIdentifier: identifier) as! MyCustomCell
        
        let index = indexPath.row
        let name = dataArray[index].name
        let count = dataArray[index].count!
        let price = dataArray[index].price!
        
        cell.name.text = name
        
        if count != 1 {
            cell.count.text = "\(count)"
        } else {
            cell.count.text = ""
        }
        
        if price != 0.0 {
            cell.price.text = String(format: "%6.2f", price)
        } else {
            cell.price.text = ""
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataArray.remove(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = dataArray[sourceIndexPath.row]
        dataArray.remove(at: sourceIndexPath.row)
        dataArray.insert(item, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let current_item = dataArray[indexPath.row]
        
        let alertController = UIAlertController(title: "Edit item", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Name (required)"
            textField.autocapitalizationType = .words
            textField.text = current_item.name
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Price (optional)"
            if current_item.price != 0.0 {
                textField.text = "\(current_item.price!)"
            }
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Count (optional)"
            if current_item.count != 1 {
                textField.text = "\(current_item.count!)"
            }
        }
        
        
        let alertAction1 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let alertAction2 = UIAlertAction(title: "Done", style: .default) { (alert) in
            if let name = alertController.textFields![0].text {
                let count = UInt(alertController.textFields![2].text!) ?? 1
                let price = Double(alertController.textFields![1].text!) ?? 0.0
                self.dataArray[indexPath.row] = data_cell(name: name, count: count, price: price)
            }
        }
        
        alertController.addAction(alertAction1)
        alertController.addAction(alertAction2)
        present(alertController, animated: true, completion: nil)
        myTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
}
