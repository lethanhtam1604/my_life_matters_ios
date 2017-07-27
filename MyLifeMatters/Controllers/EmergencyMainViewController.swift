//
//  EmergencyMainViewController.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 12/19/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import FontAwesomeKit

class EmergencyMainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let callCellReuseIdentifier = "CallCellReuseIdentifier"
    let closeBtn = UIButton()
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
        
        self.navigationItem.title = "Emergency"
        
        
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

        searchBar.delegate = self
        searchBar.placeholder = "Search..."
    }
    
    func backBtnClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Manager TableView
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EmergencyManager.getInstance().emergencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: CallTableViewCell! = tableView.dequeueReusableCell(withIdentifier: callCellReuseIdentifier as String) as? CallTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        let emergency = EmergencyManager.getInstance().emergencies[indexPath.row]
        let index = emergency.name.index(emergency.name.startIndex, offsetBy: 1)
        cell.numberLabel.text = emergency.name.substring(to: index).uppercased()

        
        cell.numberNameLabel.text = emergency.name
        cell.phoneNumberLabel.text = emergency.phone
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let emergency = EmergencyManager.getInstance().emergencies[indexPath.row]
        Utils.callNumber(phone: emergency.phone)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let user = UserDAO.getUser(id: UserDefaultManager.getInstance().getCurrentUser())
        EmergencyManager.getInstance().emergencies = EmergencyDAO.querySearchEmergency(userId: (user?.id)!, keyword: searchText)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParentViewController {
            EmergencyManager.getInstance().emergencies = EmergencyDAO.getAllEmergencys()
        }
    }
}
