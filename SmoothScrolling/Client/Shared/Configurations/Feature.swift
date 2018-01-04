//
//  Feature.swift
//  CollectionView
//
//  Created by Andrea Prearo on 1/3/18.
//  Copyright © 2018 Andrea Prearo. All rights reserved.
//

import Foundation

class Feature: Codable {
    let identifier: String
    var value: Bool

    private enum CodingKeys: String, CodingKey {
        case identifier = "Identifier"
        case value = "Value"
    }

    init(_ identifier: String) {
        self.identifier = identifier
        self.value = false
    }

    var isEnabled: Bool {
        return value == true
    }

    func setEnabled(_ value: Bool) {
        self.value = value
    }

    func enable() {
        setEnabled(true)
    }

    func disable() {
        setEnabled(false)
    }
}

extension Feature {
    static let clearCaches = Feature("ClearCaches")
    static let debugCellLifecycle = Feature("DebugCellLifecycle")

    private static let features = [Feature.clearCaches, Feature.debugCellLifecycle]

    private static func feature(for identifier: String) -> Feature? {
        return features.filter { $0.identifier == identifier } .first
    }

    static func initFromPList() {
        if let url = Bundle.main.url(forResource: "Features", withExtension: "plist") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = PropertyListDecoder()
                let featuresFromPList = try decoder.decode([Feature].self, from: data)
                for featureFromPList in featuresFromPList {
                    if let feature = Feature.feature(for: featureFromPList.identifier) {
                        feature.setEnabled(featureFromPList.value)
                    }
                }
            } catch {
                print(error)
            }
        }
    }
}
