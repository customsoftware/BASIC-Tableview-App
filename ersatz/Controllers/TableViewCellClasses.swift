//
//  TableViewCellClasses.swift
//  ersatz
//
//  Created by Kenneth Cluff on 8/3/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    var controllingComment: Comment? {
        didSet {
            guard let comment = controllingComment else { return }
            commentTitle.text = comment.name
            commentAuthor.text = comment.email
            commentText.text = comment.body
        }
    }
    
    @IBOutlet weak var commentTitle: UILabel!
    @IBOutlet weak var commentAuthor: UILabel!
    @IBOutlet weak var commentText: UITextView!
}

class DisplayCell: UITableViewCell {
    var owningPost: MessagePost? {
        didSet {
            guard let post = owningPost else { return }
            textLabel?.text = post.title
            detailTextLabel?.text = post.body
        }
    }
}
