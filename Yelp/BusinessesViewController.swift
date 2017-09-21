//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

let DEFAULT_QUERY = "Restaurants"

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchbar: UISearchBar!
    var timer = Timer()

    var businesses: [Business]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        searchbar = UISearchBar()
        searchbar.delegate = self
        searchbar.sizeToFit()
        navigationItem.titleView = searchbar
        
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)

        Business.searchWithTerm(term: DEFAULT_QUERY, completion: { [weak self] (businesses: [Business]?, error: Error?) -> Void in

            self?.businesses = businesses
            self?.tableView.reloadData()
            
        })
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Search bar delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchbar.text
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(BusinessesViewController.doSearch), userInfo: searchText, repeats: false)

    }
    
    @objc fileprivate func doSearch() {
        guard var query = timer.userInfo as? String else {
            return
        }
        if query == "" {
            query = DEFAULT_QUERY
        }
        Business.searchWithTerm(term: query, completion: { [weak self] (businesses: [Business]?, error: Error?) -> Void in
            
            self?.businesses = businesses
            self?.tableView.reloadData()
        })
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

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
}
