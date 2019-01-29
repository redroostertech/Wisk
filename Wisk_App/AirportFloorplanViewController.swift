//
//  AirportFloorplanViewController.swift
//  Wisk_App
//
//  Created by Michael Westbrooks II on 9/3/17.
//  Copyright © 2017 redroostertechnologiesinc. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import TBDropdownMenu
import SVProgressHUD
import Firebase
import SideMenu

class UpdatesCell: UITableViewCell {
    @IBOutlet var userLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var messageLbl: UILabel!
    @IBOutlet var voteCountLbl: UILabel!
    @IBOutlet var upVoteBtn: UIButton!
    @IBOutlet var downVoteBtn: UIButton!
    var delegate: UpdateInteractionDelegate?
    @IBAction func upVote(_ sender: UIButton) {
        delegate?.upVote(sender)
    }
    
    @IBAction func downVote(_ sender: UIButton) {
        delegate?.downVote(sender)
    }
}

protocol UpdateInteractionDelegate {
    func upVote(_ sender: UIButton)
    func downVote(_ sender: UIButton)
}

class AirportFloorplanViewController: UIViewController {

    @IBOutlet weak var map: GMSMapView!
    
    @IBOutlet weak var airportsContainer: UIBarButtonItem!
    @IBOutlet weak var airports: UIButton!
    @IBOutlet weak var concourseContainer: UIBarButtonItem!
    @IBOutlet weak var concourse: UIButton!
    @IBOutlet weak var filtersContainer: UIBarButtonItem!
    @IBOutlet weak var filters: UIButton!
    
    @IBOutlet var menu: UIButton!
    @IBOutlet var tblMain: UITableView!
    @IBOutlet var tblMainHeight: NSLayoutConstraint!
    @IBOutlet var btnToggleTable: UIButton!
    
    var airport: WKAirport!
    var categories: [WKCategory]?
    var concourseMenuView: DropdownMenu?
    var concourseMenutems: [[DropdownItem]]?
    var filtersMenuView: DropdownMenu?
    var filtersMenutems: [[DropdownItem]]?
    var group = DispatchGroup()
    var selectedRow: Int = 0
    var selectedIndexPath: IndexPath = IndexPath(row: 0, section: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
        setupConcourseDropDown()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func loadMapUsing(lattitudePoints lat: CLLocationDegrees, andLongitudePoints long: CLLocationDegrees) {
        SVProgressHUD.show()
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 20)
        map.camera = camera
        SVProgressHUD.dismiss()
    }
    
    @IBAction func showConcourses(_ sender: Any) {
        self.concourseMenuView?.showMenu()
    }
    @IBAction func goToAirportSelection(_ sender: UIButton) {
        dismissViewController()
    }
    @IBAction func showFIlters(_ sender: UIButton) {
        setupFiltersDropDown()
    }
    @IBAction func showMenu(_ sender: UIButton) {
        showView(withID: "menuManger")
    }
    @IBAction func toggleTableView(_ sender: UIButton) {
        print(self.tblMainHeight.constant)
        if self.tblMainHeight.constant < 51 {
            self.btnToggleTable.setTitle("Hide",
                                         for: .normal)
            self.tblMainHeight.constant += 300
        } else if self.tblMainHeight.constant > 51 {
            self.btnToggleTable.setTitle("Show",
                                         for: .normal)
            self.tblMainHeight.constant -= 300
        }
    }
    
}

extension AirportFloorplanViewController {
    func setupUI() {
        SideMenuManager.default.menuFadeStatusBar = false
        setupMenuButtons()
        tblMain.delegate = self
        tblMain.dataSource = self
        tblMain.estimatedRowHeight = UITableViewAutomaticDimension
        tblMain.rowHeight = 100
        tblMain.reloadData()
    }
    func setupMenuButtons() {
        let buttonSize = CGSize(width: 32,
                                height: 32)
        
        let menuImage = UIImage(named: "menu")!.imageResize(sizeChange: buttonSize)
        self.menu.setImage(menuImage,
                           for: .normal)
        self.menu.tintColor = .white
        
        let concourseImage = UIImage(named: "concourse")!.imageResize(sizeChange: buttonSize)
        self.concourse.setImage(concourseImage,
                           for: .normal)
        self.concourse.tintColor = .white
        
        let airportImage = UIImage(named: "airport")!.imageResize(sizeChange: buttonSize)
        self.airports.setImage(airportImage,
                               for: .normal)
        self.airports.tintColor = .white
        
        let filterImage = UIImage(named: "filter")!.imageResize(sizeChange: buttonSize)
        self.filters.setImage(filterImage,
                               for: .normal)
        self.filters.tintColor = .white
        
    }
    func loadData() {
        loadMapUsing(lattitudePoints: airport.getLatitudePoints(), andLongitudePoints: airport.getLongitudePoints())
        
    }
    func setupConcourseDropDown() {
        var menuItems = [DropdownItem]()
        if let itemArray = self.airport.getConcourses() {
            for item in itemArray {
                self.group.enter()
                let item = DropdownItem(title: item.getConcourseName())
                menuItems.append(item)
                self.group.leave()
            }
        }
        self.group.notify(queue: .main) {
            if let navController = self.navigationController {
                self.concourseMenuView = DropdownMenu(navigationController: navController, items: menuItems, selectedRow: self.selectedRow)
                self.concourseMenuView?.delegate = self
                self.concourseMenuView?.rowHeight = 50
            }
        }
    }
    func setupFiltersDropDown() {
        var menuItems = [DropdownItem]()
        if let itemArray = self.categories {
            print("Adding category to menu")
            print("Filters are: ", itemArray)
            for item in itemArray {
                self.group.enter()
                let item = DropdownItem(title: item.getCategoryName())
                print(item.title)
                menuItems.append(item)
                self.group.leave()
            }
        } else {
            print("No data")
        }
        self.group.notify(queue: .main) {
            if let navController = self.navigationController {
                self.filtersMenuView = DropdownMenu(navigationController: navController, items: menuItems, selectedRow: self.selectedRow)
                self.filtersMenuView?.delegate = self
                self.filtersMenuView?.rowHeight = 50
                self.filtersMenuView?.showMenu()
            }
        }
    }

}

extension AirportFloorplanViewController: DropdownMenuDelegate {
    func dropdownMenu(_ dropdownMenu: DropdownMenu, didSelectRowAt indexPath: IndexPath) {
        if dropdownMenu == self.filtersMenuView {
            print("Wisk | Update tableview")
        }
        
        if dropdownMenu == self.concourseMenuView, let concourses = self.airport.getConcourses() {
            let concourse = concourses[indexPath.row]
            loadMapUsing(lattitudePoints: concourse.getLatitudePoints(), andLongitudePoints: concourse.getLongitudePoints())
        }
    }
}

extension AirportFloorplanViewController:
    UITableViewDelegate,
    UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpdatesCell") as! UpdatesCell
        cell.delegate = self
        cell.upVoteBtn.tag = indexPath.row
        cell.downVoteBtn.tag = indexPath.row
        return cell
    }
}

extension AirportFloorplanViewController: UpdateInteractionDelegate {
    func upVote(_ sender: UIButton) {
        let cell = self.tblMain.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as! UpdatesCell        
    }
    
    func downVote(_ sender: UIButton) {
        
    }
}

extension UIImage {
    
    func imageResize(sizeChange: CGSize) -> UIImage {
        let hasAlpha = true
        let scale: CGFloat = 0.0
        
        UIGraphicsBeginImageContextWithOptions(sizeChange,
                                               !hasAlpha,
                                               scale)
        self.draw(in: CGRect(origin: CGPoint.zero,
                             size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
    
    func overlayImage(color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        
        color.setFill()
        
        context!.translateBy(x: 0, y: self.size.height)
        context!.scaleBy(x: 1.0, y: -1.0)
        
        context!.setBlendMode(CGBlendMode.colorBurn)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context!.draw(self.cgImage!, in: rect)
        
        context!.setBlendMode(CGBlendMode.sourceIn)
        context!.addRect(rect)
        context!.drawPath(using: CGPathDrawingMode.fill)
        
        let coloredImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return coloredImage
    }
    
}
