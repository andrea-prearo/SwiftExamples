//
//  RentalBookingFetcher.swift
//  Issues
//
//  Created by Prearo, Andrea on 10/6/17.
//

import Foundation

struct RentalBookingFetcher: Fetchable {
    typealias DataType = RentalBooking
    
    func fetch(completionBlock: @escaping ([RentalBooking]?) -> Void) {
        guard let jsonData = JSONHelper.loadJsonDataFromFile("rentalBookings"),
            let bookings = RentalBooking.parse(jsonData) else {
            completionBlock(nil)
            return
        }
        completionBlock(bookings)
    }
}
