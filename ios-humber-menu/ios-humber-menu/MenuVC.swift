//
//  MenuVC.swift
//  Menu Left and Right with backbutton
//
//  Created by Pandit, Sanjay on 2/2/18.
//  Copyright © 2018 Pandit, Sanjay. All rights reserved.
//

import UIKit

class Menu{
    enum MenuPosition {
        case left,right
    }
    static var ctrlStacks = [AnyObject]()
    static var ctrl:AnyObject!
    static var isRightPosition = false
    static func initMenu(_ controller:AnyObject, isBackButton:Bool = false, position: MenuPosition = MenuPosition.left){
        ctrlStacks.append(controller)
        ctrl = controller
        if position == MenuPosition.right{
            isRightPosition = true
        }
        Menu.addSlideMenuButton(controller:ctrl,isBackButton: isBackButton, position: position)
    }
    @objc static func onSlideMenuButtonPressed(){
        Menu.popLeftMenu(controller: ctrl)
    }
    @objc static func BackScreen(){
        if(ctrl is UIViewController){
            let vCtrl = ctrl as! UIViewController
            vCtrl.dismiss(animated: true){
                ctrlStacks.remove(at: ctrlStacks.count-1)
                ctrl = ctrlStacks.last
            }
        }
        else if(ctrl is UITableViewController){
            let vCtrl = ctrl as! UITableViewController
            vCtrl.dismiss(animated: true){
                ctrlStacks.remove(at: ctrlStacks.count-1)
                ctrl = ctrlStacks.last
            }
        }
        else if(ctrl is UITabBarController){
            let vCtrl = ctrl as! UITabBarController
            vCtrl.dismiss(animated: true){
                ctrlStacks.remove(at: ctrlStacks.count-1)
                ctrl = ctrlStacks.last
            }
        }
    }
    private static func addSlideMenuButton(controller:AnyObject, isBackButton:Bool, position: MenuPosition){
        
        let btnShowMenu = UIButton(type: UIButtonType.system)
        btnShowMenu.setImage(self.defaultMenuImage(), for: UIControlState())
        btnShowMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnShowMenu.addTarget(self, action: #selector(onSlideMenuButtonPressed), for: UIControlEvents.touchUpInside)
        
        let btnBack = UIButton(type: UIButtonType.system)
        btnBack.setImage(UIImage(named:"back"), for: UIControlState())
        btnBack.frame = CGRect(x: 35, y: 0, width: 30, height: 30)
        btnBack.addTarget(self, action: #selector(BackScreen), for: UIControlEvents.touchUpInside)
        
        let leftView = UIView()
        if isBackButton{
            leftView.frame = CGRect(x: 0, y: 0, width: 70, height: 30)
            leftView.addSubview(btnShowMenu)
            leftView.addSubview(btnBack)
        }
        else{
            leftView.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
            leftView.addSubview(btnShowMenu)
        }
        let customBarItem = UIBarButtonItem(customView: leftView)
        
        if position == MenuPosition.right{
            controller.navigationItem.rightBarButtonItem = customBarItem;
        }
        else{
            controller.navigationItem.leftBarButtonItem = customBarItem;
        }
        
    }
    private static func defaultMenuImage() -> UIImage {
        var defaultMenuImage = UIImage()
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 30, height: 22), false, 0.0)
        UIColor.black.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 3, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 10, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 17, width: 30, height: 1)).fill()
        UIColor.white.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 4, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 11,  width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 18, width: 30, height: 1)).fill()
        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return defaultMenuImage;
    }
    static func popLeftMenu(controller:AnyObject){
        let vc = MenuVC()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = controller as? MenuClickDelegate
        vc.isRightPosition = isRightPosition
        vc.menuGroups = menuDatasource()
        controller.present(vc, animated: true, completion: nil)
    }
    static func menuDatasource()->[menuGroup]{
        var menuGroups = [menuGroup]()
        var menuItem = [menuRow]()
        
        //licon = left menu icon
        //ricon = right menu icon
        
        menuItem = [
            menuRow(text: "Home", licon: "home", ricon: "", desc: "HOME"),
            menuRow(text: "Profile", licon: "profile", ricon: "", desc: "PROFILE"),
            menuRow(text: "Logout", licon: "logout", ricon: "", desc: "LOGOUT")
        ]
        
        menuGroups = [
            menuGroup(name: "", items: menuItem)
        ]
        return menuGroups
    }
    static func getTopCtrlIdentifier(ctrl:AnyObject)->String{
        switch ctrl {
        case is UIViewController:
            let ctrlVC = ctrl as! UIViewController
            return ctrlVC.restorationIdentifier!
        case is UITableViewController:
            let ctrlVC = ctrl as! UITableViewController
            return ctrlVC.restorationIdentifier!
        case is UITabBarController:
            let ctrlVC = ctrl as! UITabBarController
            return ctrlVC.restorationIdentifier!
        default:
            return ""
        }
    }
    static func menuSelectedItem(_ section : Int,_ index:Int,_ controller:AnyObject){
        
        let groups = Menu.menuDatasource()
        let menuItems = groups[section].items
        let rowItem = menuItems[index] as! menuRow
        let identifierName = getTopCtrlIdentifier(ctrl: controller)
        
        if identifierName == rowItem.desc{
            print("SAMEVC")
        }
        else{
            
            switch rowItem.desc{
            case "LOGOUT":
                print("LOGOUT SUccessfully.")
                //Enable below code to back on base view controller.
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                    controller.view.window!.rootViewController?.dismiss(animated: true, completion: {
                        
                    })
                }
                
            case "PROFILE":
                print("Switch toPROFILE.")
                //ass segue or present controller on this callback
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController")  as! ProfileViewController
                let navController = UINavigationController(rootViewController: vc)
                controller.present(navController, animated: true, completion: {})
                
                
            case "HOME":
                if ctrlStacks.count > 1{
                    let vCtrl = ctrlStacks[0] as! UIViewController
                    vCtrl.dismiss(animated: true, completion: {
                        ctrl = ctrlStacks[0]
                        ctrlStacks = [AnyObject]()
                        ctrlStacks.append(ctrl)
                    })
                }
            default:
                break
            }
        }
    }
}
class menuRow{
    var text:String!
    var licon:String!
    var ricon:String!
    var desc:String!
    init(text:String, licon:String,ricon:String, desc:String) {
        self.text = text
        self.licon = licon
        self.ricon = ricon
        self.desc = desc
    }
}
class menuGroup{
    var name:String!
    var items:[AnyObject]
    init(name:String, items:[AnyObject]) {
        self.name = name
        self.items = items
    }
}
protocol RightMenuDelegate: class {
    func rightMenuItemSelectedAtIndex(_ section : Int, index:Int)
}
protocol MenuClickDelegate: class {
    func menuItemSelectedAtIndex(_ section : Int, index:Int)
}

class MenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var tableView: UITableView!
    var menuGroups = [menuGroup]()
    weak var delegate: MenuClickDelegate?
    var  isLeftIcon:Bool = false
    var  isRightIcon:Bool = false
    var  isRightPosition:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false
        
        let bgView = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        bgView.backgroundColor = UIColor.clear
        
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        var displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        var headerHeight = 120
        
        switch Device.TheCurrentDeviceType{
        case "FIVE":
            displayWidth = 280
            
        case "6TO8":
            displayWidth = 300
            
        case "6PLUSTO8PLUS":
            displayWidth = 300
            
        case "TEN":
            displayWidth = 300
            headerHeight = 140
        default:
            displayWidth = 300
            
        }
        
        if isRightPosition{
            tableView = UITableView(frame: CGRect(x: self.view.frame.width-displayWidth, y: -barHeight, width: displayWidth, height: displayHeight + barHeight ))
        }
        else{
            tableView = UITableView(frame: CGRect(x: 0, y: -barHeight, width: displayWidth, height: displayHeight + barHeight ))
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.allowsSelection = true
        tableView.delaysContentTouches = false
        tableView.dataSource = self
        tableView.delegate = self
        bgView.addSubview(tableView)
        bgView.addTarget(self, action:#selector(handleRegister), for: .touchUpInside)
        self.view.addSubview(bgView)
        
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width: Int(CGFloat(displayWidth)), height: headerHeight))
        header.backgroundColor = UIColor.red
        
        let imageView = UIImageView(image: UIImage(named: "strap_uper"))
        imageView.frame = CGRect(x: 0, y: 0, width: header.frame.width, height: header.frame.height)
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        
        let label = UILabel(frame: CGRect(x: 20, y: header.frame.height - 60, width: displayWidth, height: 20))
        //label.font = your font
        label.textAlignment = .left
        label.textColor = UIColor.white
        label.text =  "Sanjay Pandit"//set your user
        imageView.addSubview(label)
        
        let labelTitle = UILabel(frame: CGRect(x: 20, y:header.frame.height - 30, width: displayWidth, height: 20))
        labelTitle.textAlignment = .left
        //labelTitle.font = UIFont.withSize(15.0)
        labelTitle.textColor = UIColor.white
        labelTitle.text = "sanjuraj85@gmail.com"
        imageView.addSubview(labelTitle)
        header.addSubview(imageView)
        tableView.tableHeaderView = header
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
    }
    @objc  func handleRegister(){
        self.dismiss(animated: true)
    }
    @objc func delDelegateClick(tapGesture:UITapGestureRecognizer){
        self.dismiss(animated: true)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            self.delegate?.menuItemSelectedAtIndex(indexPath.section, index: indexPath.row)
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuGroups.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuGroups[section].items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuCell(style: UITableViewCellStyle.default, reuseIdentifier: "myIdentifier")
        let  item:menuRow = menuGroups[indexPath.section].items[indexPath.row] as! menuRow
        cell.setCellData =  item //"\(myArray[indexPath.row])"
        cell.selectionStyle = .gray
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        //view.backgroundColor = Colors.lightGrey
        //view.addTopBorderWithColor(color: UIColor.lightGray, width: 0.5)
        return view
    }
}
struct Device {
    static var TheCurrentDeviceType: String
    {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                //print("iPhone 5 or 5S or 5C")
                return "FIVE"
            case 1334:
                //print("iPhone 6/6S/7/8")
                return "6TO8"
            case 2208:
                //print("iPhone 6+/6S+/7+/8+")
                return "6PLUSTO8PLUS"
            case 2436:
                //print("iPhone X")
                return "TEN"
            default:
                //print("unknown")
                return ""
            }
        }
        return ""
    }
}
class menuCell: UITableViewCell {
    
    var lImageIcon : UIImageView!
    var labelText: UILabel!
    var rImageIcon : UIImageView!
    
    var showLicon:Bool = true
    var showRicon: Bool = true
    
    var setCellData: menuRow!{
        didSet{
            updateData()
        }
    }
    func updateData()
    {
        labelText.text = setCellData.text
        
        if !setCellData.ricon.isEmpty{
            rImageIcon.image = UIImage(named:setCellData.ricon)
            rImageIcon.isHidden = false
        }
        else{
            rImageIcon.image = UIImage(named:"trans")
            rImageIcon.isHidden = true
        }
        
        if !setCellData.licon.isEmpty{
            lImageIcon.image = UIImage(named:setCellData.licon)
            lImageIcon.isHidden = false
        }
        else{
            lImageIcon.image = UIImage(named:"trans")
            lImageIcon.isHidden = true
        }
        
        if showLicon{
            lImageIcon = UIImageView(frame: CGRect(x: 10, y: 10, width: 24, height: 24))
            
            if showRicon{
                labelText.frame = CGRect(x: 55, y: 0, width: self.frame.width - 80.0, height: 44)
                rImageIcon.frame = CGRect(x: self.frame.width - 70.0, y: 6, width: 32.0, height: 32)
                
            }else{
                labelText.frame = CGRect(x: 55, y: 0, width: self.frame.width - 58.0, height: 44)
            }
        }
        else{
            if showRicon{
                labelText.frame = CGRect(x: 20, y: 0, width: self.frame.width - 80.0, height: 44)
                rImageIcon.frame = CGRect(x: self.frame.width - 70.0, y: 6, width: 32.0, height: 32)
            }else{
                labelText.frame = CGRect(x: 20, y: 0, width: self.frame.width - 20.0, height: 44)
            }
        }
        
        
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        lImageIcon = UIImageView(frame: CGRect(x: 10, y: 10, width: 24, height: 24))
        lImageIcon.contentMode = .scaleAspectFit
        lImageIcon.isHidden = false
        contentView.addSubview(lImageIcon)
        
        labelText = UILabel()
        labelText.textColor = UIColor.black
        contentView.addSubview(labelText)
        
        //check_green
        rImageIcon = UIImageView(image: UIImage(named:"check_green"))
        rImageIcon.contentMode = .scaleAspectFit
        rImageIcon.isHidden = true
        contentView.addSubview(rImageIcon)
    }
    
}
