//
//  PopUpViewController.swift
//  Lic
//
//  Created by Ivor D. Addo on 3/6/17.
//  Copyright © 2017 Marquette University. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closePopUp(_ sender: UIButton) {
        self.view.removeFromSuperview()
    }
    
    func showAnimate() {
        
    }

}
