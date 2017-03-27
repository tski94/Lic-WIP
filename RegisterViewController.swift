//
//  RegisterViewController.swift
//  Lic
//
//  Created by Ivor D. Addo on 2/23/17.
//  Copyright © 2017 Marquette University. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var registerEmailTextField: UITextField!
    @IBOutlet weak var registerPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var registerActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        //Check if Password and Confirm Password Fields match
        self.showProgress()
        if (registerPasswordTextField.text != confirmPasswordTextField.text) {
            let pwAlertConfirm = UIAlertController(title: "Registration Failed", message: "Passwords Must Match", preferredStyle: UIAlertControllerStyle.alert)
            let pwOkAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
                print("ok")
            }
            pwAlertConfirm.addAction(pwOkAction)
            self.present(pwAlertConfirm, animated: true, completion: nil)
            self.hideprogress()
        }
            
        else {
            //Register the User
        if let email = registerEmailTextField.text, let password = registerPasswordTextField.text
         {
            FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            //... 
            // if registration is successful then we should have a valid "user" value
                if user != nil {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Welcome")
                    self.present(vc!, animated:true, completion:nil)
                }
                else {
                    let alertController = UIAlertController(title: "Registration Failed", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default) {
                        (result : UIAlertAction) -> Void in
                        print("Ok")
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated:true, completion: nil)
                    self.hideprogress()
                }

        }
    }

   }
}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        registerEmailTextField.resignFirstResponder()
        registerPasswordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
    }
    
    func hideprogress() { //Hide activity indicator
        registerActivityIndicator.isHidden = true
        registerButton.isHidden = false
    }
    
    func showProgress() { //Show activity indicator
        registerActivityIndicator.isHidden = false
        registerButton.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        self.hideprogress()
    }
}
