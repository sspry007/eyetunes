//
//  AlbumsViewModelTests.swift
//  eyetunesTests
//
//  Created by Steven Spry on 5/30/20.
//  Copyright © 2020 Steven Spry. All rights reserved.
//

import XCTest
@testable import Eye_Tunes

class AlbumsViewModelTests: XCTestCase {
    
    var viewModel : AlbumsViewModel!
    fileprivate var service : AlbumService!

    override func setUpWithError() throws {
        self.service = AlbumService(isMocked: true)
        self.viewModel = AlbumsViewModel()
    }

    override func tearDownWithError() throws {
        self.viewModel = nil
        self.service = nil
        super.tearDown()
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testFetchWithNoService() throws {
        
        let expectation = XCTestExpectation(description: "No service albums")
        
        // giving no service to a view model
        viewModel.service = nil
        
        // expected to not be able to fetch albums
        viewModel.fetchAlbums { ( result) in
            
            switch result {
            case .failure( _ ):
                expectation.fulfill()
            case .success( _ ):
                XCTAssert(false,"Expected service failure")
            }
            
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchAlbums() {
        
        let expectation = XCTestExpectation(description: "Albums fetch")

        viewModel.fetchAlbums { (result) in
            switch result {
            case .success( _ ):
                expectation.fulfill()
            case .failure(_):
                XCTAssert(false, "Expected success")
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
