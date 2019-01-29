//
//  ComposeUpdateViewController.swift
//  Wisk_App
//
//  Created by Michael Westbrooks II on 7/20/16.
//  Copyright © 2016 redroostertechnologiesinc. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import Firebase
import ZAlertView
import SVProgressHUD
import MessageUI

var categoryCoordinate = CLLocationCoordinate2D()

class ComposeUpdateViewController: UIViewController,
    UITextFieldDelegate,
    CLLocationManagerDelegate,
    UITextViewDelegate,
    UITableViewDelegate,
    UITableViewDataSource {

    @IBOutlet var commentTextView: UITextView!
    @IBOutlet var resultsTableView: UITableView!
    @IBOutlet var cancel: UIButton!
    @IBOutlet var submitUpdate: UIButton!
    
    var category : String = ""
    var ref : DatabaseReference!
    var refUpdates : DatabaseReference!
    let defaults = UserDefaults.standard
    var categoryArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: true)
        ref = Database.database().reference().child("categories")
        refUpdates = Database.database().reference()
        
        commentTextView.delegate = self
        submitUpdate.layer.cornerRadius = submitUpdate.frame.height / 2
        
        /*self.ref.observe(.Value, with: {
            snapshot in
            for item in snapshot.children {
                let child = item
                self.categoryArray.append(child.key)
            }
            self.resultsTableView.reloadData()
        })*/
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(categoryCoordinate)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = resultsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = categoryArray[indexPath.row]
        cell.textLabel?.text = item
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tagIndex = resultsTableView.indexPathForSelectedRow?.row
        let content = categoryArray[tagIndex!] as String
        category = content
    }
    
    @IBAction func sendAction(_ sender: AnyObject) {
        SVProgressHUD.show()
        if commentTextView.text == nil || commentTextView.text == "" || commentTextView.text == "Start Typing" || category == "" {
            
            // HANDLE MESSAGE

            let dialog = ZAlertView(title: "Error", message: "Please type your update in the message box.", isOkButtonLeft: true, okButtonText: "Ok", cancelButtonText: "Cancel", okButtonHandler: {
                alertView in
                
                alertView.dismissAlertView()
                }, cancelButtonHandler: {
                    alertView in
                    alertView.dismissAlertView()
            })
            dialog.show()
            SVProgressHUD.dismiss()
            
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a MM/dd/yyyy"
            let theDate = formatter.string(from: Date())
            
            let updateObject : [String:Any] = [
                "user" : Auth.auth().currentUser!.uid as String,
                //  "userName" : self.defaults.objectForKey("firstName") as! String,
                //  "airportCode" : airport!.key,
                "date" : theDate,
                "update" : commentTextView.text!,
                "category" : category,
                "lat" : categoryCoordinate.latitude,
                "lon" : categoryCoordinate.longitude,
                ]
            
            refUpdates.child("updates").childByAutoId().setValue(updateObject)
            
            category = ""
            self.view.endEditing(true)
            categoryCoordinate = CLLocationCoordinate2D()
            
            SVProgressHUD.dismiss()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        commentTextView.text = ""
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            commentTextView.resignFirstResponder()
            return false
        }
        return true
    }
    
}
