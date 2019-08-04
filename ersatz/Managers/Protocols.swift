//
//  Protocols.swift
//  ersatz
//
//  Created by Kenneth Cluff on 8/3/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case other
}


func responseIsValid(_ response: URLResponse?) -> Bool {
    guard let result = response as? HTTPURLResponse,
        result.statusCode == 200 else { return false }
    return true
}

typealias CompletionHander = (Any?, Error?) -> Void
let baseURL = "https://jsonplaceholder.typicode.com/"

protocol PostManager {
    var postList: [MessagePost]? { get set }
    var singlePost: MessagePost? { get set }
    func getAllPosts(with handler: @escaping CompletionHander)
    func getSinglePosts(for postId: Int, with handler: @escaping CompletionHander)
    func getPosts(for userId: Int, with handler: @escaping CompletionHander)
}

extension PostManager {
    mutating func loadDataIntoSinglePost(_ data: Data?) -> Int? {
        var retValue: Int?
        guard let data = data else { return retValue }
        do {
            let decoder = JSONDecoder()
            let aPost = try decoder.decode(MessagePost.self, from: data)
            retValue = 1
            singlePost = aPost
            
        } catch {
            print(error.localizedDescription)
        }
        
        return retValue
    }
    
    mutating func loadDataIntoPosts(_ data: Data?) -> Int? {
        var retValue: Int?
        guard let data = data else { return retValue }
        do {
            let decoder = JSONDecoder()
            let posts = try decoder.decode([MessagePost].self, from: data)
            retValue = posts.count
            postList = posts
            
        } catch {
            print(error.localizedDescription)
        }
        
        return retValue
    }
}

protocol CommentManager {
    var commentList: [Comment]? { get set }
    var singleComment: Comment? { get set }
    func getAllComments(with handler: @escaping CompletionHander)
    func getComments(in postId: Int, with handler: @escaping CompletionHander)
}

extension CommentManager {
    mutating func loadDataIntoSingleComment(_ data: Data?) -> Int? {
        var retValue: Int?
        guard let data = data else { return retValue }
        do {
            let decoder = JSONDecoder()
            
            let aComment = try decoder.decode(Comment.self, from: data)
            retValue = 1
            singleComment = aComment
            
        } catch {
            print(error.localizedDescription)
        }
        
        return retValue
    }
    
    mutating func loadDataIntoComments(_ data: Data?) -> Int? {
        var retValue: Int?
        guard let data = data else { return retValue }
        do {
            let decoder = JSONDecoder()
            
            let comments = try decoder.decode([Comment].self, from: data)
            retValue = comments.count
            commentList = comments
            
        } catch {
            print(error.localizedDescription)
        }
        
        return retValue
    }
}

