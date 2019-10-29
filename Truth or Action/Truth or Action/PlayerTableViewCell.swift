//
//  PlayerTableViewCell.swift
//  Truth or Action
//
//  Created by Сергей Коршунов on 29.10.2019.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
