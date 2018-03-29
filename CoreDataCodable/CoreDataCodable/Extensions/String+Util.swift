//
//  String+Util.swift
//  CoreDataCodable
//
//  Created by Andrea Prearo on 3/31/18.
//  Copyright © 2018 Andrea Prearo. All rights reserved.
//

import Foundation

extension String {
    static func emptyIfNil(_ optionalString: String?) -> String {
        let text: String
        if let unwrapped = optionalString {
            text = unwrapped
        } else {
            text = ""
        }
        return text
    }
}
