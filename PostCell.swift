//
//  PostCell.swift
//  Lic
//
//  Created by Ivor D. Addo on 4/6/17.
//  Copyright © 2017 Marquette University. All rights reserved.
//

import UIKit

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
        let imgNSURL = NSURL(string: post.imgURL)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: imgNSURL as! URL)
            DispatchQueue.main.async {
                self.postImage.image = UIImage(data: data!)
            }
        }
        
    }

}
