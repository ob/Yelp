//
//  BusinessCell.swift
//  Yelp
//
//  Created by Oscar Bonilla on 9/21/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    var business: Business! {
        didSet {
            nameLabel.text = business.name
            distanceLabel.text = business.distance
            if let reviews = business.reviewCount {
                reviewsCountLabel.text = String(format: "%d Reviews", reviews)
            } else {
                reviewsCountLabel.text = ""
            }
            addressLabel.text = business.address
            categoriesLabel.text = business.categories
            if let url = business.imageURL {
                thumbImageView.setImageWith(url)
            } else {
                // XXX: PLACEHOLDER IMAGE HERE
            }
            if let ratingURL = business.ratingImageURL {
                ratingImageView.setImageWith(ratingURL)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbImageView.layer.cornerRadius = 5
        thumbImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
