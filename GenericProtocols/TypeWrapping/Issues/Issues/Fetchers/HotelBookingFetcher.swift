//
//  HotelBookingFetcher.swift
//  Issues
//
//  Created by Prearo, Andrea on 10/6/17.
//

import Foundation

struct HotelBookingFetcher: Fetchable {
    typealias DataType = HotelBooking
    
    func fetch(completionBlock: @escaping ([HotelBooking]?) -> Void) {
        guard let jsonData = JSONHelper.loadJsonDataFromFile("hotelBookings"),
            let bookings = HotelBooking.parse(jsonData) else {
            completionBlock(nil)
            return
        }
        completionBlock(bookings)
    }
}
