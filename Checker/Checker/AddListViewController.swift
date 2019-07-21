//
//  AddListViewController.swift
//  Checker
//
//  Created by Сергей Коршунов on 18/07/2019.
//  Copyright © 2019 Sergey Korshunov. All rights reserved.
//

import UIKit

class AddListViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var textLabels: [UILabel]!
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var topDoneButton: UIBarButtonItem!
    
    var currentColor = ""
    var editingListIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorButton.layer.cornerRadius = 5
        colorButton.layer.borderWidth = 0.1
        colorButton.layer.borderColor = UIColor.gray.cgColor
        
        doneButton.layer.cornerRadius = 5
        doneButton.layer.borderWidth = 0.1
        doneButton.layer.borderColor = UIColor.gray.cgColor
        
        viewContainer.layer.cornerRadius = 10
        viewContainer.layer.borderWidth = 0.1
        viewContainer.layer.borderColor = UIColor.gray.cgColor
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        if editingListIndex == nil {
            nameTextField.becomeFirstResponder()
        } else {
            setupEdition()
        }
    }
    
    func setupEdition() {
        let editingList = ListsArray[editingListIndex!]
        nameTextField.text = editingList.name
        categoryTextField.text = editingList.category
        currentColor = editingList.color
        if let color = str2col(editingList.color) {
            colorButton.setTitle(editingList.color, for: .normal)
            
            // MARK: Does'nt work
            colorButton.setTitleColor(color, for: .normal)

        }
        topDoneButton.isEnabled = true
        doneButton.isEnabled = true
    }
    
    
    @IBAction func AddList(_ sender: Any) {
        if !nameTextField.text!.strip().isEmpty {
            let newList = List(name: nameTextField.text!.strip(), category: categoryTextField.text!.strip(), color: currentColor)
            if editingListIndex != nil {
                let tasks = getListForName(ListsArray[editingListIndex!].name)
                SavedData.removeObject(forKey: ListsArray[editingListIndex!].name)
                setListForName(tasks, newList.name)
                
                
                ListsArray[editingListIndex!] = newList
                editingListIndex = nil
            }
            else {
                ListsArray.insert(newList, at: 0)
            }
            
            dismiss(animated: true, completion: nil)
        } else {
            let AlertController = UIAlertController(title: "Checker", message: "Name is required!", preferredStyle: .alert)
            let AlertActionOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
            AlertController.addAction(AlertActionOk)
            present(AlertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func changeColor(_ sender: Any) {
        presentColors()
    }
    
    @IBAction func CancelAdding(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
 
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == self.nameTextField, categoryTextField.text == "", nameTextField.text!.strip() != "" {
            self.categoryTextField.becomeFirstResponder()
        }
        if textField == self.categoryTextField, currentColor == "" {
            presentColors()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == nameTextField, range.lowerBound == 0  {
            let empty = !string.strip().isEmpty
            topDoneButton.isEnabled = empty
            doneButton.isEnabled = empty
        }
        return true
    }
    

    
    func presentColors() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for color in Colors {
            let colorAction = UIAlertAction(title: color, style: .default) { (action) in
                self.currentColor = color
                self.colorButton.setTitle(color, for: .normal)
                self.colorButton.setTitleColor(str2col(color), for: .normal)
            }
            if currentColor == color {
                colorAction.isEnabled = false
            }
            alertController.addAction(colorAction)
        }
        
        let defaultColorAction = UIAlertAction(title: "None", style: .default) { (action) in
            self.colorButton.setTitle("None", for: .normal)
            self.colorButton.setTitleColor(UIColor(named: "ColorScheme"), for: .normal)
            self.currentColor = "None"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(defaultColorAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}
