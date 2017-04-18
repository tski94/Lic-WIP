//
//  PostCell.swift
//  Lic
//
//  Created by Ivor D. Addo on 4/6/17.
//  Copyright © 2017 Marquette University. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

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
    
    var upBtnPressed: Bool = false
    var downBtnPressed: Bool = false
    
    func updateUI() {
        self.netVoteLabel.text = String(post.netVotes)
        let imgNSURL = NSURL(string: post.imgURL)
        postImage.sd_setImage(with: imgNSURL as URL?)
        
    }

//MARK- BUTTON LOGIC 
// To-Do: Make sure all bugs are fixed in Button System 
    
    @IBAction func upvoteButtonPressed(_ sender: UIButton) {
        let imageID = post.key
        let ref = FIRDatabase.database().reference().child("Lics").child("\(imageID)").child("netVotes")

        if sender.currentImage == #imageLiteral(resourceName: "Up Squared-100") {
            upBtnPressed = true
            downBtnPressed = false
            sender.setImage(#imageLiteral(resourceName: "Up Squared Filled-100"), for: .normal)
            downvoteButton.setImage(#imageLiteral(resourceName: "Down Squared-100"), for: .normal)
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
        } else if sender.currentImage == #imageLiteral(resourceName: "Up Squared Filled-100") {
            upBtnPressed = false
            sender.setImage(#imageLiteral(resourceName: "Up Squared-100"), for: .normal)
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

        } else if downBtnPressed == true {
            upBtnPressed = true
            downBtnPressed = false
            sender.setImage(#imageLiteral(resourceName: "Up Squared Filled-100"), for: .normal)
            ref.runTransactionBlock({ (currentData: FIRMutableData!) in
                
                var value = currentData.value as? Int
                if value == nil {
                    value = 0
                }
                currentData.value = value! + 2
                return FIRTransactionResult.success(withValue: currentData)
                
            }) { (error, committed, snapshot) in
                if let error = error {
                    print(error.localizedDescription)
                }
                
            }

        }
    
        
    }
    

    @IBAction func downvoteButtonPressed(_ sender: UIButton) {
        let imageID = post.key
        let ref = FIRDatabase.database().reference().child("Lics").child("\(imageID)").child("netVotes")

        if sender.currentImage == #imageLiteral(resourceName: "Down Squared-100") {
            upBtnPressed = false
            downBtnPressed = true
            sender.setImage(#imageLiteral(resourceName: "Down Squared Filled-100"), for: .normal)
            upvoteButton.setImage(#imageLiteral(resourceName: "Up Squared-100"), for: .normal)
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
            
        } else if sender.currentImage == #imageLiteral(resourceName: "Down Squared Filled-100"){
            downBtnPressed = false
            sender.setImage(#imageLiteral(resourceName: "Down Squared-100"), for: .normal)
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
    
        
        } else if upBtnPressed == true {
            downBtnPressed = true
            upBtnPressed = false
            ref.runTransactionBlock({ (currentData: FIRMutableData!) in
                
                var value = currentData.value as? Int
                if value == nil {
                    value = 0
                }
                currentData.value = value! - 2
                return FIRTransactionResult.success(withValue: currentData)
                
            }) { (error, committed, snapshot) in
                if let error = error {
                    print(error.localizedDescription)
                }
                
            }

        }
    
    
    }
}
