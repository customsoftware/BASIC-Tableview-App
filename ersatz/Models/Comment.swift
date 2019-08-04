//
//  Message.swift
//  ersatz
//
//  Created by Kenneth Cluff on 8/3/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

import Foundation

/**
 This is a codable struct to carry data throughout the application
 
 - Author:
 Ken Cluff
 
 - Version:
 0.1
 
 The Comment object
 */

struct Comment: Codable {
    var postId: Int
    var id: Int
    var name: String
    var email: String
    var body: String
}
