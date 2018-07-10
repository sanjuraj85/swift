//
//  ViewController.swift
//  ios-humber-menu
//
//  Created by Pandit, Sanjay on 7/10/18.
//  Copyright © 2018 Pandit, Sanjay. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MenuClickDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Always set restorationIdentifier for all parent/home controller
        self.restorationIdentifier = "HomeVC"
        //Init Menu and also set if you wish to show back button along with humberger menu
        Menu.initMenu(self, position: .left)
        
        
    }
    //Delegate back to menu
    func menuItemSelectedAtIndex(_ section : Int, index:Int) {
        Menu.menuSelectedItem(section, index, self)
    }


}

