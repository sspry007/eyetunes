//
//  Result.swift
//  eyetunes
//
//  Created by Steven Spry on 5/28/20.
//  Copyright © 2020 Steven Spry. All rights reserved.
//

import Foundation

enum Result<T, E: Error> {
    case success(T)
    case failure(E)
}
