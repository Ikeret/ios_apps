//
//  ListTableViewCell.swift
//  Checker
//
//  Created by Сергей Коршунов on 20/07/2019.
//  Copyright © 2019 Sergey Korshunov. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var frameView: UIView!
    @IBOutlet weak var colorIndicator: UIView!
    
    @IBOutlet weak var topConstrain: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        colorIndicator.layer.cornerRadius = 5
        
        frameView.layer.cornerRadius = 30
        frameView.layer.borderWidth = 1
        frameView.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
