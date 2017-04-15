//
//  UserTableViewController.swift
//  Lic
//
//  Created by Ivor D. Addo on 4/11/17.
//  Copyright © 2017 Marquette University. All rights reserved.
//

import UIKit
import Firebase

class UserTableViewController: UITableViewController {

    @IBOutlet var settingsView: UIView!
    var posts: [Post]?
    let ref = FIRDatabase.database().reference(withPath: "Lics")
  //  @IBOutlet weak var visualEffectView: UIVisualEffectView!
  //  var effect: UIVisualEffect!
    let uid = FIRAuth.auth()!.currentUser!.uid
    
    struct Storyboard {
        static let postCell = "PostCell"
        static let postCellDefaultHeight: CGFloat = 578.0
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataFromFirebase()
        tableView.estimatedRowHeight = Storyboard.postCellDefaultHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = UIColor.clear
        tableView.allowsMultipleSelectionDuringEditing = false
        //effect = visualEffectView.effect
        //visualEffectView.effect = nil
        settingsView.layer.cornerRadius = 5
      
    }
    func loadDataFromFirebase() {
        
        ref.queryOrdered(byChild: "userID").queryEqual(toValue: uid).observe(.value, with: { snapshot in
            var newposts: [Post] = []
            
            for dbItem in snapshot.children.allObjects {
                let postItem = (snapshot: dbItem as! FIRDataSnapshot)
                
                let newValue = Post(snapshot: postItem)
                newposts.append(newValue)
            }
            
            //TO-DO SORT BY USERID
            self.posts = newposts
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
    
    
    func animateIn() { //Code for the pop up appearing
        self.view.addSubview(settingsView)
        settingsView.center = self.view.center
        
        settingsView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        settingsView.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
        //self.visualEffectView.effect = self.effect
            self.settingsView.alpha = 0.7
            self.settingsView.transform = CGAffineTransform.identity
            
        }
        
        
    }
    
    func animateOut() { //Code for the pop up disappearing
        UIView.animate(withDuration: 0.3, animations: {
            self.settingsView.transform = CGAffineTransform.init(scaleX: 1.3, y:1.3)
            self.settingsView.alpha = 0
            
       //self.visualEffectView.effect = nil
            
        }) { (success:Bool) in
            self.settingsView.removeFromSuperview()
        }
    }
    
    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        animateOut()
        try! FIRAuth.auth()!.signOut()
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "login")
        self.show(vc!, sender: nil)
        
        
    }
    
    @IBAction func closePopUp(_ sender: UIButton) {
        animateOut()
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIBarButtonItem) {
        animateIn()
    }
    
    

}

