//
//  CategoryCell.swift
//  Yelp
//
//  Created by Oscar Bonilla on 9/21/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categorySwitch: CustomSwitch!

    var item: Category? {
        didSet {
            categoryLabel.text = item?.name
        }
    }

    var onSwitchTapped: ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func switchTapped(_ sender: Any) {
            onSwitchTapped?(categorySwitch.isOn)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
