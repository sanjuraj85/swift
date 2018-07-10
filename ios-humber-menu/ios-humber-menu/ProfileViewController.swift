//
//  ProfileViewController.swift
//  ios-humber-menu
//
//  Created by Pandit, Sanjay on 7/10/18.
//  Copyright © 2018 Pandit, Sanjay. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,MenuClickDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Always set restorationIdentifier for all parent/home controller
        self.restorationIdentifier = "PROFILE"
        //Init Menu and also set if you wish to show back button along with humberger menu
        Menu.initMenu(self, isBackButton: true, position: .right)
        
    }
    //Delegate back to menu
    func menuItemSelectedAtIndex(_ section : Int, index:Int) {
        Menu.menuSelectedItem(section, index, self)
    }

}
