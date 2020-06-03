//
//  albumParserTests.swift
//  eyetunesTests
//
//  Created by Steven Spry on 5/30/20.
//  Copyright © 2020 Steven Spry. All rights reserved.
//

import XCTest
@testable import Eye_Tunes

class albumParserTests: XCTestCase {
    
    func testParseEmptyAlbum() {
        
        // giving empty data
        let data = Data()
        
        // giving completion after parsing
        // expected valid album with valid data
        let completion : ((Result<[Album], ErrorResult>) -> Void) = { result in
            switch result {
            case .success(_):
                XCTAssert(false, "Expected failure when no data")
            default:
                break
            }
        }
        AlbumParser.parse(data: data, completion: completion)
    }
    
    func testParseAlbum() {
        
        // giving a sample json file
        guard let data = FileManager.readJson(forResource: "Feed") else {
            XCTAssert(false, "Can't get data from Feed.json")
            return
        }
        
        // giving completion after parsing
        // expected valid albums with valid data
        let completion : ((Result<[Album], ErrorResult>) -> Void) = { result in
            switch result {
            case .failure(_):
                XCTAssert(false, "Expected valid album")
            case .success(let albums):
                                
                guard let firstAlbum = albums.first else {
                    XCTAssert(false, "Can't get data from Album.json")
                    return
                }
                XCTAssertEqual(firstAlbum.artist, "Lady Gaga", "Expected artist Lady Gaga")
                XCTAssertEqual(firstAlbum.album, "Chromatica", "Expected album Chromatica")
                XCTAssertEqual(firstAlbum.genre, "Pop, Music", "Expected Pop, Music genre")
            }
        }
        
        AlbumParser.parse(data: data, completion: completion)
    }
    
    func testWrongKeyAlbum() {
        
        // giving a wrong dictionary
        let dictionary:[String:AnyObject] = ["kind" : "albumTest" as AnyObject]
        
        // expected to return error of album
        let result = Album.parseObject(dictionary: dictionary)
        
        switch result {
        case .success(_):
            XCTAssert(false, "Expected failure when wrong data")
        default:
            return
        }
    }
    
}
