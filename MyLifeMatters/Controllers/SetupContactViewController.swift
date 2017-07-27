//
//  SetupContactViewController.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 11/26/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import FontAwesomeKit
import Alamofire

protocol ContactDelegate {
    func saveNewContactClicked()
}

class SetupContactViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FooterDelegate, ContactDelegate, AlertDelegate {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let contactCellReuseIdentifier = "ContactCellReuseIdentifier"
    let gradientView = GradientView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.edgesForExtendedLayout = UIRectEdge.bottom
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init navigation bar
        navigationController!.navigationBar.barTintColor = Global.colorMain
        navigationController!.navigationBar.tintColor = UIColor.white
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        self.navigationItem.title = "Setup your Profile"
        
        let iosArrowBackIcon = FAKIonIcons.iosArrowBackIcon(withSize: 25)
        iosArrowBackIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let iosArrowBackImg  = iosArrowBackIcon?.image(with: CGSize(width: 25, height: 25))
        backBtn.setImage(iosArrowBackImg, for: .normal)
        backBtn.tintColor = UIColor.white
        backBtn.addTarget(self, action: #selector(backBtnClicked), for: .touchUpInside)
        backBtn.imageView?.contentMode = .scaleAspectFit
        
        let iosArrowForwardIcon = FAKIonIcons.iosArrowForwardIcon(withSize: 25)
        iosArrowForwardIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let iosArrowForwardImg  = iosArrowForwardIcon?.image(with: CGSize(width: 25, height: 25))
        nextBtn.setImage(iosArrowForwardImg, for: .normal)
        nextBtn.tintColor = UIColor.white
        nextBtn.addTarget(self, action: #selector(nextBtnClicked), for: .touchUpInside)
        nextBtn.imageView?.contentMode = .scaleAspectFit
        nextBtn.insertSubview(gradientView, at: 0)
        
        gradientView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
        gradientView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        gradientView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
        gradientView.autoSetDimension(.height, toSize: 45)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: contactCellReuseIdentifier as String)
        
        let headerView = CivilHeaderTableViewCell.instanceFromNib() as? CivilHeaderTableViewCell
        headerView?.valueLabel.text = "Input Life line contacts (up to 10 people)"
        
        let footerView = CivilFooterTableViewCell.instanceFromNib() as? CivilFooterTableViewCell
        footerView?.footerDelegate = self
        
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = footerView
        tableView.backgroundColor = Global.colorHeader
        
        if ContactManager.getInstance().contacts.count < 10 {
            tableView.tableFooterView?.isHidden = false
        }
        else {
            tableView.tableFooterView?.isHidden = true
        }
    }
    
    func backBtnClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    var index = 0, sumRequest = 0

    func nextBtnClicked() {
        if ContactManager.getInstance().contacts.count < 1 {
            Utils.showAlert(title: "Error", message: "You have to add 10 contacts. Please try again!", viewController: self)
        }
        else {
//            if !Utils.isInternetAvailable() {
//                Utils.showAlert(title: "Error", message: "Internet is not available. Please try again!", viewController: self)
//                return
//            }
//            
//            let user = UserDAO.getUser(id: UserDefaultManager.getInstance().getCurrentUser())
//            let contacts = ContactManager.getInstance().contacts
//            let headers: HTTPHeaders = ["Content-Type": "application/json"]
//            
//            for contact in contacts {
//                if !contact.sent {
//                    sumRequest = sumRequest + 1
//                }
//            }
//            
//            if sumRequest != 0 {
//                SwiftOverlays.showBlockingWaitOverlay()
//            }
//            else {
//                navPage()
//            }
//            
//            for contact in contacts {
//                if contact.sent {
//                    continue
//                }
//                let body = ["user_id": contact.user_id, "profile": contact.profile, "firstname": contact.firstname, "lastname": contact.lastname, "phone": contact.phone, "email": contact.email, "relationship": contact.relationship, "number": String(contact.number)] as [String : Any]
//                
//                Alamofire.request(Global.baseURL + "contact?token=" + (user?.token)!, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
//                    switch response.result {
//                    case .success(_):
//                        self.finish()
//                        let result = Response(data: response.data!)
//                        if result.success == "true" {
//                            let contactResult = ContactResult(data: response.data!)
//                            let newContact  = Contact()
//                            newContact.id = contactResult.id
//                            newContact.user_id = contact.user_id
//                            newContact.profile = contact.profile
//                            newContact.firstname = contact.firstname
//                            newContact.lastname = contact.lastname
//                            newContact.phone = contact.phone
//                            newContact.email = contact.email
//                            newContact.relationship = contact.relationship
//                            newContact.sent = true
//                            newContact.number = contact.number
//                            ContactDAO.deleteContact(id: contact.id)
//                            ContactDAO.addContact(contact: newContact)
//                        }
//                        else {
//                            
//                        }
//                    case .failure(_):
//                        self.finish()
//                        return
//                    }
//                }
//            }
            navPage()
        }
    }
    
    func finish() {
        index = index + 1
        if index == sumRequest {
            SwiftOverlays.removeAllBlockingOverlays()
            navPage()
        }
    }
    
    func navPage() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let setupAlarmViewController = storyBoard.instantiateViewController(withIdentifier: "SetupAlarmViewController") as! SetupAlarmViewController
        let nav = UINavigationController(rootViewController: setupAlarmViewController)
        self.present(nav, animated:true, completion:nil)
    }
    
    func addBtnClicked() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let contactViewController = storyBoard.instantiateViewController(withIdentifier: "ContactViewController") as! ContactViewController
        contactViewController.contactDelegate = self
        contactViewController.setup = false
        self.navigationController?.pushViewController(contactViewController, animated: true)
    }
    
    // MARK: - Manager TableView
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContactManager.getInstance().contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ContactTableViewCell! = tableView.dequeueReusableCell(withIdentifier: contactCellReuseIdentifier as String) as? ContactTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none;
        
        let contact = ContactManager.getInstance().contacts[indexPath.row]
        cell.nameLabel.text = String(contact.number) + ". " + contact.profile
        cell.iconBtn.backgroundColor  = Global.getRandomColor()
        let index = contact.profile.index(contact.profile.startIndex, offsetBy: 1)
        cell.iconBtn.setTitle(contact.profile.substring(to: index).uppercased(), for: .normal)
        cell.closeBtn.addTarget(self, action: #selector(closeBtnCicked), for: .touchUpInside)
        cell.closeBtn.tag = indexPath.row

        
//        if contact.sent {
//            cell.closeBtn.isHidden = true
//        }
//        else {
//            cell.closeBtn.isHidden = false
//        }
        
        return cell
    }
    
    func closeBtnCicked(_ sender: UIButton) {
        Utils.showAlertAction(title: "Contact Deletion", message: "Are you are want to delete this contact?", viewController: self, alertDelegate: self)
        indexTable = sender.tag
    }
    
    var indexTable = 0
    func okAlertActionClicked() {
        if !Utils.isInternetAvailable() {
            Utils.showAlert(title: "Error", message: "Internet is not available. Please try again!", viewController: self)
            return
        }
        
        let contact = ContactManager.getInstance().contacts[indexTable]
        
        SwiftOverlays.showBlockingWaitOverlay()
        let user = UserDAO.getUser(id: UserDefaultManager.getInstance().getCurrentUser())
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        
        let body = ["_method": "DELETE"] as [String : Any]
        
        Alamofire.request(Global.baseURL + "contact/" + String(contact.id) + "?token=" + (user?.token)!, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            SwiftOverlays.removeAllBlockingOverlays()
            switch response.result {
            case .success(_):
                let result = Response(data: response.data!)
                if result.success == "true" {
                    ContactDAO.deleteContact(id: contact.id)
                    ContactManager.getInstance().contacts.remove(at: self.indexTable)
                    for index in (self.indexTable..<ContactManager.getInstance().contacts.count) {
                        let oldContact = ContactManager.getInstance().contacts[index]
                        let newContact  = Contact()
                        newContact.id = oldContact.id
                        newContact.user_id = oldContact.user_id
                        newContact.profile = oldContact.profile
                        newContact.firstname = oldContact.firstname
                        newContact.lastname = oldContact.lastname
                        newContact.phone = oldContact.phone
                        newContact.email = oldContact.email
                        newContact.relationship = oldContact.relationship
                        newContact.sent = true
                        newContact.number = oldContact.number - 1
                        ContactDAO.updateContact(contact: newContact)
                        
                        let body = ["user_id": oldContact.user_id, "profile": oldContact.profile, "firstname": oldContact.firstname, "lastname": oldContact.lastname, "phone": oldContact.phone, "email": oldContact.email, "relationship": oldContact.relationship, "number": String(oldContact.number), "_method": "PUT"] as [String : Any]
                        Alamofire.request(Global.baseURL + "contact/" + String(oldContact.id) + "?token=" + (user?.token)!, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                        }
                    }
                    
                    self.tableView.tableFooterView?.isHidden = false
                    self.tableView.reloadData()
                }
                else {
                    Utils.showAlert(title: "Error", message: "Delete error. Please try again!", viewController: self)
                }
            case .failure(_):
                Utils.showAlert(title: "Error", message: "Delete error. Please try again!", viewController: self)
                return
            }
        }
    }
    
//    var indexTable = 0
//    func okAlertActionClicked() {
//        let contact = ContactManager.getInstance().contacts[indexTable]
//        ContactDAO.deleteContact(id: contact.id)
//        ContactManager.getInstance().contacts.remove(at: indexTable)
//        
//        for index in (indexTable..<ContactManager.getInstance().contacts.count) {
//            let oldContact = ContactManager.getInstance().contacts[index]
//            let newContact  = Contact()
//            newContact.id = oldContact.id
//            newContact.user_id = oldContact.user_id
//            newContact.profile = oldContact.profile
//            newContact.firstname = oldContact.firstname
//            newContact.lastname = oldContact.lastname
//            newContact.phone = oldContact.phone
//            newContact.email = oldContact.email
//            newContact.relationship = oldContact.relationship
//            newContact.sent = true
//            newContact.number = oldContact.number - 1
//            ContactDAO.updateContact(contact: newContact)
//        }
//        if ContactManager.getInstance().contacts.count < 10 {
//            tableView.tableFooterView?.isHidden = false
//        }
//        tableView.reloadData()
//    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let contact = ContactManager.getInstance().contacts[indexPath.row]
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let contactViewController = storyBoard.instantiateViewController(withIdentifier: "ContactViewController") as! ContactViewController
        contactViewController.contactDelegate = self
        contactViewController.contact = contact
        contactViewController.setup = false
        self.navigationController?.pushViewController(contactViewController, animated: true)
    }
    
    func saveNewContactClicked() {
        if ContactManager.getInstance().contacts.count == 10 {
            tableView.tableFooterView?.isHidden = true
        }
        tableView.reloadData()
    }
}
