//
//  CommentManagerEngine.swift
//  ersatz
//
//  Created by Kenneth Cluff on 8/3/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

import Foundation

protocol CommentManager {
    var commentList: [Comment]? { get }
    var singleComment: Comment? { get }
    func getAllComments(with handler: @escaping CompletionHander)
    func getComments(in postId: Int, with handler: @escaping CompletionHander)
}

class CommentManagerEngine: CommentManager {
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    private(set) var commentList: [Comment]?
    private(set) var singleComment: Comment?
    
    func loadDataIntoSingleComment(_ data: Data?) -> Int? {
        var retValue: Int?
        guard let data = data else { return retValue }
        do {
            let aComment = try decoder.decode(Comment.self, from: data)
            retValue = 1
            singleComment = aComment
            
        } catch {
            print(error.localizedDescription)
        }
        
        return retValue
    }
    
    func loadDataIntoComments(_ data: Data?) -> Int? {
        var retValue: Int?
        guard let data = data else { return retValue }
        do {
            let comments = try decoder.decode([Comment].self, from: data)
            retValue = comments.count
            commentList = comments
            
        } catch {
            print(error.localizedDescription)
        }
        
        return retValue
    }
    
    func getAllComments(with handler: @escaping CompletionHander) {
        let urlString = baseURL + "posts/1/comments"
        guard let url = URL(string: urlString) else {
            handler(nil, APIError.invalidURL)
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            defer { handler(self?.commentList, error) }
            guard error == nil,
                let result = response as? HTTPURLResponse,
                result.statusCode == 200,
                let data = data,
                let _ = self?.loadDataIntoComments(data) else { return }
        }
        dataTask.resume()
    }
    
    func getComments(in postId: Int, with handler: @escaping CompletionHander) {
        let urlString = "\(baseURL)comments?postId=\(postId)"
        guard let url = URL(string: urlString) else {
            handler(nil, APIError.invalidURL)
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            defer { handler(self?.commentList, error) }
            guard error == nil,
                let result = response as? HTTPURLResponse,
                result.statusCode == 200,
                let data = data,
                let _ = self?.loadDataIntoComments(data) else { return }
        }
        
        dataTask.resume()
    }
    
    
}
