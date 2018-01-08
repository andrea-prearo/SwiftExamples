//
//  main.swift
//  Solution
//
//  Created by Prearo, Andrea on 10/6/17.
//

import Foundation

enum BookingType {
    case flight
    case hotel
    case rental
}

struct BookingCoordinator {
    public func fetch() {
        let fetchers: [Fetchable] = [FlightBookingFetcher(), HotelBookingFetcher(), RentalBookingFetcher()]
        for fetcher in fetchers {
            fetcher.fetch { (bookings) in
                print(bookings)
            }
        }
    }
}
