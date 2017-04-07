//
//  FeedTableViewController.swift
//  Lic
//
//  Created by Ivor D. Addo on 4/6/17.
//  Copyright © 2017 Marquette University. All rights reserved.
//

import UIKit
import Firebase

class FeedTableViewController: UITableViewController {

    var posts: [Post]?
    var ref: FIRDatabaseReference = FIRDatabase.database().reference()
    
    struct Storyboard {
        static let postCell = "PostCell"
        static let postCellDefaultHeight: CGFloat = 578.0
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataFromFirebase()
        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false
        tableView.estimatedRowHeight = Storyboard.postCellDefaultHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = UIColor.clear
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func loadDataFromFirebase() {
        
        ref.child("Lics").observe(.value, with: { snapshot in
            var newposts: [Post] = []
            
            for dbItem in snapshot.children.allObjects {
                let gItem = (snapshot: dbItem as! FIRDataSnapshot)
                
                let newValue = Post(snapshot: gItem)
                newposts.append(newValue)
            }
            
            //TO-DO SORT BY NETVOTES
           // self.posts = newposts.sorted
            self.tableView.reloadData()
            
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let posts = posts {
            return posts.count
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = posts {
            return 1
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.postCell, for: indexPath) as! PostCell
        cell.post = self.posts?[indexPath.section]
        
        return cell
    }
    
    
}