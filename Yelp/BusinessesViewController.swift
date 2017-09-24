//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

let DEFAULT_QUERY = "Restaurants"

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var listMapButton: UIBarButtonItem!

    var searchbar: UISearchBar!
    var timer = Timer()
    var query: String = DEFAULT_QUERY

    var businesses: [Business]?
    var filtersModel: FiltersViewModel = FiltersViewModel()

    var isDataLoading = false
    var spinner: UIActivityIndicatorView?
    var offset = 0
    var limit = 20
    var totalResults = 0
    let regionRadius: CLLocationDistance = 1000

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

        spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner!.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44)
        tableView.tableFooterView = spinner

        searchbar = UISearchBar()
        searchbar.delegate = self
        searchbar.sizeToFit()
        navigationItem.titleView = searchbar

        listMapButton.title = "Map"

        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8288504481, green: 0.1372715533, blue: 0.1384659708, alpha: 1)
        let initialLocation = CLLocation(latitude: 37.785771, longitude: -122.406165)
        centerMapOnLocation(location: initialLocation)
        doSearch()
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

    // MARK: - Search bar delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        query = searchbar.text ?? query
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(BusinessesViewController.doSearch), userInfo: searchbar.text, repeats: false)

    }
    
    @objc fileprivate func doSearch() {
        if query == "" {
            query = DEFAULT_QUERY
        }
        isDataLoading = true
        offset = 0
        Business.searchWithTerm(term: query,
                                filterModel: filtersModel,
                                offset: offset,
                                limit: limit,
                                completion: { [weak self] (businesses: [Business]?, results: Int?, error: Error?) -> Void in
                                    self?.isDataLoading = false
                                    self?.totalResults = results!
                                    self?.businesses = businesses
                                    self?.tableView.reloadData()
                                    if let annotations = self?.mapView.annotations {
                                        self?.mapView.removeAnnotations(annotations)
                                    }
                                    if let businessList = self?.businesses {
                                        for business in businessList {
                                            self?.mapView.addAnnotation(business)
                                        }
                                    }
        })
    }

    fileprivate func moreData() {
        offset = offset + limit
        guard offset < totalResults else {
            return
        }
        isDataLoading = true
        spinner?.startAnimating()
        Business.searchWithTerm(term: query,
                                filterModel: filtersModel,
                                offset: offset,
                                limit: limit,
                                completion: { [weak self] (businesses: [Business]?, results: Int?, error: Error?) -> Void in
                                    self?.isDataLoading = false
                                    self?.spinner?.stopAnimating()
                                    self?.totalResults = results!
                                    if let businesses = businesses {
                                        self?.businesses?.append(contentsOf: businesses)
                                        self?.tableView.reloadData()
                                    }
        })
    }
    
     // MARK: - Navigation
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nc = segue.destination as? UINavigationController,
            let vc = nc.viewControllers.first as? FilterViewController  {
            vc.filtersModel = filtersModel
            vc.onSearch = {[weak self] in self?.doSearch()}
        }
        if let vc = segue.destination as? DetailsViewController,
            let indexPath = tableView.indexPath(for: sender as! BusinessCell),
            let currentBusiness = businesses?[indexPath.row] {
            vc.business = currentBusiness
        }
    }

    // MARK: - tableView data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let businesses = businesses {
            return businesses.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell

        cell.business = businesses![indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == businesses!.count - 1) && !isDataLoading {
            moreData()
        }
    }
    @IBAction func didTapListMapButton(_ sender: Any) {
        if listMapButton.title == "Map" {
            listMapButton.title = "List"
            UIView.transition(from: tableView, to: mapView, duration: 0.5, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        } else {
            listMapButton.title = "Map"
            UIView.transition(from: mapView, to: tableView, duration: 0.5, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
    }

}
