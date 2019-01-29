//
//  RegisterViewController.swift
//  Wisk_App
//
//  Created by Michael Westbrooks II on 2/24/17.
//  Copyright © 2017 redroostertechnologiesinc. All rights reserved.
//

import UIKit
import ChameleonFramework
import Firebase
import SVProgressHUD
import ZAlertView

class RegisterViewController: UIViewController {

    @IBOutlet var firstname: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var create: UIButton!
    @IBOutlet var cancel: UIButton!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    
    let defaults = UserDefaults.standard
    var ref:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = .default
        
        firstname.delegate = self
        email.delegate = self
        password.delegate = self
        
        create.layer.cornerRadius = 5
        cancel.layer.cornerRadius = 5
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    
    //  MARK:- UI Actions
    
    @IBAction func createAction(_ sender: Any) {
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func credentialsCheck() {
        if email.text?.isEmpty == false ||
            password.text?.isEmpty == false ||
            firstname.text?.isEmpty == false {
            
            let alert = UIAlertController(title: "Alert",
                                          message: AuthenticationErrorTextFieldsEmpty,
                                          preferredStyle: .alert)
            
            let done = UIAlertAction(title: "Ok",
                                     style: .default,
                                     handler: {
                                        action in
                                        alert.dismissViewController()
            })
            alert.addAction(done)
            self.present(alert,
                         animated: true,
                         completion: nil)
        } else {
            signUp(email: email.text!,
                   password: password.text!,
                   firstname: firstname.text! )
        }
    }
    
    func signUp(email: String, password: String, firstname: String) {
        Auth.auth().createUser(withEmail: email,
                               password: password,
                               completion: {
                                (result, error) in
                                
                                if error == nil {
                                    
                                    Auth.auth().signIn(withEmail: email,
                                                       password: password,
                                                       completion: {
                                                        (authData, error) in
                                                        
                                                        if error == nil,
                                                            let authData = authData
                                                        {
                                                            
                                                            let newUser : [String: Any] = [
                                                                "acctType" : 1,
                                                                "email" : email,
                                                                "firstName" : firstname,
                                                                ]
                                                            
                                                            self.ref.child("users").child(authData.user.uid).setValue(newUser)
                                                            
                                                            
                                                            
                                                        } else {
                                                            let dialog2 = ZAlertView(title: "Alert", message: "\(error!.localizedDescription)",  closeButtonText: "Ok", closeButtonHandler: {
                                                                alertView in
                                                                
                                                                alertView.dismissAlertView()
                                                            })
                                                            SVProgressHUD.dismiss()
                                                            dialog2.show()
                                                        }
                                    })
                                } else {
                                    let dialog2 = ZAlertView(title: "Alert", message: "\(error!.localizedDescription)",  closeButtonText: "Ok", closeButtonHandler: {
                                        alertView in
                                        
                                        alertView.dismissAlertView()
                                    })
                                    SVProgressHUD.dismiss()
                                    dialog2.show()
                                }
                                
        })
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        credentialsCheck()
        return true
    }
    
}
