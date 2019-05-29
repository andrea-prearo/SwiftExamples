//
//  FlightBookingFetcher.swift
//  Solution
//
//  Created by Prearo, Andrea on 10/6/17.
//

import Foundation

struct FlightBookingFetcher: BookingFetchable {
    func fetch(completionBlock: @escaping ([Bookable]) -> Void) {
        guard let jsonData = JSONHelper.loadJsonDataFromFile("flightBookings"),
            let bookings = FlightBooking.parse(jsonData) else {
            completionBlock([])
            return
        }
        completionBlock(bookings)
    }
}
