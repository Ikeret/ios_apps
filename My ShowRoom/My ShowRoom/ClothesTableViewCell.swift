//
//  ClothesTableViewCell.swift
//  My ShowRoom
//
//  Created by Сергей Коршунов on 02.11.2019.
//  Copyright © 2019 Сергей Коршунов. All rights reserved.
//

import UIKit

class ClothesTableViewCell: UITableViewCell {

    @IBOutlet weak var photoView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
