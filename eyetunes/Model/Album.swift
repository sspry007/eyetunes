//
//  Album.swift
//  eyetunes
//
//  Created by Steven Spry on 6/1/20.
//  Copyright © 2020 Steven Spry. All rights reserved.
//

import Foundation

struct Album {
    let album : String
    let artist : String
    let thumbnailUrl : String
    let url : String
    let genres : [Genre]
    let releaseDate : String
    let copyright : String
    
    var genre:String {
        let names = genres.map({ $0.name })
        let nameString = names.joined(separator: ", ")
        return nameString
    }
}

extension Album  {
    
    static func parseObject(dictionary: [String : AnyObject]) -> Result<[Album], ErrorResult> {
        
        if let feed = dictionary["feed"] as? [String: Any?] {
            if let results = feed["results"] as? [[String: Any?]] {
                var albums:[Album] = []
                for item in results {
                    if let kind = item["kind"] as? String {
                        
                        guard kind == "album" else { continue }
                        
                        if let album = item["name"] as? String,
                            let artist = item["artistName"] as? String,
                            let thumbnailUrl = item["artworkUrl100"] as? String,
                            let url = item["url"] as? String,
                            let genres = item["genres"] as? [[String: Any?]],
                            let releaseDate = item["releaseDate"] as? String,
                            let copyright = item["copyright"] as? String
                        {
                            var genresArray: [Genre] = []
                            for genre in genres {
                                switch Genre.parseObject(dictionary: genre) {
                                case .failure:
                                    continue
                                case .success(let album):
                                    genresArray.append(album)
                                }
                            }
                            
                            let album = Album(album: album, artist: artist, thumbnailUrl: thumbnailUrl, url: url, genres: genresArray, releaseDate: releaseDate, copyright: copyright)
                            
                            albums.append(album)
                        }
                    }
                }
                return Result.success(albums)
            } else {
                return Result.failure(ErrorResult.parser(string: "Unable to parse albums"))
            }
        } else {
            return Result.failure(ErrorResult.parser(string: "Unable to parse albums"))
        }
    }
}

extension Album {
    var formattedReleaseDate: String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "YYYY-MM-dd"
        guard let date = inputFormatter.date(from: releaseDate) else { return ""}
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let string = dateFormatter.string(from: date)
        return string
    }
}
