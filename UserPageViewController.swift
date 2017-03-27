//
//  UserPageViewController.swift
//  Lic
//
//  Created by Ivor D. Addo on 3/6/17.
//  Copyright © 2017 Marquette University. All rights reserved.
//

import UIKit
import Firebase

class UserPageViewController: UIViewController {

    
    @IBOutlet var settingsView: UIView!
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    var effect: UIVisualEffect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        settingsView.layer.cornerRadius = 5
        
    }
    
    func animateIn() { //Code for the pop up appearing
        self.view.addSubview(settingsView)
        settingsView.center = self.view.center
        
        settingsView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        settingsView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.settingsView.alpha = 1
            self.settingsView.transform = CGAffineTransform.identity
            
        }
        
        
    }
    
    func animateOut() { //Code for the pop up disappearing
        UIView.animate(withDuration: 0.3, animations: {
            self.settingsView.transform = CGAffineTransform.init(scaleX: 1.3, y:1.3)
            self.settingsView.alpha = 0
            
            self.visualEffectView.effect = nil
            
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
