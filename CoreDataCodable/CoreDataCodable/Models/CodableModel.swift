//
//  CodableModel.swift
//  CoreDataCodable
//
//  Created by Andrea Prearo on 12/29/21.
//  Copyright © 2021 Andrea Prearo. All rights reserved.
//

import Foundation

/// Protocol to provide functionality for data model encoding and decoding.
typealias CodableModel = DecodableModel & EncodableModel

/// Protocol to provide functionality for data model decoding.
protocol DecodableModel {
    associatedtype Model: Codable

    /// Decodes a model instance of the given type from the given JSON representation.
    ///
    /// - parameter data: The data to decode from.
    /// - returns: The decoded data model instance.
    /// - throws: `DecodingError.dataCorrupted` if values requested from the payload are corrupted, or if the given data is not valid JSON.
    /// - throws: An error if any value throws an error during decoding.
    static func decodeModel(from data: Data) throws -> Model?
}

/// Protocol to provide functionality for data model encoding.
protocol EncodableModel {
    associatedtype Model: Codable

    /// Encodes the model instance and returns its JSON representation.
    ///
    /// - parameter value: The model instance to encode.
    /// - returns: A new `Data` value containing the encoded JSON data.
    /// - throws: `EncodingError.invalidValue` if a non-conforming floating-point value is encountered during encoding,
    ///           and the encoding strategy is `.throw`.
    /// - throws: An error if any value throws an error during encoding.
    static func encodeModel(_ value: Model) throws -> Data?
}

// MARK: - DecodableModel
extension DecodableModel {
    /// Decodes a model instance of the given type from the given JSON representation.
    ///
    /// - parameter data: The data to decode from.
    /// - returns: The decoded data model instance.
    /// - throws: `DecodingError.dataCorrupted` if values requested from the payload are corrupted, or if the given data is not valid JSON.
    /// - throws: An error if any value throws an error during decoding.
    static func decodeModel(from data: Data) throws -> Model? {
        return try JSONDecoder().decode(Model.self, from: data)
    }
}

// MARK: - EncodableModel
extension EncodableModel {
    /// Encodes the model instance and returns its JSON representation.
    ///
    /// - parameter value: The model instance to encode.
    /// - returns: A new `Data` value containing the encoded JSON data.
    /// - throws: `EncodingError.invalidValue` if a non-conforming floating-point value is encountered during encoding,
    ///           and the encoding strategy is `.throw`.
    /// - throws: An error if any value throws an error during encoding.
    static func encodeModel(_ value: Model) throws -> Data? {
        return try JSONEncoder().encode(value)
    }
}
