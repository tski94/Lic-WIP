//
//  FeedTableViewController.swift
//  Lic
//
//  Created by Ivor D. Addo on 4/6/17.
//  Copyright © 2017 Marquette University. All rights reserved.
//

import UIKit
import Firebase
import Foundation
import SystemConfiguration
import CoreLocation
import MobileCoreServices

class FeedTableViewController: UITableViewController, CLLocationManagerDelegate {

    
    @IBOutlet weak var locationlabel: UILabel!
    var userLong: Double!
    var userLat: Double!
    var locationManager: CLLocationManager!
    var location: CLLocation! {
        didSet {
            userLong = location.coordinate.longitude
            userLat = location.coordinate.latitude
        }
    }
    var posts: [Post]?
    let ref = FIRDatabase.database().reference(withPath: "Lics")
    var locationName: String!
    
    
    
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
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

// MARK - Firebase Call
    
    func loadDataFromFirebase() {
        
        ref.queryEqual(toValue: self.locationName, childKey: "locationName").observe(.value, with: { snapshot in
            var newposts: [Post] = []
            
            for dbItem in snapshot.children.allObjects {
                let postItem = (snapshot: dbItem as! FIRDataSnapshot)
                
                let newValue = Post(snapshot: postItem)
                newposts.append(newValue)
            }
            
            //TO-DO SORT BY NETVOTES
            self.posts = newposts
            self.tableView.reloadData()
            
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        checkCoreLocationPermission()
        
    }
    
//MARK -- Location Services
    func checkCoreLocationPermission() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        if CLLocationManager.authorizationStatus() == .restricted  {
            //TODO: Make an Alert
            print("Unauthorized")
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
        locationManager.stopUpdatingLocation()
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
            if error != nil {
                print("There was an error!")
            } else {
                if (placemark?.count)! > 0 {
                    let pm = (placemark?[0])! as CLPlacemark
                    self.locationName = "\(String(describing: pm.name!))"
                    self.locationlabel.text = self.locationName
                    
                }
                
                
            }
        }
    }
    
    @IBAction func refreshBtnPressed(_ sender: UIBarButtonItem) {
        self.quickLocationUpdate()
        
    }
    func quickLocationUpdate() {
        locationManager.startUpdatingLocation()
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
