//
//  Post.swift
//  Lic
//
//  Created by Ivor D. Addo on 4/6/17.
//  Copyright © 2017 Marquette University. All rights reserved.
//

import Foundation
import Firebase

struct Post  {
    
    let key: String
    let ref: FIRDatabaseReference?
    let netVotes: Int
    let imgURL: String
    let imgLat: Double
    let imgLong: Double
    let userID: String
    
    init(netVotes: Int, imgURL: String, imgLat: Double, imgLong: Double, userID: String, key: String = "") {
        self.key = key
        self.imgLat = imgLat
        self.imgLong = imgLong
        self.imgURL = imgURL
        self.userID = userID
        self.netVotes = netVotes
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String:AnyObject]
        netVotes = snapshotValue["netVotes"] as! Int
        imgURL = snapshotValue["pathtoimage"] as! String
        imgLat = snapshotValue["latitude"] as! Double
        imgLong = snapshotValue["longitude"] as! Double
        userID = snapshotValue["userID"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "netVotes": netVotes,
            "imgURL": imgURL,
            "imgLat": imgLat,
            "imgLong": imgLong,
            "userID": userID
        ]
    }
    
}
