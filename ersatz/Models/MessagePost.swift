//
//  MessagePost.swift
//  ersatz
//
//  Created by Kenneth Cluff on 8/3/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

import Foundation

/*
 
 **/
struct MessagePost: Codable {
    var userId: Int
    var id: Int
    var title: String
    var body: String
}
