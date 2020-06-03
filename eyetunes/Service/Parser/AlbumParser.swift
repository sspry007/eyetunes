//
//  AlbumParser.swift
//  eyetunes
//
//  Created by Steven Spry on 5/28/20.
//  Copyright © 2020 Steven Spry. All rights reserved.
//


import Foundation

final class AlbumParser {
    
    static func parse(data:Data, completion: @escaping ((Result<[Album], ErrorResult>) -> Void)) {
        do {
            if let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject] {

                switch Album.parseObject(dictionary: dictionary) {
                case .failure(let error):
                    completion(Result.failure(ErrorResult.parser(string: error.localizedDescription)))
                case .success(let albums):
                    completion(.success(albums))
                }
            }
        }
        catch {
            completion(Result.failure(ErrorResult.parser(string: error.localizedDescription)))
        }
    }
}
