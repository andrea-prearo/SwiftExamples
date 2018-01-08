//
//  HotelBooking.swift
//  Issues
//
//  Created by Prearo, Andrea on 10/6/17.
//

import Foundation

struct HotelBooking: Bookable, Codable {
    // MARK: - Bookable
    var identifier: String
    var startDate: Date
    var endDate: Date

    let roomNumber: Int
    
    init(identifier: String, startDate: Date, endDate: Date, roomNumber: Int) {
        self.identifier = identifier
        self.startDate = startDate
        self.endDate = endDate
        self.roomNumber = roomNumber
    }

    static func parse(_ jsonData: Data) -> [HotelBooking]? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try? decoder.decode([HotelBooking].self, from: jsonData)
    }
}
