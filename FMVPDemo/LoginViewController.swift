//
//  LoginViewController.swift
//  FMVPDemo
//
//  Created by Alexey Demedetskii on 10/3/16.
//  Copyright © 2016 dalog. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {
    @IBOutlet private var usernameField: UITextField!
    @IBOutlet private var passwordField: UITextField!
    @IBOutlet private var loginButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func login() {
        let username = usernameField.text
        let password = passwordField.text
        
        view.endEditing(true)
        activityIndicator.startAnimating()
        self.loginButton.isEnabled = false
        DispatchQueue.global(qos: .background).asyncAfter(deadline: DispatchTime.now() + .seconds(3)) {
            // WARNING: emulation of server side code
            if username == "mobiconf" && password == "rocks!" {
                // Handle success
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.loginButton.isEnabled = true
                    self.performSegue(withIdentifier: "show timers", sender: self)
                }
            } else {
                // Handle fail
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.loginButton.isEnabled = true
                    let alert = UIAlertController(
                        title: "Incorrect user",
                        message: "User is incorrect. Please login again",
                        preferredStyle: .alert)
                    alert.addAction(.init(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        }
    }
}
