//
//  Message.swift
//  ersatz
//
//  Created by Kenneth Cluff on 8/3/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

import Foundation

/*

 **/
struct Comment: Codable {
    var postId: Int
    var id: Int
    var name: String
    var email: String
    var body: String
}
