//
//  Business.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class Business: NSObject {
    let id: String?
    let name: String?
    let address: String?
    let imageURL: URL?
    let categories: String?
    let distance: String?
    let ratingImageURL: URL?
    let reviewCount: NSNumber?
    let latitude: String?
    let longitude: String?
    // more info fields
    var bigRatingImageURL: URL?

    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        id = dictionary["id"] as? String
        
        let imageURLString = dictionary["image_url"] as? String
        if imageURLString != nil {
            imageURL = URL(string: imageURLString!)!
        } else {
            imageURL = nil
        }
        
        let location = dictionary["location"] as? NSDictionary
        var address = ""
        var latitude: String? = nil
        var longitude: String? = nil
        if location != nil {
            let addressArray = location!["address"] as? NSArray
            if addressArray != nil && addressArray!.count > 0 {
                address = addressArray![0] as! String
            }
            
            let neighborhoods = location!["neighborhoods"] as? NSArray
            if neighborhoods != nil && neighborhoods!.count > 0 {
                if !address.isEmpty {
                    address += ", "
                }
                address += neighborhoods![0] as! String
            }
            if let coordinate = location!["coordinate"] as? NSDictionary {
                latitude = coordinate["latitude"] as? String
                longitude = coordinate["longitude"] as? String
            }

        }
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        
        let categoriesArray = dictionary["categories"] as? [[String]]
        if categoriesArray != nil {
            var categoryNames = [String]()
            for category in categoriesArray! {
                let categoryName = category[0]
                categoryNames.append(categoryName)
            }
            categories = categoryNames.joined(separator: ", ")
        } else {
            categories = nil
        }
        
        let distanceMeters = dictionary["distance"] as? NSNumber
        if distanceMeters != nil {
            let milesPerMeter = 0.000621371
            distance = String(format: "%.2f mi", milesPerMeter * distanceMeters!.doubleValue)
        } else {
            distance = nil
        }
        
        let ratingImageURLString = dictionary["rating_img_url_large"] as? String
        if ratingImageURLString != nil {
            ratingImageURL = URL(string: ratingImageURLString!)
        } else {
            ratingImageURL = nil
        }
        
        reviewCount = dictionary["review_count"] as? NSNumber
    }

    func moreDetails(completion: @escaping () -> Void) {
        _ = YelpClient.sharedInstance.detailsForBusiness(id: id!, completion: { [weak self] (dictionary: [String: Any]?, error: Error?) in
            guard error == nil else {
                return
            }
            if let bigImageURLString = dictionary?["ratin_image_url"] as? String,
                let url = URL(string: bigImageURLString) {
                self?.bigRatingImageURL = url
            }
            completion()
        })
    }
    
    class func businesses(array: [NSDictionary]) -> [Business] {
        var businesses = [Business]()
        for dictionary in array {
            let business = Business(dictionary: dictionary)
            businesses.append(business)
        }
        return businesses
    }

    class func searchWithTerm(term: String, filterModel: FiltersViewModel, offset: Int?, limit: Int?, completion: @escaping ([Business]?, Int?, Error?) -> Void) {
        _ = YelpClient.sharedInstance.searchWithTerm(term, filterModel: filterModel, offset: offset, limit: limit, completion: completion)
    }

    func prettyReviews() -> String {
        guard let reviewCount = reviewCount else {
            return ""
        }
        return String(format: "%d Reviews", reviewCount)
    }
}
