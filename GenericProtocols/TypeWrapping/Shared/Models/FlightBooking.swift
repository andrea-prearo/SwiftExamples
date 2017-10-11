//
//  FlightBooking.swift
//  Issues
//
//  Created by Prearo, Andrea on 10/6/17.
//

import Foundation

struct FlightBooking: Bookable, Codable {
    // MARK: - Bookable
    var identifier: String
    var startDate: Date
    var endDate: Date

    let flightNumber: String
    let from: String
    let to: String
    let isRoundTrip: Bool
    
    init(identifier: String, startDate: Date, endDate: Date, flightNumber: String, from: String, to: String, isRoundTrip: Bool) {
        self.identifier = identifier
        self.startDate = startDate
        self.endDate = endDate
        self.flightNumber = flightNumber
        self.from = from
        self.to = to
        self.isRoundTrip = isRoundTrip
    }

    static func parse(_ jsonData: Data) -> [FlightBooking]? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try? decoder.decode([FlightBooking].self, from: jsonData)
    }
}
