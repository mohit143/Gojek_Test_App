//
//  GKContactDetailTableViewCell.swift
//  Go-jekContactsApp
//
//  Created by Mohit Mathur on 24/11/19.
//  Copyright © 2019 Mohit Mathur. All rights reserved.
//

import UIKit

class GKContactDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var txtInput: GKInputView!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
