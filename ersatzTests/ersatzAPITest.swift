//
//  ersatzAPITest.swift
//  ersatzTests
//
//  Created by Kenneth Cluff on 8/3/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

import XCTest

class ersatzAPITest: XCTestCase {
    let manager = PostManagingEngine()
    let commentManager = CommentManagerEngine()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetAll() {
        let expectation = XCTestExpectation(description: "Download all posts")
        manager.getAllPosts { (results, error) in
            if let error = error {
                XCTFail("An error was returned from fetching all posts: \(error.localizedDescription)")
            } else if let results = results as? [MessagePost] {
                XCTAssert(results.count == 100, "The wrong number of message posts were returned.")
            } else {
                XCTFail("What was returned weren't posts")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testGetOne() {
        let expectation = XCTestExpectation(description: "Download single post")
        manager.getSinglePosts(for: 1) { (results, error) in
            if let error = error {
                XCTFail("An error was returned from fetching single post: \(error.localizedDescription)")
            } else if let _ = results as? MessagePost {
                XCTAssertNotNil("Results weren't converted to a Post")
            } else {
                XCTFail("What was returned wasn't a post")
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func testGetAllComments() {
        let expectation = XCTestExpectation(description: "Download all comments")
        commentManager.getAllComments { (results, error) in
            if let error = error {
                XCTFail("An error was returned from fetching all comments: \(error.localizedDescription)")
            } else if let results = results as? [Comment] {
                XCTAssert(results.count == 500, "The wrong number of message comments were returned.")
            } else {
                XCTFail("What was returned weren't comments")
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func testGetCommentsForPost() {
        let expectation = XCTestExpectation(description: "Download all comments for a post")
        commentManager.getComments(in: 1) { (results, error) in
            if let error = error {
                XCTFail("An error was returned from fetching all comments for a post: \(error.localizedDescription)")
            } else if let results = results as? [Comment] {
                XCTAssert(results.count == 5, "The wrong number of message posts were returned.")
            } else {
                XCTFail("What was returned weren't posts")
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func testGetPostsForUser() {
        let expectation = XCTestExpectation(description: "Download all posts for a user")
        manager.getPosts(for: 1) { (results, error) in
            if let error = error {
                XCTFail("An error was returned from fetching all posts for a user: \(error.localizedDescription)")
            } else if let results = results as? [MessagePost] {
                print(results.count)
                XCTAssert(results.count == 10, "The wrong number of message posts were returned.")
            } else {
                XCTFail("What was returned weren't posts")
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }
}
