//
//  HotelBookingFetcher.swift
//  Solution
//
//  Created by Prearo, Andrea on 10/6/17.
//

import Foundation

struct HotelBookingFetcher: BookingFetchable {
    func fetch(completionBlock: @escaping ([Bookable]) -> Void) {
        guard let jsonData = JSONHelper.loadJsonDataFromFile("hotelBookings"),
            let bookings = HotelBooking.parse(jsonData) else {
            completionBlock([])
            return
        }
        completionBlock(bookings)
    }
}
