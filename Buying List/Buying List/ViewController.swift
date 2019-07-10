//
//  ViewController.swift
//  Buying List
//
//  Created by Сергей Коршунов on 10/07/2019.
//  Copyright © 2019 Sergey Korshunov. All rights reserved.
//

import UIKit

class ViewController: UIViewController{ //UITableViewDelegate, UITableViewDataSource {
    struct data_cell {
        var name : String?
        var count : UInt?
        var price : Double?
    }
    
    var data_arr : [data_cell] = [data_cell.init(name: "Лапша столичная", count: 20, price: 35.90)]

    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var sum: UILabel!
    
    let identifier = "MyCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        set_sum()
    }
    
    func set_sum() {
        var res = 0.0
        for item in data_arr {
            res += (item.price! * Double(item.count!))
        }
        sum.text = String(format: "%8.2f", res)
    }
    
    @IBAction func addCell(_ sender: UIBarButtonItem) {
        data_arr.append(data_cell.init(name: "Хлеб", count: 1, price: 9999.99))
        myTableView.beginUpdates()
        myTableView.insertRows(at: [IndexPath(row: data_arr.count - 1, section: 0)], with: .automatic)
        myTableView.endUpdates()
        set_sum()
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
