//
//  NSError+Util.swift
//  SmoothScrolling
//
//  Created by Andrea Prearo on 8/18/16.
//  Copyright © 2016 Andrea Prearo. All rights reserved.
//

import Foundation

extension NSError {
    static func createError(_ code: Int, description: String) -> NSError {
        return NSError(domain: "com.aprearo.TableView",
                       code: 400,
                       userInfo: [
                        "NSLocalizedDescription" : description
            ])
    }
}
