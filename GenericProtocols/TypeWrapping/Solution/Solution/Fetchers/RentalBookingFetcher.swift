//
//  RentalBookingFetcher.swift
//  Solution
//
//  Created by Prearo, Andrea on 10/6/17.
//

import Foundation

// MARK: Type Placeholder Wrapper
struct RentalBookingsWrapper: FetchableType {
    let bookings: [RentalBooking]?
}

struct RentalBookingFetcher: Fetchable {
    func fetch(completionBlock: @escaping (FetchableType) -> Void) {
        guard let jsonData = JSONHelper.loadJsonDataFromFile("rentalBookings"),
            let bookings = RentalBooking.parse(jsonData) else {
            completionBlock(RentalBookingsWrapper(bookings: nil))
            return
        }
        completionBlock(RentalBookingsWrapper(bookings: bookings))
    }
}
