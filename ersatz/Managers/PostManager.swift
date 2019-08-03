//
//  PostManager.swift
//  ersatz
//
//  Created by Kenneth Cluff on 8/3/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

// https://jsonplaceholder.typicode.com
// https://www.raywenderlich.com/3418439-encoding-and-decoding-in-swift

import Foundation

enum APIError: Error {
    case invalidURL
    case other
}

typealias CompletionHander = (Any?, Error?) -> Void
let baseURL = "https://jsonplaceholder.typicode.com/"

protocol PostManager {
    var postList: [MessagePost]? { get }
    var singlePost: MessagePost? { get }
    func getAllPosts(with handler: @escaping CompletionHander)
    func getSinglePosts(for postId: Int, with handler: @escaping CompletionHander)
    func getPosts(for userId: Int, with handler: @escaping CompletionHander)
}

class PostManagingEngine: PostManager {
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    private(set) var postList: [MessagePost]?
    private(set) var singlePost: MessagePost?
    
    func loadDataIntoSinglePost(_ data: Data?) -> Int? {
        var retValue: Int?
        guard let data = data else { return retValue }
        do {
            let aPost = try decoder.decode(MessagePost.self, from: data)
            retValue = 1
            singlePost = aPost
            
        } catch {
            print(error.localizedDescription)
        }
        
        return retValue
    }
    
    func loadDataIntoPosts(_ data: Data?) -> Int? {
        var retValue: Int?
        guard let data = data else { return retValue }
        do {
            let posts = try decoder.decode([MessagePost].self, from: data)
            retValue = posts.count
            postList = posts
            
        } catch {
            print(error.localizedDescription)
        }
        
        return retValue
    }
    
    func getAllPosts(with handler: @escaping CompletionHander) {
        let urlString = baseURL + "posts"
        guard let url = URL(string: urlString) else {
            handler(nil, APIError.invalidURL)
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            defer { handler(self?.postList, error) }
            guard error == nil,
                let result = response as? HTTPURLResponse,
                result.statusCode == 200,
                let data = data,
                let _ = self?.loadDataIntoPosts(data) else { return }
        }
        dataTask.resume()
    }
    
    func getSinglePosts(for postId: Int, with handler: @escaping CompletionHander) {
        let urlString = "\(baseURL)posts/\(postId)"
        guard let url = URL(string: urlString) else {
            handler(nil, APIError.invalidURL)
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            defer { handler(self?.singlePost, error) }
            guard error == nil,
                let result = response as? HTTPURLResponse,
                result.statusCode == 200,
                let data = data,
                let _ = self?.loadDataIntoSinglePost(data) else { return }
        }
        dataTask.resume()
    }
    
    func getPosts(for userId: Int, with handler: @escaping CompletionHander) {
        let urlString = "\(baseURL)posts?userId=\(userId)"
        guard let url = URL(string: urlString) else {
            handler(nil, APIError.invalidURL)
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            defer { handler(self?.postList, error) }
            guard error == nil,
                let result = response as? HTTPURLResponse,
                result.statusCode == 200,
                let data = data,
                let _ = self?.loadDataIntoPosts(data) else { return }
        }
        
        dataTask.resume()
    }
}
