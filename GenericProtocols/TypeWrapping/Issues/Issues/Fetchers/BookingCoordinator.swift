//
//  BookingCoordinator.swift
//  Issues
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
        FlightBookingFetcher().fetch { (flightBookings) in
            guard let flightBookings = flightBookings else {
                return
            }
            print(flightBookings)
        }
        
        HotelBookingFetcher().fetch { (hotelBookings) in
            guard let hotelBookings = hotelBookings else {
                return
            }
            print(hotelBookings)
        }
        
        RentalBookingFetcher().fetch { (rentalBookings) in
            guard let rentalBookings = rentalBookings else {
                return
            }
            print(rentalBookings)
        }
    }
}
