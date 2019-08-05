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
    
    /**
     This is an asynchronous call to get all posts
     
     - Author:
     Ken Cluff
     
     - returns:
     An error indicating if the query failed.
     An array of Comments
     
     - parameters:
     - handler: This conforms to the CompletionHandler type alias. It is used to return the results of the query to the calling object
     
     - Version:
     0.1
     
     
     This gets all posts. Used a URLSession data task to retrieve the information. This is barebones, the only validation of the results is in the 'responseIsValid' function.
     */
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
    
    /**
     This is an asynchronous call to a selected post
     
     - Author:
     Ken Cluff
     
     - returns:
     An error indicating if the query failed.
     An array of Comments
     
     - parameters:
     - postId: This is an int which represents the id property of the selected post
     - handler: This conforms to the CompletionHandler type alias. It is used to return the results of the query to the calling object
     
     - Version:
     0.1
     
     
     This gets a given post. Used a URLSession data task to retrieve the information. This is barebones, the only validation of the results is in the 'responseIsValid' function.
     */
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
    
    /**
     This is an asynchronous call to get posts for a selected user
     
     - Author:
     Ken Cluff
     
     - returns:
     An error indicating if the query failed.
     An array of Comments
     
     - parameters:
     - userId: This is an int which represents the id property of the selected user
     - handler: This conforms to the CompletionHandler type alias. It is used to return the results of the query to the calling object
     
     - Version:
     0.1
     
     
     This gets all posts for a given user. Used a URLSession data task to retrieve the information. This is barebones, the only validation of the results is in the 'responseIsValid' function.
     */
    
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
