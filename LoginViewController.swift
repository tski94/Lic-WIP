//
//  LoginViewController.swift
//  Lic
//
//  Created by Ivor D. Addo on 2/23/17.
//  Copyright © 2017 Marquette University. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {

        self.showProgress()
        if let email = emailTextField.text, let password = passwordTextField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user,error) in
                //...
                //if signin is successful we have a "user" value
                if user != nil {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Welcome")
                    self.present(vc!, animated:true, completion:nil)
                    
                }
                else {
                    let alertController = UIAlertController(title: "Login Failed!", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default) {
                        (result : UIAlertAction) -> Void in
                        print("Ok")
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated:true, completion: nil)
                    self.hideProgress()
                }
            }
        }
    
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.hideProgress()
        if FIRAuth.auth()?.currentUser != nil {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Welcome")
            self.present(vc!, animated: true, completion: nil)
        }
        
        
    }
    
    func showProgress() { //Show Activity Indicator
        loginActivityIndicator.isHidden = false
        loginButton.isHidden = true
        
    }
    func hideProgress() { //Hide activity indicator. Insert function where need be
        loginActivityIndicator.isHidden = true
        loginButton.isHidden = false
        
    }
    
}
