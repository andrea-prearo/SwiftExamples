//
//  Bookable.swift
//  Issues
//
//  Created by Prearo, Andrea on 10/6/17.
//

import Foundation

protocol Bookable {
    var identifier: String { get set }
    var startDate: Date { get set }
    var endDate: Date { get set }
}
