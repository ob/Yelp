//
//  DealCell.swift
//  Yelp
//
//  Created by Oscar Bonilla on 9/21/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class DealCell: UITableViewCell {

    @IBOutlet weak var dealLabel: UILabel!
    var dealSwitch: CustomSwitch!

    var item: FiltersViewModelDealsItem? {
        didSet {
            dealSwitch.isOn = (item?.value)!
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dealSwitch = CustomSwitch(frame: CGRect(x: 50, y: 50, width: 50, height: 30))
        let margins = self.contentView.layoutMarginsGuide
        let dealLabelMargins = self.dealLabel!.layoutMarginsGuide
        self.contentView.addSubview(dealSwitch!)
        dealSwitch!.leadingAnchor.constraint(lessThanOrEqualTo: dealLabelMargins.trailingAnchor).isActive = true
        dealSwitch!.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        dealSwitch!.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
    }

    @IBAction func onTap(_ sender: Any) {
        item?.value = dealSwitch.isOn
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
