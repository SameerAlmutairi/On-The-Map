//
//  LoginViewController.swift
//  On The Map
//
//  Created by Sameer Almutairi on 16/05/2019.
//  Copyright © 2019 Sameer Almutairi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
    }

    @IBAction func signupTapped(_ sender: Any) {
        setLoggingIn(true)
        DispatchQueue.main.async {
            let url = URL(string: "https://www.udacity.com/account/auth#!/signup")
            UIApplication.shared.open(url!, options: [:])
        }
    }
    @IBAction func loginTapped(_ sender: Any) {
        self.setLoggingIn(true)
        if emailTextField.text == "" || passwordTextField.text == "" {
            Utilities.displayAlertMessage(viewController: self, title: "", message: "Empy Email or Password")
            return
        }
        let udacity = Udacity(username: emailTextField.text ?? "" , password: passwordTextField.text ?? "")
        UdacityClient.login(udacity: udacity) { (response, error) in
            if response!.account?.registered == true {
                UserDefaults.standard.set(response?.account?.key, forKey: "accountKey")
                self.performSegue(withIdentifier: "SuccessfullLogin", sender: nil)
            }
            else if response?.status == 403 {
                self.setLoggingIn(false)
                // add display alert
                Utilities.displayAlertMessage(viewController: self, title: "", message: "Incorrect Username or Password")
            }
            else if response == nil {
                self.setLoggingIn(false)
                Utilities.displayAlertMessage(viewController: self, title: "", message: "Faild to Login")
            }
        }
    }

    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
        signupButton.isEnabled = !loggingIn
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


