//
//  ViewController.swift
//  ersatz
//
//  Created by Kenneth Cluff on 8/3/19.
//  Copyright © 2019 Kenneth Cluff. All rights reserved.
//

import UIKit

enum HomeSegues: String {
    case pushDetails
}

class HomeViewController: UITableViewController {
    let manager: PostManager = PostManagingEngine()
    let cellID = "displayCellID"
    let pushSegueID = "pushDetails"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Message Test"
        tableView.estimatedRowHeight = 85
        navigationController?.navigationBar.prefersLargeTitles = true
        manager.getAllPosts { (result, error) in
            guard error == nil else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueID = segue.identifier,
            let segueType = HomeSegues(rawValue: segueID) else { return }
        switch segueType {
        case .pushDetails:
            guard let newVC = segue.destination as? CommentTableViewController,
                let post = sender as? MessagePost else { return }
            newVC.controllingPost = post
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.postList?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! DisplayCell
        guard let post = manager.postList?[indexPath.row] else { return cell }
        cell.owningPost = post
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let post = manager.postList?[indexPath.row] else { return }
        performSegue(withIdentifier: pushSegueID, sender: post)
    }
}
