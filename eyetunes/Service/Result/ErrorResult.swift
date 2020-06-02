//
//  ErrorResult.swift
//  eyetunes
//
//  Created by Steven Spry on 5/28/20.
//  Copyright © 2020 Steven Spry. All rights reserved.
//

import Foundation

enum ErrorResult: Error {
    case network(string: String)
    case service(string: String)
    case parser(string: String)
    case custom(string: String)
}
