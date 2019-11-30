//
//  GKContactListTableViewCell.swift
//  Go-jekContactsApp
//
//  Created by Mohit Mathur on 24/11/19.
//  Copyright © 2019 Mohit Mathur. All rights reserved.
//

import UIKit

class GKContactListTableViewCell: UITableViewCell {

    @IBOutlet weak var imgContact: UIImageView!
    
    @IBOutlet weak var imgFavourite: UIImageView!
    @IBOutlet weak var lblContactName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
