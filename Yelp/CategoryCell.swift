//
//  CategoryCell.swift
//  Yelp
//
//  Created by Oscar Bonilla on 9/21/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

// https://stackoverflow.com/questions/42545955/scale-image-to-smaller-size-in-swift3
extension UIImage{

    func resizeImageWith(newSize: CGSize) -> UIImage {
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height

        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

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
        let size = 44
        let img = #imageLiteral(resourceName: "yelpcircle").resizeImageWith(newSize: CGSize(width: size, height: size))
        categorySwitch.thumbTintColor = UIColor.init(patternImage: img)
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
