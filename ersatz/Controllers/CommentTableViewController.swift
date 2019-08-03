//
//  CommentTableViewController.swift
//  ersatz
//
//  Created by Kenneth Cluff on 8/3/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

import UIKit

class CommentTableViewController: UITableViewController {
    let cellID = "commentCellID"
    let manager: CommentManager = CommentManagerEngine()
    var controllingPost: MessagePost?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 110
        guard let post = controllingPost else { return }
        navigationItem.title = post.title
        manager.getComments(in: post.id) { (result, error) in
            guard error == nil else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.commentList?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CommentCell
        guard let comment = manager.commentList?[indexPath.row] else { return cell }
        cell.controllingComment = comment
        return cell
    }
}

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
