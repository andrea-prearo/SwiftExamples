//
//  Users.swift
//  CoreDataCodable
//
//  Created by Andrea Prearo on 12/29/21.
//  Copyright © 2021 Andrea Prearo. All rights reserved.
//

import Foundation

struct Users: Codable, Equatable, CodableModel {
    typealias Model = Users

    let data: [User?]
}

extension Users {
    // MARK: - DecodableModel
    static func decodeModel(from data: Data) throws -> [User?] {
        let decoder = JSONDecoder()
        return try decoder.decode([User].self, from: data)
    }

    // MARK: - EncodableModel
    static func encodeModel(_ value: Users) throws -> Data? {
        let encoder = JSONEncoder()
        return try encoder.encode(value)
    }
}
