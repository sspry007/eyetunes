//
//  Strings.swift
//  eyetunes
//
//  Created by Steven Spry on 6/2/20.
//  Copyright © 2020 Steven Spry. All rights reserved.
//

import UIKit

class Strings {
    static func fromKey(_ key: String) -> String {
        return NSLocalizedString(key, comment: key)
    }
}
