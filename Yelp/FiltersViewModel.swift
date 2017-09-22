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
    func yelpAPIValue() -> AnyObject?
    func beginEditing() -> Void
    func endEditing(commit: Bool) -> Void
}

extension FiltersViewModelItem {
    var rowCount: Int {
        return 1
    }
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

    init(distances: [Distance]) {
        self.distances = distances
        if self.distances.count > 0 {
            self.selected = 0
        }
    }

    var rowCount: Int {
        return distances.count
    }

    var yelpAPIKey: String = "distance"

    func yelpAPIValue() -> AnyObject? {
        // The Yelp API doesn't seem to have a distance filter?
        return nil
    }

    func beginEditing() {
        oldSelected = selected
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

    var rowCount: Int {
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

    var rowCount: Int {
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
    }

    func endEditing(commit: Bool) {
        if !commit {
            selected = oldSelected
        }
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
                cell.item = item.distances[indexPath.row]
                if item.selected! == indexPath.row {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
                return cell
            }
        case .sortBy:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SortByCell", for: indexPath) as? SortByCell,
                let item = item as? FiltersViewModelSortByItem {
                cell.item = item.options[indexPath.row]
                if item.selected! == indexPath.row {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
                return cell
            }
        case .category:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as? CategoryCell,
                let item = item as? FiltersViewModelCategoriesItem {
                cell.item = item.categories[indexPath.row]
                cell.categorySwitch.isOn = item.selected[indexPath.row] ?? false
                cell.onSwitchTapped = {(isOn: Bool) in
                    item.selected[indexPath.row] = isOn
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
                if item.selected! != indexPath.row {
                    let ip = IndexPath(row: item.selected!, section: indexPath.section)
                    let selectedCell = tableView.cellForRow(at: ip)!
                    selectedCell.accessoryType = .none
                    cell.accessoryType = .checkmark
                    item.selected = indexPath.row
                }
            }
        case .sortBy:
            if let cell = tableView.cellForRow(at: indexPath) as? SortByCell,
                let item = item as? FiltersViewModelSortByItem {
                if item.selected != indexPath.row {
                    let ip = IndexPath(row: item.selected!, section: indexPath.section)
                    let selectedCell = tableView.cellForRow(at: ip)!
                    selectedCell.accessoryType = .none
                    cell.accessoryType = .checkmark
                    item.selected = indexPath.row
                }
            }
        case .category:
            return
        }
    }
}
