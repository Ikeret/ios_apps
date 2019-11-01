//
//  DetailViewController.swift
//  CryptoSearch
//
//  Created by Сергей Коршунов on 31.10.2019.
//  Copyright © 2019 Сергей Коршунов. All rights reserved.
//

import UIKit
import SPAlert

class DetailViewController: UIViewController {
    
    var detailCoin: ParserObject!

    @IBOutlet weak var likeButtonOutlet: UIButton!
    
    @IBOutlet weak var coinPriceLabel: UILabel!
    
    @IBOutlet weak var USDTextField: UITextField!
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var currencyLabel: UILabel!
    
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var weeklyChangeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isLiked = UserDefaults.standard.bool(forKey: detailCoin.coinName)
        setImageForLikeButton(isLiked: isLiked, animated: false)
        
        navigationItem.title = detailCoin.coinName
        coinPriceLabel.text = String(detailCoin.coinPriceUSD) + " USD"
        
        USDTextField.delegate = self
        currencyTextField.delegate = self
        currencyLabel.text = detailCoin.coinSymbol
        
        symbolLabel.text = detailCoin.coinSymbol
        rankLabel.text = String(detailCoin.coinRank)
        weeklyChangeLabel.text = String(detailCoin.coinWeeklyChange) + " %"
        
    }
    
    @IBAction func likeButtonAction(_ sender: UIButton) {
        let isLiked = !UserDefaults.standard.bool(forKey: detailCoin.coinName)
        UserDefaults.standard.set(isLiked, forKey: detailCoin.coinName)
        
        setImageForLikeButton(isLiked: isLiked, animated: true)
    }
    
    func setImageForLikeButton(isLiked: Bool, animated: Bool) {
        if !isLiked {
            likeButtonOutlet.setImage(UIImage(named: "unlike"), for: .normal)
            if animated {
                SPAlert.present(title: "Unliked", preset: .done)
            }
        } else {
            likeButtonOutlet.setImage(UIImage(named: "like"), for: .normal)
            if animated {
                SPAlert.present(title: "Liked", preset: .heart)
            }
        }
        
    }
    
}

extension DetailViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldString = textField.text! + string
        
        guard let number = Double(textFieldString) else {
            return false
        }
        
        if textField == USDTextField {
            currencyTextField.text = "\(number / detailCoin.coinPriceUSD)"
        } else if textField == currencyTextField {
            USDTextField.text = "\(detailCoin.coinPriceUSD * number)"
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
