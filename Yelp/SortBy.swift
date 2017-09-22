//
//  SortBy.swift
//  Yelp
//
//  Created by Oscar Bonilla on 9/21/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import Foundation

struct SortByOption {
    var index: Int
    var name: String
}

let SortByOptions: [SortByOption] = [
    SortByOption(index: 0, name: "Best Matched"),
    SortByOption(index: 1, name: "Distance"),
    SortByOption(index: 2, name: "Highest Rated"),
]
