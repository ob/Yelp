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
    @IBOutlet weak var categorySwitch: UISwitch!

    var item: Category? {
        didSet {
            categoryLabel.text = item?.name
        }
    }

    var onSwitchTapped: ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // This is super-lame
        categorySwitch.thumbTintColor = UIColor.init(patternImage: #imageLiteral(resourceName: "yelpcircle"))
        categorySwitch.onTintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }

    @IBAction func switchTapped(_ sender: Any) {
            onSwitchTapped?(categorySwitch.isOn)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
