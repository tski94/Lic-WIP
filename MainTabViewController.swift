//
//  MainTabViewController.swift
//  Lic
//
//  Created by Ivor D. Addo on 4/13/17.
//  Copyright © 2017 Marquette University. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = UIColor(red:0.75, green:0.76, blue:0.78, alpha:1.0)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }

}
