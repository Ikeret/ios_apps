//
//  ViewController.swift
//  Buying List
//
//  Created by Сергей Коршунов on 10/07/2019.
//  Copyright © 2019 Sergey Korshunov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    struct data_cell {
        var name : String?
        var count : UInt?
        var price : Double?
    }
    

    var data_arr : [data_cell] = []
//    {
//        set {
//
//
//            UserDefaults.standard.set(NSArray(object: newValue), forKey: "dataKey")
//            UserDefaults.standard.synchronize()
////            set_sum()
////            myTableView.reloadData()
//        }
//        get {
//            if let array = UserDefaults.standard.array(forKey: "dataKey") as NSArray? {
//                return array as! [ViewController.data_cell]
//            } else {
//                return []
//            }
//        }
//    }

    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var sum: UILabel!
    
    let identifier = "MyCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func set_sum() {
        var res = 0.0
        for item in data_arr {
            res += (item.price! * Double(item.count!))
        }
        sum.text = String(format: "%8.2f", res)
    }
    
    @IBAction func addCell(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add new item", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Count"
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Price"
        }
        
        let alertAction1 = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let alertAction2 = UIAlertAction(title: "Add", style: .cancel) { (alert) in
            if let name = alertController.textFields![0].text,
                let count : UInt = UInt(alertController.textFields![1].text!),
                let price : Double = Double(alertController.textFields![2].text!) {
                self.data_arr.append(data_cell(name: name, count: count, price: price))
                self.myTableView.reloadData()
                self.set_sum()
            }
        }
        
        alertController.addAction(alertAction1)
        alertController.addAction(alertAction2)
        present(alertController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func deleteCells(_ sender: UIBarButtonItem) {
        data_arr.removeAll()
        myTableView.reloadData()
        set_sum()
    }
}




extension ViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data_arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MyCustomCell = self.myTableView.dequeueReusableCell(withIdentifier: identifier) as! MyCustomCell

        let index = indexPath.row
        cell.name.text = data_arr[index].name
        if data_arr[index].count! != 1 {
            cell.count.text = "\(data_arr[index].count!)"
        }
        else {
            cell.count.text = ""
        }
        cell.price.text = String(format: "%6.2f", data_arr[index].price!)
        
        return cell;
    }
    
}
