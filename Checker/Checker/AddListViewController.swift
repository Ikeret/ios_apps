//
//  AddListViewController.swift
//  Checker
//
//  Created by Сергей Коршунов on 18/07/2019.
//  Copyright © 2019 Sergey Korshunov. All rights reserved.
//

import UIKit

class AddListViewController: UIViewController {

    @IBOutlet var textLabels: [UILabel]!
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    
    var currentColor = "Black"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        
    }
    
    @IBAction func AddList(_ sender: Any) {
        if nameTextField.text != "" {
            ListsArray.append(List(name: nameTextField.text!, category: categoryTextField.text!, color: currentColor))
            dismiss(animated: true, completion: nil)
        } else {
            let AlertController = UIAlertController(title: "Checker", message: "Name is required!", preferredStyle: .alert)
            let AlertActionOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
            AlertController.addAction(AlertActionOk)
            present(AlertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func CancelAdding(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension AddListViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Colors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Colors[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentColor = Colors[row]
        for label in textLabels {
            label.textColor = str2col(currentColor)
        }
    }
}
