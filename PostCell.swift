//
//  PostCell.swift
//  Lic
//
//  Created by Ivor D. Addo on 4/6/17.
//  Copyright © 2017 Marquette University. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var downvoteButton: UIButton!
    @IBOutlet weak var upvoteButton: UIButton!
    @IBOutlet weak var netVoteLabel: UILabel!
    
    
    var post: Post! {
        didSet{
            self.updateUI()
        }
    }
    
    
    func updateUI() {
        self.netVoteLabel.text = String(post.netVotes)
        upvoteButton.setBackgroundImage(UIImage(named: "UpVote Neutral"), for: UIControlState.normal)
        downvoteButton.setBackgroundImage(UIImage(named: "DownVote Neutral"), for: UIControlState.normal)
        upvoteButton.setBackgroundImage(UIImage(named: "Upvote Pressed"), for: UIControlState.selected)
        downvoteButton.setBackgroundImage(UIImage(named: "Downvote Pressed"), for: UIControlState.selected)
        let imgNSURL = NSURL(string: post.imgURL)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: imgNSURL as! URL)
            DispatchQueue.main.async {
                self.postImage.image = UIImage(data: data!)
            }
        }
        
    }

    @IBAction func upvoteButtonPressed(_ sender: UIButton) {
    let imageID = post.key
    let ref = FIRDatabase.database().reference().child("Lics").child("\(imageID)").child("netVotes")
        ref.runTransactionBlock({ (currentData: FIRMutableData!) in
        
        var value = currentData.value as? Int
            if value == nil {
                value = 0
            }
        currentData.value = value! + 1
        return FIRTransactionResult.success(withValue: currentData)
        
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
    
        }
    downvoteButton.setBackgroundImage(UIImage(named: "DownVote Not Pressed"), for: UIControlState.normal)
    
        
    }
    

    @IBAction func downvoteButtonPressed(_ sender: UIButton) {
        let imageID = post.key
        let ref = FIRDatabase.database().reference().child("Lics").child("\(imageID)").child("netVotes")
        ref.runTransactionBlock({ (currentData: FIRMutableData!) in
            
            var value = currentData.value as? Int
            if value == nil {
                value = 0
            }
            currentData.value = value! - 1
            return FIRTransactionResult.success(withValue: currentData)
            
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
            
        }
    upvoteButton.setBackgroundImage(UIImage(named: "UpVote Not Pressed"), for: UIControlState.normal)
    
        
    }
    
    
    
}
