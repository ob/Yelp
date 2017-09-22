//
//  FilterViewController.swift
//  Yelp
//
//  Created by Oscar Bonilla on 9/21/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var filtersModel: FiltersViewModel!
    var onSearch: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8288504481, green: 0.1372715533, blue: 0.1384659708, alpha: 1)
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let navigationTitleFont = UIFont(name: "Avenir", size: 20)!
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: navigationTitleFont]
        navigationController?.navigationBar.topItem?.title = "Filter"

        filtersModel.beginEditing()
        tableView.delegate = filtersModel
        tableView.dataSource = filtersModel
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        filtersModel.endEditing(commit: false)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchTapped(_ sender: Any) {
        filtersModel.endEditing(commit: true)
        onSearch?()
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
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
