//
//  RentalBookingFetcher.swift
//  Solution
//
//  Created by Prearo, Andrea on 10/6/17.
//

import Foundation

struct RentalBookingFetcher: BookingFetchable {
    func fetch(completionBlock: @escaping ([Bookable]) -> Void) {
        guard let jsonData = JSONHelper.loadJsonDataFromFile("rentalBookings"),
            let bookings = RentalBooking.parse(jsonData) else {
            completionBlock([])
            return
        }
        completionBlock(bookings)
    }
}
