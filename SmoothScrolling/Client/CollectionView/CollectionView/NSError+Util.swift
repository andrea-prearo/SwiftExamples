//
//  NSError+Util.swift
//  TableView
//
//  Created by Prearo, Andrea on 8/18/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import Foundation

extension NSError {

    static func createError(code: Int, description: String) -> NSError {
        return NSError(domain: "com.aprearo.TableView",
                       code: 400,
                       userInfo: [
                        "NSLocalizedDescription" : description
            ])
    }

}