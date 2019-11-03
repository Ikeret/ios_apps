//
//  ViewController.swift
//  Qreator
//
//  Created by Сергей Коршунов on 03.11.2019.
//  Copyright © 2019 Сергей Коршунов. All rights reserved.
//

import UIKit
import SPAlert

class ViewController: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var mainTextField: UITextField!
    @IBOutlet weak var secondaryTextField: UITextField!
    @IBOutlet weak var pickImageButton: UIButton!
    
    var currentType: QRtype = .url
    var withBackgroundImage = true
    var pickedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTextField.delegate = self
        secondaryTextField.delegate = self

        pickImageButton.layer.borderWidth = 2
        pickImageButton.layer.borderColor = UIColor.red.cgColor
        pickImageButton.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }

    @IBAction func buttonAction(_ sender: Any) {
        if mainTextField.text!.isEmpty {
            showAlert(message: NSLocalizedString("You must fill in all fields.", comment: ""))
        } else if currentType == .sms && secondaryTextField.text!.isEmpty {
            showAlert(message: NSLocalizedString("You must fill in all fields.", comment: ""))
        } else if withBackgroundImage && pickedImage == nil {
            showAlert(message: NSLocalizedString("You must choose a picture.", comment: ""))
        } else {
            performSegue(withIdentifier: "showResult", sender: self)
        }
    }
    
    @IBAction func segmentControlAction(_ sender: UISegmentedControl) {
        currentType = QRtype(rawValue: sender.selectedSegmentIndex)!
        
        
        if currentType == .sms {
            UIView.animate(withDuration: 0.4) {
                self.secondaryTextField.alpha = 1
                self.secondaryTextField.isHidden = false
            }
        } else if !secondaryTextField.isHidden {
            UIView.animate(withDuration: 0.4) {
                self.secondaryTextField.isHidden = true
                self.secondaryTextField.alpha = 0
            }
        }
        

        
        switch currentType {
        case .url:
            mainTextField.placeholder = NSLocalizedString("Enter URL", comment: "")
        case .contact:
            mainTextField.placeholder = NSLocalizedString("Enter number", comment: "")
        case .text:
            mainTextField.placeholder = NSLocalizedString("Enter text", comment: "")
        case .sms:
            mainTextField.placeholder = NSLocalizedString("Enter number", comment: "")
        }
    }
    
    @IBAction func switchAction(_ sender: UISwitch) {
        if sender.isOn {
            withBackgroundImage = true
            UIView.animate(withDuration: 0.4) {
                self.pickImageButton.alpha = 1
                self.pickImageButton.isHidden = false
            }
        } else {
            withBackgroundImage = false
            UIView.animate(withDuration: 0.4) {
                self.pickImageButton.isHidden = true
                self.pickImageButton.alpha = 0
            }
        }
    }
    
    @IBAction func pickImageAction(_ sender: Any) {
        let alert = UIAlertController(title: NSLocalizedString("Choose the source", comment: ""), message: nil, preferredStyle: .actionSheet)
        alert.addAction(.init(title: NSLocalizedString("Camera", comment: ""), style: .default, handler: { (action) in
            #if !targetEnvironment(simulator)
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera
            picker.allowsEditing = true
            self.present(picker, animated: true)
            #endif
        }))
        alert.addAction(.init(title: NSLocalizedString("Photo Library", comment: ""), style: .default, handler: { (action) in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            self.present(picker, animated: true)
        }))
        alert.addAction(.init(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Qreator", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResult" {
            let destinationVC = segue.destination as! ResultViewController
            destinationVC.currentType = currentType
            destinationVC.mainText = mainTextField.text
            if currentType == .sms {
                destinationVC.secondaryText = secondaryTextField.text
            }
            destinationVC.withBackgroundImage = withBackgroundImage
            if withBackgroundImage {
                destinationVC.pickedImage = pickedImage
            }
        }
    }
    
}

extension ViewController: UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            pickedImage = image
            SPAlert.present(title: NSLocalizedString("Done", comment: ""), preset: .done)
            dismiss(animated: true, completion: nil)
            pickImageButton.setTitle(NSLocalizedString("Image picked", comment: ""), for: .normal)
        }
    }
    
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

