//
//  Distance.swift
//  Yelp
//
//  Created by Oscar Bonilla on 9/21/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import Foundation

struct Distance {
    var distance: Double?
    var description: String {
        guard let d = distance else {
            return "Best Match"
        }
        if (abs(1.0 - d) < 0.000001) {
            return "1 mile"
        }
        if d.truncatingRemainder(dividingBy: 1.0) == 0 {
            return String(format: "%.0f miles", d)
        }
        return String(format: "%.1f miles", d)
    }
}

let Distances = [
    Distance(distance: nil),
    Distance(distance: 0.3),
    Distance(distance: 1.0),
    Distance(distance: 5.0),
    Distance(distance: 20.0),
]
