//
//  CommentManagerEngine.swift
//  ersatz
//
//  Created by Kenneth Cluff on 8/3/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

import Foundation

class CommentManagerEngine: CommentManager {
    var commentList: [Comment]?
    var singleComment: Comment?
    
    /**
     This is how to get all comments associated with all posts
     
     - Author:
     Ken Cluff
     
     - parameters:
     - handler: This conforms to the CompletionHandler type alias. It is used to return the results of the query to the calling object
     
     - Version:
     0.1
     
     This gets all comments. Used a URLSession data task to retrieve the information. This is barebones, the only validation of the results is in the 'responseIsValid' function.
     */
    func getAllComments(with handler: @escaping CompletionHander) {
        let urlString = baseURL + "posts/1/comments"
        guard let url = URL(string: urlString) else {
            handler(nil, APIError.invalidURL)
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            defer { handler(self?.commentList, error) }
            guard error == nil,
                responseIsValid(response),
                let data = data,
                let _ = self?.loadDataIntoComments(data) else { return }
        }
        dataTask.resume()
    }
    
    /**
     This is an asynchronous call to get comments for a selected post
     
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
     
     
     This gets all comments for a given post. Used a URLSession data task to retrieve the information. This is barebones, the only validation of the results is in the 'responseIsValid' function.
     */
    func getComments(in postId: Int, with handler: @escaping CompletionHander) {
        let urlString = "\(baseURL)comments?postId=\(postId)"
        guard let url = URL(string: urlString) else {
            handler(nil, APIError.invalidURL)
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            defer { handler(self?.commentList, error) }
            guard error == nil,
                responseIsValid(response),
                let data = data,
                let _ = self?.loadDataIntoComments(data) else { return }
        }
        
        dataTask.resume()
    }
}
