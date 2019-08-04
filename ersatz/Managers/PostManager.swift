//
//  PostManager.swift
//  ersatz
//
//  Created by Kenneth Cluff on 8/3/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

import Foundation

class PostManagingEngine: PostManager {
    var postList: [MessagePost]?
    var singlePost: MessagePost?
    
    func getAllPosts(with handler: @escaping CompletionHander) {
        let urlString = baseURL + "posts"
        guard let url = URL(string: urlString) else {
            handler(nil, APIError.invalidURL)
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            defer { handler(self?.postList, error) }
            guard error == nil,
                responseIsValid(response),
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
                responseIsValid(response),
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
