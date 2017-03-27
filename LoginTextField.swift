//
//  LoginTextField.swift
//  Lic
//
//  Created by Ivor D. Addo on 3/14/17.
//  Copyright © 2017 Marquette University. All rights reserved.
//

import UIKit

@IBDesignable
class LoginTextField: UITextField {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.borderColor = UIColor(white: 255 / 255, alpha: 1).cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 20.0
        self.layer.backgroundColor = UIColor(white: 255 / 255, alpha: 1).cgColor
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0.0, height: 30.0)
        self.layer.shadowRadius = 20.0
        
    }
    

}
