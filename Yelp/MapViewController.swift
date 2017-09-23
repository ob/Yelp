//
//  MapViewController.swift
//  Yelp
//
//  Created by Oscar Bonilla on 9/22/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, UISearchBarDelegate {
    var searchbar: UISearchBar!
    var filtersModel: FiltersViewModel!
    var businesses: [Business]!
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 1000

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8288504481, green: 0.1372715533, blue: 0.1384659708, alpha: 1)
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let navigationTitleFont = UIFont(name: "Avenir", size: 20)!
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: navigationTitleFont]
        searchbar = UISearchBar()
        searchbar.delegate = self
        searchbar.sizeToFit()
        navigationItem.titleView = searchbar
        let initialLocation = CLLocation(latitude: 37.785771, longitude: -122.406165)
        centerMapOnLocation(location: initialLocation)
        for business in businesses {
            mapView.addAnnotation(business)
        }

    }

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func didTapList(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nc = segue.destination as? UINavigationController,
            let vc = nc.viewControllers.first as? FilterViewController  {
            vc.filtersModel = filtersModel
//            vc.onSearch = {[weak self] in self?.doSearch()}
        }

    }

}
