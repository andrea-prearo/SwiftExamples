//
//  FlightBookingFetcher.swift
//  Issues
//
//  Created by Prearo, Andrea on 10/6/17.
//

import Foundation

struct FlightBookingFetcher: Fetchable {
    typealias DataType = FlightBooking
    
    func fetch(completionBlock: @escaping ([FlightBooking]?) -> Void) {
        guard let jsonData = JSONHelper.loadJsonDataFromFile("flightBookings"),
            let bookings = FlightBooking.parse(jsonData) else {
            completionBlock(nil)
            return
        }
        completionBlock(bookings)
    }
}
