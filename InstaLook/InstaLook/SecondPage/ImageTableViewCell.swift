//
//  ImageTableViewCell.swift
//  InstaLook
//
//  Created by Сергей Коршунов on 30.10.2019.
//  Copyright © 2019 Сергей Коршунов. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var imageCell: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
