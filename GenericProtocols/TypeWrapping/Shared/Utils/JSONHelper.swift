//
//  JSONHelper.swift
//  Issues
//
//  Created by Prearo, Andrea on 10/6/17.
//

import Foundation

typealias JSONObject = Any

class JSONHelper {
    static func loadJsonFromFile(_ fileName: String) -> JSONObject? {
        return loadJsonDataFromFile(fileName)
            .flatMap { try? JSONSerialization.jsonObject(with: $0 as Data, options: .allowFragments) }
    }

    static func loadJsonDataFromFile(_ fileName: String) -> Data? {
        guard let fileURL = Bundle(for: self).url(forResource: fileName, withExtension: "json"),
            let jsonData = try? Data(contentsOf: fileURL) else {
            return nil
        }
        return jsonData
    }
}
