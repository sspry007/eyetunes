//
//  Genre.swift
//  eyetunes
//
//  Created by Steven Spry on 6/1/20.
//  Copyright © 2020 Steven Spry. All rights reserved.
//

import Foundation

struct Genre {
    let name : String
    let url : String
    
    static func parseObject(dictionary: [String : Any?]) -> Result<Genre, ErrorResult> {
        
        guard let name = dictionary["name"] as? String,
            let url = dictionary["url"] as? String
            else {
                return Result.failure(ErrorResult.parser(string: "Error parsing genre"))
            }
        
        let genre = Genre(name: name, url: url)
        return Result.success(genre)
    }
}

