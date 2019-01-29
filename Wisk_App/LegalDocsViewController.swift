//
//  LegalDocsViewController.swift
//  Wisk_App
//
//  Created by Michael Westbrooks II on 7/9/16.
//  Copyright © 2016 redroostertechnologiesinc. All rights reserved.
//

import UIKit
import PageMenu

class LegalDocsViewController: UIViewController, CAPSPageMenuDelegate  {
    
    var pageMenu : CAPSPageMenu!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50.0, height: 44))
        label.backgroundColor = UIColor.clear
        label.font = UIFont(name: "Lato-Regular", size: 14)
        label.textColor = UIColor.white
        label.numberOfLines = 2
        label.textAlignment = NSTextAlignment.center
        label.text = "Legal"
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.navigationItem.titleView = label
        
        var controllerArray : [UIViewController] = []
        
        let controller1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "privacyPolicy") as UIViewController
        controller1.title = "Privacy Policy"
        controllerArray.append(controller1)
        
        let controller2 : UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "termsOfService") as UIViewController
        controller2.title = "Terms of Service"
        controllerArray.append(controller2)
        
        let parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(0),
            .useMenuLikeSegmentedControl(true),
            .menuItemSeparatorPercentageHeight(0),
            .scrollMenuBackgroundColor(UIColor.white),
            .selectionIndicatorColor(UIColor.clear),
            .selectedMenuItemLabelColor(UIColor.flatGreen),
            .unselectedMenuItemLabelColor(UIColor.flatGray)
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height), pageMenuOptions: parameters)
        
        self.view.addSubview(pageMenu!.view)

    }
    
    @IBAction func backAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
