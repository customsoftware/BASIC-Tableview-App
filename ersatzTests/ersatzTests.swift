//
//  ersatzTests.swift
//  ersatzTests
//
//  Created by Kenneth Cluff on 8/3/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

// Since these are running against a remote site, these will all be asynchronous tests
// When using in an application context, the server will be mocked.

import XCTest

class ersatzTests: XCTestCase {
    let baseURL = "https://jsonplaceholder.typicode.com/"
    var postManager = PostManagingEngine()
    var commentManager = CommentManagerEngine()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchAllPosts() {
        let expectation = XCTestExpectation(description: "Download all posts")
        let urlString = baseURL + "posts"
        let url = URL(string: urlString)!
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
            // Make sure we downloaded some data.
            XCTAssertNotNil(data, "No data was downloaded.")
            // Fulfill the expectation to indicate that the background task has finished successfully.
            let number_of_records_parsed = self?.postManager.loadDataIntoPosts(data)
            XCTAssertNotNil(number_of_records_parsed, "No records were parsed")

            expectation.fulfill()
        }
        dataTask.resume()
        wait(for: [expectation], timeout: 10.0)
    }

    func testFetchSinglePost() {
        let expectation = XCTestExpectation(description: "Download a single post")
        let urlString = baseURL + "posts/1"
        let url = URL(string: urlString)!
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
            // Make sure we downloaded some data.
            XCTAssertNotNil(data, "No data was downloaded.")
            
            let number_of_records_parsed = self?.postManager.loadDataIntoSinglePost(data)
            XCTAssertNotNil(number_of_records_parsed, "No records were parsed")
            
            // Fulfill the expectation to indicate that the background task has finished successfully.
            expectation.fulfill()
        }
        dataTask.resume()
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testFetchAllComments() {
        let expectation = XCTestExpectation(description: "Download all comments")
        let urlString = baseURL + "posts/1/comments"
        let url = URL(string: urlString)!
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
            // Make sure we downloaded some data.
            XCTAssertNotNil(data, "No data was downloaded.")
            
            let number_of_records_parsed = self?.commentManager.loadDataIntoComments(data)
            XCTAssertNotNil(number_of_records_parsed, "No records were parsed")
            XCTAssert(number_of_records_parsed == 500, "There should have been five hundred records returned.")
            // Fulfill the expectation to indicate that the background task has finished successfully.
            expectation.fulfill()
        }
        dataTask.resume()
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testFetchAllCommentsForAPost() {
        let expectation = XCTestExpectation(description: "Download all comments for a single post")
        let urlString = baseURL + "comments?postId=1"
        let url = URL(string: urlString)!
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
            // Make sure we downloaded some data.
            XCTAssertNotNil(data, "No data was downloaded.")
            
            let number_of_records_parsed = self?.commentManager.loadDataIntoComments(data)
            XCTAssertNotNil(number_of_records_parsed, "No records were parsed")
            XCTAssert(number_of_records_parsed == 5, "There should have been just five records returned.")
            // Fulfill the expectation to indicate that the background task has finished successfully.
            expectation.fulfill()
        }
        dataTask.resume()
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testFetchAllPostsForUser() {
        let expectation = XCTestExpectation(description: "Download all comments for a single user")
        let urlString = baseURL + "posts?userId=1"
        let url = URL(string: urlString)!
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
            // Make sure we downloaded some data.
            XCTAssertNotNil(data, "No data was downloaded.")

            let number_of_records_parsed = self?.postManager.loadDataIntoPosts(data)
            XCTAssertNotNil(number_of_records_parsed, "No records were parsed")

            // Fulfill the expectation to indicate that the background task has finished successfully.
            expectation.fulfill()
        }
        dataTask.resume()
        wait(for: [expectation], timeout: 10.0)
    }
}
