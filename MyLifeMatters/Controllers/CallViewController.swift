//
//  CallViewController.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 12/14/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import FontAwesomeKit

class CallViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var numberPadView: UIView!
    
    @IBOutlet weak var zeroView: UIView!
    
    @IBOutlet weak var oneView: UIView!
    @IBOutlet weak var fourView: UIView!
    @IBOutlet weak var eightView: UIView!
    @IBOutlet weak var threeView: UIView!
    @IBOutlet weak var sixView: UIView!
    @IBOutlet weak var fiveView: UIView!
    @IBOutlet weak var twoView: UIView!
    @IBOutlet weak var nineView: UIView!
    @IBOutlet weak var sevenView: UIView!
    
    let closeBtn = UIButton()
    let callCellReuseIdentifier = "CallCellReuseIdentifier"
    
    var user: User!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.edgesForExtendedLayout = UIRectEdge.bottom
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userId = UserDefaultManager.getInstance().getCurrentUser()
        user = UserDAO.getUser(id: userId)
        
        //init navigation bar
        navigationController!.navigationBar.barTintColor = Global.colorMain
        navigationController!.navigationBar.tintColor = UIColor.white
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        self.navigationItem.title = "Call"
        ContactManager.getInstance().sortByNumber()
        
        let androidCloseIcon = FAKIonIcons.androidCloseIcon(withSize: 25)
        androidCloseIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let  androidCloseImg  = androidCloseIcon?.image(with: CGSize(width: 25, height: 25))
        closeBtn.setImage(androidCloseImg, for: .normal)
        closeBtn.tintColor = UIColor.white
        closeBtn.imageView?.contentMode = .scaleAspectFit
        closeBtn.addTarget(self, action: #selector(backBtnClicked), for: .touchUpInside)
        closeBtn.frame = CGRect(x: -20, y: 0, width: 25, height: 44)
        
        let closeBarBtn = UIBarButtonItem(customView: closeBtn)
        closeBtn.transform = CGAffineTransform(translationX: -20, y: 0)
        closeBarBtn.width = -30
        self.navigationItem.leftBarButtonItem = closeBarBtn
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CallTableViewCell", bundle: nil), forCellReuseIdentifier: callCellReuseIdentifier as String)
        tableView.tableFooterView = UIView()

        
        let zeroTap = UITapGestureRecognizer(target: self, action:  #selector (zeroTapClicked))
        let oneTap = UITapGestureRecognizer(target: self, action:  #selector (oneTapClicked))
        let twoTap = UITapGestureRecognizer(target: self, action:  #selector (twoTapClicked))
        let threeTap = UITapGestureRecognizer(target: self, action:  #selector (threeTapClicked))
        let fourTap = UITapGestureRecognizer(target: self, action:  #selector (fourTapClicked))
        let fiveTap = UITapGestureRecognizer(target: self, action:  #selector (fiveTapClicked))
        let sixTap = UITapGestureRecognizer(target: self, action:  #selector (sixTapClicked))
        let sevenTap = UITapGestureRecognizer(target: self, action:  #selector (sevenTapClicked))
        let eightTap = UITapGestureRecognizer(target: self, action:  #selector (eightTapClicked))
        let nineTap = UITapGestureRecognizer(target: self, action:  #selector (nineTapClicked))

        zeroView.addGestureRecognizer(zeroTap)
        oneView.addGestureRecognizer(oneTap)
        twoView.addGestureRecognizer(twoTap)
        threeView.addGestureRecognizer(threeTap)
        fourView.addGestureRecognizer(fourTap)
        fiveView.addGestureRecognizer(fiveTap)
        sixView.addGestureRecognizer(sixTap)
        sevenView.addGestureRecognizer(sevenTap)
        eightView.addGestureRecognizer(eightTap)
        nineView.addGestureRecognizer(nineTap)

    }
    
    func backBtnClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Manager TableView
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContactManager.getInstance().contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: CallTableViewCell! = tableView.dequeueReusableCell(withIdentifier: callCellReuseIdentifier as String) as? CallTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        let contact = ContactManager.getInstance().contacts[indexPath.row]
        cell.numberLabel.text = String(contact.number)
        let index = contact.profile.index(contact.profile.startIndex, offsetBy: 1)
        cell.numberLabel.text = contact.profile.substring(to: index).uppercased()

        cell.numberNameLabel.text = contact.profile
        cell.phoneNumberLabel.text = contact.phone
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = ContactManager.getInstance().contacts[indexPath.row]
        Utils.callNumber(phone: contact.phone)
    }

    func zeroTapClicked() {
        if ContactManager.getInstance().contacts.count == 0 {
            return
        }
        let contact = ContactManager.getInstance().contacts[0]
        Utils.callNumber(phone: contact.phone)
        
        let installed = UIApplication.shared.canOpenURL(NSURL(string: "skype:")! as URL)
        if installed {
            UIApplication.shared.openURL(NSURL(string: "skype:echo123?call")! as URL)
        }
    }
    
    func oneTapClicked() {
        if ContactManager.getInstance().contacts.count < 2 {
            return
        }
        let contact = ContactManager.getInstance().contacts[1]
        Utils.callNumber(phone: contact.phone)
    }
    
    func twoTapClicked() {
        if ContactManager.getInstance().contacts.count < 3 {
            return
        }
        let contact = ContactManager.getInstance().contacts[2]
        Utils.callNumber(phone: contact.phone)
    }
    
    func threeTapClicked() {
        if ContactManager.getInstance().contacts.count < 4 {
            return
        }
        let contact = ContactManager.getInstance().contacts[3]
        Utils.callNumber(phone: contact.phone)
    }
    
    func fourTapClicked() {
        if ContactManager.getInstance().contacts.count < 5 {
            return
        }
        let contact = ContactManager.getInstance().contacts[4]
        Utils.callNumber(phone: contact.phone)
    }
    
    func fiveTapClicked() {
        if ContactManager.getInstance().contacts.count < 6 {
            return
        }
        let contact = ContactManager.getInstance().contacts[5]
        Utils.callNumber(phone: contact.phone)
    }
    
    func sixTapClicked() {
        if ContactManager.getInstance().contacts.count < 7 {
            return
        }
        let contact = ContactManager.getInstance().contacts[6]
        Utils.callNumber(phone: contact.phone)
    }
    
    func sevenTapClicked() {
        if ContactManager.getInstance().contacts.count < 8 {
            return
        }
        let contact = ContactManager.getInstance().contacts[7]
        Utils.callNumber(phone: contact.phone)
    }
    
    func eightTapClicked() {
        if ContactManager.getInstance().contacts.count < 9 {
            return
        }
        let contact = ContactManager.getInstance().contacts[8]
        Utils.callNumber(phone: contact.phone)
    }
    
    func nineTapClicked() {
        if ContactManager.getInstance().contacts.count < 10 {
            return
        }
        let contact = ContactManager.getInstance().contacts[9]
        Utils.callNumber(phone: contact.phone)
    }
}
