//
//  albumTests.swift
//  eyetunesTests
//
//  Created by Steven Spry on 6/2/20.
//  Copyright © 2020 Steven Spry. All rights reserved.
//

import XCTest
@testable import Eye_Tunes

class albumTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }

    override func tearDownWithError() throws {
        super.tearDown()
    }

    func testCorrectDateFormatting() throws {
        
        let sut = Album(album: "An Album", artist: "An Artist", thumbnailUrl: "thumbnail", url: "a URL", genres: [], releaseDate: "2020-05-08", copyright: "")
        
        let formattedDate = sut.formattedReleaseDate
        //Then
        switch formattedDate {
        case "May 8, 2020":
            // Success
            break
        default:
            XCTAssert(false, "Release date incorrectly formatted")
        }
    }
    
    func testBadDateFormatting() throws {
        
        let sut = Album(album: "An Album", artist: "An Artist", thumbnailUrl: "thumbnail", url: "a URL", genres: [], releaseDate: "2005-03-01T12:00:00Z", copyright: "")
        
        let formattedDate = sut.formattedReleaseDate

        //Then
        switch formattedDate {
        case "":
            // Success
            break
        default:
            XCTAssert(false, "Release date incorrectly formatted")
        }
    }

}
