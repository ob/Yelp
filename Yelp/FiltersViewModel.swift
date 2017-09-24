//
//  ViewModel.swift
//  Yelp
//
//  Created by Oscar Bonilla on 9/21/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import Foundation
import UIKit

enum FiltersViewModelItemType {
    case deals
    case distance
    case sortBy
    case category
}


protocol FiltersViewModelItem {
    var type: FiltersViewModelItemType { get }
    var rowCount: Int { get }
    var sectionTitle: String? { get }
    var yelpAPIKey: String { get }
    var collapsed: Bool { get }
    func yelpAPIValue() -> AnyObject?
    func beginEditing() -> Void
    func endEditing(commit: Bool) -> Void
}

class FiltersViewModelDealsItem: FiltersViewModelItem {
    var type: FiltersViewModelItemType {
        return .deals
    }

    var sectionTitle: String? {
        // Deals have no section title
        return nil
    }
    var value: Bool
    var oldValue: Bool

    init(value: Bool) {
        self.value = value
        self.oldValue = value
    }

    var yelpAPIKey: String = "deals_filter"

    func yelpAPIValue() -> AnyObject? {
        return value as AnyObject
    }

    func beginEditing() {
        oldValue = value
    }

    func endEditing(commit: Bool) {
        if !commit {
            value = oldValue
        }
    }

    var rowCount: Int = 1
    var collapsed: Bool = false
}

class FiltersViewModelDistanceItem: FiltersViewModelItem {
    var type: FiltersViewModelItemType {
        return .distance
    }

    var sectionTitle: String? {
        return "Distance"
    }

    var distances: [Distance]
    var selected: Int?
    var oldSelected: Int?

    var collapsed: Bool = true

    init(distances: [Distance]) {
        self.distances = distances
        if self.distances.count > 0 {
            self.selected = 0
        }
    }

    var rowCount: Int {
        if collapsed {
            return 1
        }
        return distances.count
    }

    var yelpAPIKey: String = "distance"

    func yelpAPIValue() -> AnyObject? {
        // The Yelp API doesn't seem to have a distance filter?
        return nil
    }

    func beginEditing() {
        oldSelected = selected
        collapsed = true
    }

    func endEditing(commit: Bool) {
        if !commit {
            selected = oldSelected
        }
    }
}

class FiltersViewModelSortByItem: FiltersViewModelItem {
    var type: FiltersViewModelItemType {
        return .sortBy
    }

    var sectionTitle: String? {
        return "Sort By"
    }

    var options: [SortByOption]
    var selected: Int?
    var oldSelected: Int?

    init(options: [SortByOption]) {
        self.options = options
        if self.options.count > 0 {
            self.selected = 0
        }
    }

    var collapsed: Bool = true
    var rowCount: Int {
        if collapsed {
            return 1
        }
        return options.count
    }

    var yelpAPIKey: String = "sort"

    func yelpAPIValue() -> AnyObject? {
        guard options.count > 1 else {
            return nil
        }
        guard let selected = selected else {
            return nil
        }
        return options[selected].index as AnyObject
    }

    func beginEditing() {
        oldSelected = selected
        collapsed = true
    }

    func endEditing(commit: Bool) {
        if !commit {
            selected = oldSelected
        }
    }
}

class FiltersViewModelCategoriesItem: FiltersViewModelItem {
    var type: FiltersViewModelItemType {
        return .category
    }

    var sectionTitle: String? {
        return "Categories"
    }

    var categories: [Category]
    var selected: [Int:Bool]
    var oldSelected: [Int:Bool]

    init(categories: [Category]) {
        self.categories = categories
        self.selected = [Int:Bool]()
        self.oldSelected = selected
    }

    var collapsed: Bool = true
    var barrier: Int = 3 // How many cells to show in collapsed mode

    var rowCount: Int {
        if collapsed {
            return barrier + 1
        }
        return categories.count
    }

    var yelpAPIKey: String = "category_filter"

    func yelpAPIValue() -> AnyObject? {
        guard categories.count > 0 else {
            return nil
        }
        var selectedCategories:[Category] = []
        for (k,v) in selected {
            if v {
                selectedCategories.append(categories[k])
            }
        }
        let categoryNames = selectedCategories.map { $0.code }
        if categoryNames.count > 0 {
            return categoryNames.joined(separator: ",") as AnyObject
        }
        return nil
    }

    func beginEditing() {
        oldSelected = selected
        collapsed = true
    }

    func endEditing(commit: Bool) {
        if !commit {
            selected = oldSelected
        }
    }

    func countHiddenOptions() -> Int {
        var count = 0
        for (k, v) in selected {
            if k >= barrier  && v {
                count += 1
            }
        }
        return count
    }
}

class FiltersViewModel: NSObject {
    var items = [FiltersViewModelItem]()

    override init() {
        super.init()
        items = [
            FiltersViewModelDealsItem(value: false),
            FiltersViewModelDistanceItem(distances: Distances),
            FiltersViewModelSortByItem(options: SortByOptions),
            FiltersViewModelCategoriesItem(categories: Categories),
        ]
    }

    func beginEditing() {
        for item in items {
            item.beginEditing()
        }
    }

    func endEditing(commit: Bool) {
        for item in items {
            item.endEditing(commit: commit)
        }
    }

    func moreImageView() -> UIImageView {
        let ret = UIImageView(frame: CGRect(x: 12, y: 12, width: 12, height: 12))
        ret.contentMode = .scaleAspectFit
        ret.image = #imageLiteral(resourceName: "down-arrow")
        return ret
    }

    func checkCell(cell: UITableViewCell) {
        let imgView = UIImageView(frame: CGRect(x: 12, y: 12, width: 12, height: 12))
        imgView.contentMode = .scaleAspectFit
        imgView.image = #imageLiteral(resourceName: "circle-full").withRenderingMode(.alwaysTemplate)
        imgView.tintColor = #colorLiteral(red: 0.8288504481, green: 0.1372715533, blue: 0.1384659708, alpha: 1)
        cell.accessoryView = imgView
    }

    func uncheckCell(cell: UITableViewCell) {
        let imgView = UIImageView(frame: CGRect(x: 12, y:12, width: 12, height: 12))
        imgView.contentMode = .scaleAspectFit
        imgView.image = #imageLiteral(resourceName: "circle-empty").withRenderingMode(.alwaysTemplate)
        imgView.tintColor = #colorLiteral(red: 0.8288504481, green: 0.1372715533, blue: 0.1384659708, alpha: 1)
        cell.accessoryView = imgView
    }

}

extension FiltersViewModel: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        switch item.type {
        case .deals:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DealCell", for: indexPath) as? DealCell,
                let item = item as? FiltersViewModelDealsItem {
                cell.item = item
                return cell
            }
        case .distance:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DistanceCell", for: indexPath) as? DistanceCell,
                let item = item as? FiltersViewModelDistanceItem {
                if item.collapsed && indexPath.row == 0 {
                    cell.item = item.distances[item.selected!]
                    cell.accessoryView = moreImageView()
                } else {
                    cell.item = item.distances[indexPath.row]
                    if item.selected! == indexPath.row {
                        checkCell(cell: cell)
                    } else {
                        uncheckCell(cell: cell)
                    }
                }
                return cell
            }
        case .sortBy:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SortByCell", for: indexPath) as? SortByCell,
                let item = item as? FiltersViewModelSortByItem {
                if item.collapsed && indexPath.row == 0 {
                    cell.item = item.options[item.selected!]
                    cell.accessoryView = moreImageView()
                } else {
                    cell.item = item.options[indexPath.row]
                    if item.selected! == indexPath.row {
                        checkCell(cell: cell)
                    } else {
                        uncheckCell(cell: cell)
                    }
                }
                return cell
            }
        case .category:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as? CategoryCell,
                let item = item as? FiltersViewModelCategoriesItem {
                if item.collapsed && indexPath.row == item.barrier {
                    print("Barrier mode")
                    let cell = UITableViewCell()
                    let hiddenOptions = item.countHiddenOptions()
                    if hiddenOptions > 0 {
                        cell.textLabel?.text = String(format: "See More (%d selected)", hiddenOptions)
                    } else {
                        cell.textLabel?.text = "See More"
                    }
                    cell.textLabel?.textAlignment = .center
                    return cell
                } else {
                    cell.item = item.categories[indexPath.row]
                    cell.categorySwitch.isOn = item.selected[indexPath.row] ?? false
                    cell.onSwitchTapped = {(isOn: Bool) in
                        item.selected[indexPath.row] = isOn
                    }
                }
                return cell
            }
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return items[section].sectionTitle
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.section]
        switch item.type {
        case .deals:
            return
        case .distance:
            if let cell = tableView.cellForRow(at: indexPath) as? DistanceCell,
                let item = item  as? FiltersViewModelDistanceItem {
                if item.collapsed && indexPath.row == 0 {
                    cell.accessoryView = nil
                    item.collapsed = false
                    tableView.reloadSections([indexPath.section], with: .automatic)
                } else {
                    if item.selected! != indexPath.row {
                        let ip = IndexPath(row: item.selected!, section: indexPath.section)
                        let selectedCell = tableView.cellForRow(at: ip)!
                        uncheckCell(cell: selectedCell)
                        checkCell(cell: cell)
                        item.selected = indexPath.row
                        item.collapsed = true
                        tableView.reloadSections([indexPath.section], with: .automatic)
                    }
                }
            }
        case .sortBy:
            if let cell = tableView.cellForRow(at: indexPath) as? SortByCell,
                let item = item as? FiltersViewModelSortByItem {
                if item.collapsed && indexPath.row == 0 {
                    cell.accessoryView = nil
                    item.collapsed = false
                    tableView.reloadSections([indexPath.section], with: .automatic)
                } else {
                    if item.selected != indexPath.row {
                        let ip = IndexPath(row: item.selected!, section: indexPath.section)
                        let selectedCell = tableView.cellForRow(at: ip)!
                        uncheckCell(cell: selectedCell)
                        checkCell(cell: cell)
                        item.selected = indexPath.row
                        item.collapsed = true
                        tableView.reloadSections([indexPath.section], with: .automatic)
                    }
                }
            }
        case .category:
            if let item = item as? FiltersViewModelCategoriesItem {
                if item.collapsed && indexPath.row == item.barrier {
                    item.collapsed = false
                    tableView.reloadSections([indexPath.section], with: .automatic)
                }
            }
            return
        }
    }
}
