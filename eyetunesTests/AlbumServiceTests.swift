//
//  AlbumServiceTests.swift
//  eyetunesTests
//
//  Created by Steven Spry on 5/30/20.
//  Copyright © 2020 Steven Spry. All rights reserved.
//

import XCTest
@testable import Eye_Tunes

class AlbumServiceTests: XCTestCase {
    
    fileprivate var service : AlbumService!

    override func setUpWithError() throws {
        self.service = AlbumService(isMocked: false)
    }

    override func tearDownWithError() throws {
        self.service = nil
        super.tearDown()
    }
    
    func testCancelRequest() {
        // giving a "previous" session
        self.service.fetchAlbums { (_) in
            // ignore call
        }
        
        // Expected to task nil after cancel
        self.service.cancelFetchAlbums()
        XCTAssertNil(AlbumService().task, "Expected task nil")
    }
    
    func testBadServiceUrl() {
        
        let expectation = XCTestExpectation(description: "Albums not fetched")

        self.service.serviceURL = "https://rss.itune.apple.com/api/v1/us/itunes-music/non-explicit.json"
        self.service.fetchAlbums { ( result) in
            switch result {
            case .success( _ ):
                XCTAssert(false, "Expected failure")
            case .failure(_):
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5.0)

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            self.service.fetchAlbums { (_) in
                // ignore call
            }
        }
    }

}
