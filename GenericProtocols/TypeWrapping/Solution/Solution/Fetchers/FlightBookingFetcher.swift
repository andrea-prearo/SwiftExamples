//
//  FlightBookingFetcher.swift
//  Solution
//
//  Created by Prearo, Andrea on 10/6/17.
//

import Foundation

// MARK: Type Placeholder Wrapper
struct FlightBookingsWrapper: FetchableType {
    let bookings: [FlightBooking]?
}

struct FlightBookingFetcher: Fetchable {
    func fetch(completionBlock: @escaping (FetchableType) -> Void) {
        guard let jsonData = JSONHelper.loadJsonDataFromFile("flightBookings"),
            let bookings = FlightBooking.parse(jsonData) else {
            completionBlock(FlightBookingsWrapper(bookings: nil))
            return
        }
        completionBlock(FlightBookingsWrapper(bookings: bookings))
    }
}
