//
//  RentalBooking
//  Issues
//
//  Created by Prearo, Andrea on 10/6/17.
//

import Foundation

struct RentalBooking: Bookable, Codable {
    // MARK: - Bookable
    var identifier: String
    var startDate: Date
    var endDate: Date

    let model: String
    let make: String
    
    init(identifier: String, startDate: Date, endDate: Date, model: String, make: String) {
        self.identifier = identifier
        self.startDate = startDate
        self.endDate = endDate
        self.model = model
        self.make = make
    }

    static func parse(_ jsonData: Data) -> [RentalBooking]? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try? decoder.decode([RentalBooking].self, from: jsonData)
    }
}
