//
//  MainViewController.swift
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

class MainViewController: UIViewController {
    
    @IBOutlet var cancel: UIButton!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var login: UIButton!
    @IBOutlet var create: UIButton!
    @IBOutlet var forgot: UIButton!

    let defaults = UserDefaults.standard
    var ref:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email.delegate = self
        password.delegate = self
        
        login.layer.cornerRadius = 5
        create.layer.cornerRadius = 5
        
        self.ref = Database.database().reference()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }

    //  MARK:- UI Actions

    @IBAction func loginAction(_ sender: Any) {
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//        let vc = sb.instantiateViewController(withIdentifier: "airportMain")
//        self.present(vc, animated: true, completion: nil)
        credentialsCheck()
    }
    
    @IBAction func createAction(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "createVC")
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func forgotAction(_ sender: Any) {
        
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.dismissViewController()
    }
    
    func credentialsCheck() {
        if email.text?.isEmpty == false ||
            password.text?.isEmpty == false
        {
            
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
            self.login(email: email.text!,
                  password: password.text!)
        }
    }
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email,
                           password: password,
                           completion: {
                            (authData, error) in
                            
                            if error == nil {
                               
                                
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

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
