//
//  LifeLinesViewController.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 12/21/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import FontAwesomeKit
import Alamofire

class LifeLinesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,ContactDelegate, AlertDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let contactCellReuseIdentifier = "ContactCellReuseIdentifier"
    var addBarBtn: UIBarButtonItem!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.edgesForExtendedLayout = UIRectEdge.bottom
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Life Lines"
        
        ContactManager.getInstance().sortByNumber()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: contactCellReuseIdentifier as String)
        tableView.tableFooterView = UIView()
        
        let plusCircleIcon = FAKFontAwesome.plusCircleIcon(withSize: 30)
        plusCircleIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let plusCircleImg  = plusCircleIcon?.image(with: CGSize(width: 30, height: 30))
        let addIconBtn = UIButton(frame: CGRect(x: -5, y: 0, width: 30, height: 30))
        addIconBtn.setImage(plusCircleImg, for: .normal)
        addIconBtn.tintColor = UIColor.white
        addIconBtn.imageView?.contentMode = .scaleAspectFit
        addIconBtn.addTarget(self, action: #selector(addBtnClicked), for: .touchUpInside)
        
        addBarBtn = UIBarButtonItem(customView: addIconBtn)

        if ContactManager.getInstance().contacts.count == 10 {
            self.navigationItem.rightBarButtonItem = nil
        }
        else {
            self.navigationItem.rightBarButtonItem = addBarBtn
        }
        
        searchBar.delegate = self
        searchBar.placeholder = "Search..."
    }
    
    func addBtnClicked() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let contactViewController = storyBoard.instantiateViewController(withIdentifier: "ContactViewController") as! ContactViewController
        contactViewController.contactDelegate = self
        contactViewController.setup = false
        self.navigationController?.pushViewController(contactViewController, animated: true)
    }
    
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
                    self.navigationItem.rightBarButtonItem = self.addBarBtn
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
            self.navigationItem.rightBarButtonItem = nil
        }
        else {
            self.navigationItem.rightBarButtonItem = addBarBtn
        }
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let user = UserDAO.getUser(id: UserDefaultManager.getInstance().getCurrentUser())
        ContactManager.getInstance().contacts = ContactDAO.querySearchContact(userId: (user?.id)!, keyword: searchText)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParentViewController {
            ContactManager.getInstance().contacts = ContactDAO.getAllContacts()
        }
    }
}
