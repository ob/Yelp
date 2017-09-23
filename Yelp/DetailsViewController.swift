//
//  DetailsViewController.swift
//  Yelp
//
//  Created by Oscar Bonilla on 9/22/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var openNowLabel: UILabel!
    @IBOutlet weak var openingHoursLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!

    var business: Business?
    let regionRadius: CLLocationDistance = 1000


    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8288504481, green: 0.1372715533, blue: 0.1384659708, alpha: 1)
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let navigationTitleFont = UIFont(name: "Avenir", size: 20)!
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: navigationTitleFont]

        nameLabel.text = business?.name
        reviewsLabel.text = business?.prettyReviews()
        categoriesLabel.text = business?.categories
        if let url = business?.imageURL {
            businessImageView.setImageWith(url)
        }
        if let url = business?.ratingImageURL {
            ratingImageView.setImageWith(url)
        }
        if let latitude = business?.latitude,
            let longitude = business?.longitude {

            let initialLocation = CLLocation(latitude: latitude, longitude: longitude)
            centerMapOnLocation(location: initialLocation)
            mapView.addAnnotation(business!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
