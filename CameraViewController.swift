//
//  CameraViewController.swift
//  Lic
//
//  Created by Ivor D. Addo on 3/5/17.
//  Copyright © 2017 Marquette University. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import Foundation
import SystemConfiguration
import CoreLocation

class CameraViewController: UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    CLLocationManagerDelegate
    
{
    var userLong: Double!
    var userLat: Double!
    var storageRef = FIRStorageReference()
    @IBOutlet weak var selectedImage: UIImageView!
    var locationManager: CLLocationManager!
    var location: CLLocation! {
        didSet{
            userLong = location.coordinate.longitude
            userLat = location.coordinate.latitude
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        checkCoreLocationPermission()
    }
    
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
    }
    
    //Take a picture
    @IBAction func takeAPicture(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imgPicker = UIImagePickerController()
            imgPicker.delegate = self
            imgPicker.sourceType = .camera
            imgPicker.allowsEditing = false
            //show the camera app
            self.present(imgPicker, animated: true, completion: nil)
            
        }
        
    }
    
    //Choose a picture from your library
    @IBAction func chooseAPicture(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imgPicker = UIImagePickerController()
            imgPicker.delegate = self
            imgPicker.sourceType = .photoLibrary
            imgPicker.allowsEditing = false //Allow Editing (cropping etc)
            //show the Photo Library
            self.present(imgPicker, animated: true, completion: nil)
            
        }
        
    }
    
    //Saves picture to gallery and Database
    @IBAction func savePicture(_ sender: UIBarButtonItem) {
        //Check Internet
        if isInternetAvailable() == true{
        
       //Checks to make sure a picture is selected
        if selectedImage.image != nil {
        locationManager.startUpdatingLocation()
        let imageData = UIImageJPEGRepresentation(selectedImage.image!, 0.6) //Compression Quality
        let compressedJPEG  = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedJPEG!, nil, nil, nil)
        
        //Save to Firebase
        let uid = FIRAuth.auth()!.currentUser!.uid //UserID
            
        let ref = FIRDatabase.database().reference()
        let storage = FIRStorage.storage().reference(forURL: "gs://lic-app-95481.appspot.com") //Storage Path
            
    //    let geofireRef = FIRDatabase.database().reference().child("Lics").child(uid) //Geolocation
       // let geoFire = GeoFire(firebaseRef: geofireRef)
        let key = ref.child("Lics").childByAutoId().key
    //geoFire?.setLocation(CLLocation(latitude: userLat!, longitude: userLong!), forKey: "\(key)")
        let imageRef = storage.child("Lics").child(uid).child("\(key).jpg")
        
        let data = UIImageJPEGRepresentation(self.selectedImage.image!, 0.6)
        
        _ = imageRef.put(data!, metadata: nil) { (metadata, error) in
            if error != nil {
                //TO-DO Create Error Message
                print(error!.localizedDescription)
                return
            }
            imageRef.downloadURL(completion: { (url, error) in
                if let url = url {
                    let feed = ["userID" : uid,
                                "pathtoimage" : url.absoluteString,
                                "netVotes" : 0,
                    "postID" : key,
                    "userEmail" : FIRAuth.auth()!.currentUser!.email as Any] as [String: Any]
                    
                    let postFeed = ["\(key)" : feed]
                    
                    ref.child("Lics").updateChildValues(postFeed)
                    
                }
                 })
            }
    savePhotoAlert() //Alert saying the photo has been saved
    clearImage() //Clears the image preview so that
        } else {
            let ac = UIAlertController(title: "Lic not submitted", message: "You must take a Lic to submit it!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
            
        }
        } else {
            let alertInternet = UIAlertController(title: "No Internet Connection", message: "You must connect to the internet in order to post!", preferredStyle: .alert)
            alertInternet.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alertInternet, animated: true)
        }
}
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imgImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage.image = imgImage
        } else {
            print("Something went wrong, check with support and try again")
        }
        dismiss(animated: true, completion: nil)
    }
    
    //Add cancel button
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: {_ in})
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    //Clears imageView screen
    func clearImage() {
        selectedImage.image = nil
    }
    
    //Photo Posted Alert
    func savePhotoAlert() {
        let ac = UIAlertController(title: "Lic Submitted!", message: "Your Lic was submitted", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    
    //Check for Internet
    func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        })else {
            return false
        }
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    

}
