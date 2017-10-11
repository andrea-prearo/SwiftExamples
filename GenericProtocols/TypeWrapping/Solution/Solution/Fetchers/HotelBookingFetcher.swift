//
//  HotelBookingFetcher.swift
//  Solution
//
//  Created by Prearo, Andrea on 10/6/17.
//

import Foundation

// MARK: Type Placeholder Wrapper
struct HotelBookingsWrapper: FetchableType {
    let bookings: [HotelBooking]?
}

struct HotelBookingFetcher: Fetchable {
    func fetch(completionBlock: @escaping (FetchableType) -> Void) {
        guard let jsonData = JSONHelper.loadJsonDataFromFile("hotelBookings"),
            let bookings = HotelBooking.parse(jsonData) else {
            completionBlock(HotelBookingsWrapper(bookings: nil))
            return
        }
        completionBlock(HotelBookingsWrapper(bookings: bookings))
    }
}
