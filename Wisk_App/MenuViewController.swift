//
//  MenuViewController.swift
//  Wisk_App
//
//  Created by Michael Westbrooks on 6/17/18.
//  Copyright © 2018 redroostertechnologiesinc. All rights reserved.
//

import UIKit
import ChameleonFramework

class MenuViewController: UIViewController {

    @IBOutlet var authenticationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func authenticate(_ sender: UIButton) {
        checkAuth()
    }
    
    @IBAction func createUpdateAction(_ sender: UIButton) {
        
    }
    
    @IBAction func myProfileAction(_ sender: UIButton) {
        
    }
    
    @IBAction func settingAction(_ sender: UIButton) {
        
    }
}

extension MenuViewController {
    func setupInterface() {
        self.navigationController?.hidesNavigationBarHairline = true
        authCheck()
    }
    
    func authCheck() {
        if
            let authValue = UserDefaults.standard.value(forKey: "loggedIn") as? Bool,
            authValue == true {
            authenticationButton.setTitle("Sign Out",
                                          for: .normal)
        } else {
            authenticationButton.setTitle("Sign In",
                                          for: .normal)
        }
    }
    
    func checkAuth() {
        if
            let authValue = UserDefaults.standard.value(forKey: "loggedIn") as? Bool,
            authValue == true {
            self.logout()
        } else {
            self.login()
        }
    }
    
    func logout() {
        print("Logout")
    }
    
    func login() {
        showView(withID: "loginVC")
    }
}
