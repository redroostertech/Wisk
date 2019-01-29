//
//  AirportMainViewController.swift
//  Wisk_App
//
//  Created by Michael Westbrooks II on 2/24/17.
//  Copyright © 2017 redroostertechnologiesinc. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import SVProgressHUD
import ZAlertView
import SearchTextField
import IQKeyboardManager

class AirportMainViewController: UIViewController {

    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var locationImage: UIImageView!
    @IBOutlet var airportField: SearchTextField!
    @IBOutlet var goButton: UIButton!
    
    var airportsService: AirportsService!
    var categoriesService: CategoriesService!
    var locationManager = CLLocationManager()
    var geoCoder : CLGeocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupUI()
        setupDelegates()
        setupLocationDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    
    @IBAction func goButtonAction(_ sender: UIButton) {
        airportSearchFieldCheck()
    }
}

extension AirportMainViewController {
    func loadData() {
        self.airportsService = AirportsService.shared
        self.airportsService.retrieveAllActiveAirports {
            (airports) in
            if let airports = airports {
                self.getAirportNames(fromArray: airports,
                                     whichReturnsArray: {
                    (names) in
                    if let names = names {
                        self.airportField.filterStrings(names)
                    } else {
                        print("Wisk | Error with getAirportNames. No names available")
                    }
                })
            } else {
                print("Wisk | Error with airportsService.retrieveAllActiveAirports. No airports available")
            }
        }
        self.categoriesService = CategoriesService.shared
        self.categoriesService.retrieveAllCategories{
            (categories) in
            if categories != nil {
                print("Done retrieving categories.")
            } else {
                print("Wisk | Error with categoriesService. No categories available")
            }
        }
    }
    func setupDelegates() {
        locationManager.delegate = self
        airportField.delegate = self
    }
    func setupUI(){
        showHUD()
        locationImage.layer.cornerRadius = 5
        goButton.layer.cornerRadius = 5
        airportField.theme.font = UIFont.systemFont(ofSize: 18)
        self.airportField.startVisible = true
    }
    func setupLocationDelegate() {
        let authStatus: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        if authStatus == .denied || authStatus == .restricted {
            self.locationManager.requestWhenInUseAuthorization()
            
        }
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.requestLocation()
    }
    
    func getAirportNames(fromArray airports: [WKAirport]?, whichReturnsArray completion: ([String]?) -> Void) {
        guard let airports = airports else {
            completion(nil)
            return
        }
        completion(airports.flatMap({$0.name as? String}))
    }
    
    func goToAirport(_ airport: WKAirport) {
        let sb = UIStoryboard(name: "Main",
                              bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "mainNavigation") as!UINavigationController
        let rootVC = vc.viewControllers[0] as! AirportFloorplanViewController
        rootVC.airport = airport
        rootVC.categories = self.categoriesService.categories
        present(vc, animated: true, completion: {
            
            UserDefaults.standard.set(airport.object_Id, forKey: kAirportId)
            
            DispatchQueue.main.async {
                self.airportField.clearText()
            }
        })
    }
    func airportSearchFieldCheck() {
        if airportField.text?.isEmpty == false,
            let airportArray = self.airportsService.airports
        {
            for airport in airportArray {
                if let name = airport.name as? String,
                    name.contains(airportField.text!)
                {
                    let alertText = String(format: "Go to %@?",
                                           String(describing: airport.name ?? "airport"))
                    
                    let alert = UIAlertController(title: "Wisk",
                                                  message: alertText,
                                                  preferredStyle: .alert)
                    
                    let done = UIAlertAction(title: "Yes",
                                             style: .default,
                                             handler: {
                                                action in
                                                self.goToAirport(airport)
                    })
                    
                    let cancel = UIAlertAction(title: "Nevermind",
                                               style: .destructive,
                                               handler: {
                                                action in
                                                DispatchQueue.main.async {
                                                    self.airportField.clearText()
                                                }
                                                alert.dismissViewController()
                    })
                    alert.addAction(cancel)
                    alert.addAction(done)
                    self.present(alert,
                                 animated: true,
                                 completion: nil)
                }
            }
        } else {
            //  Handle Error
        }
    }
}

extension AirportMainViewController: UITextFieldDelegate {
    //  MARK:- TextField Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        airportSearchFieldCheck()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        airportSearchFieldCheck()
    }
}

extension AirportMainViewController: CLLocationManagerDelegate {
    //  MARK:- Core Location Delegate methods
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let newLocation = locations.last!
        self.geoCoder.reverseGeocodeLocation(newLocation,
                                             completionHandler: {
            (placeMarks, error) -> Void in
            if error == nil {
                if placeMarks!.count > 0 {
                    let placeMark = placeMarks!.last!
                    self.locationLabel.text = String(placeMark.addressDictionary!["City"] as! NSString)
                    self.locationManager.stopUpdatingLocation()
                   
                    self.view.isUserInteractionEnabled = true
                }
            } else {
                let alert = ZAlertView(title: "Error", message: "There was an error retrieving your location. Please make sure that location permissions are enabled for Wisk.", closeButtonText: "Ok", closeButtonHandler: {
                    alertView in
                    
                    alertView.dismissAlertView()
                    self.view.isUserInteractionEnabled = true
                })
                alert.show()
            }
            self.hideHUD()
        })
    }
}
