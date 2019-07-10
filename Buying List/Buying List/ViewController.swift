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
    
    var data_arr : [data_cell] = [data_cell.init(name: "Молоко", count: 2, price: 35.90)]

    @IBOutlet weak var myTableView: UITableView!
    
    
    let identifier = "MyCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        cell.count.text = String(data_arr[index].count!)
        cell.price.text = String(data_arr[index].price!)
        
        return cell;
    }
    
    
}
