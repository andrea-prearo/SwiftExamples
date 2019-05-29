//
//  BookingFetchable.swift
//  Solution
//
//  Created by Prearo, Andrea on 10/6/17.
//

import Foundation

protocol BookingFetchable {
    func fetch(completionBlock: @escaping ([Bookable]) -> Void)
}

