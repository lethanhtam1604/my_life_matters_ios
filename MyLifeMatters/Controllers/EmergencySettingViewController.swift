//
//  EmergencySettingViewController.swift
//  MyLifeMatters
//
//  Created by D on 12/17/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import FontAwesomeKit
import Alamofire

class EmergencySettingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, EmergencyDelegate, AlertDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    let emergencyCellReuseIdentifier = "EmergencyCellReuseIdentifier"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.edgesForExtendedLayout = UIRectEdge.bottom
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Emergency Dialing"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "EmergencyTableViewCell", bundle: nil), forCellReuseIdentifier: emergencyCellReuseIdentifier as String)
        tableView.tableFooterView = UIView()
        
        let plusCircleIcon = FAKFontAwesome.plusCircleIcon(withSize: 30)
        plusCircleIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let plusCircleImg  = plusCircleIcon?.image(with: CGSize(width: 30, height: 30))
        let addIconBtn = UIButton(frame: CGRect(x: -5, y: 0, width: 30, height: 30))
        addIconBtn.setImage(plusCircleImg, for: .normal)
        addIconBtn.tintColor = UIColor.white
        addIconBtn.imageView?.contentMode = .scaleAspectFit
        addIconBtn.addTarget(self, action: #selector(addBtnClicked), for: .touchUpInside)
        
        let addBarBtn = UIBarButtonItem(customView: addIconBtn)
        self.navigationItem.rightBarButtonItem = addBarBtn
        
        searchBar.delegate = self
        searchBar.placeholder = "Search..."
    }
    
    func backBtnClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    func addBtnClicked() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let emergencyViewController = storyBoard.instantiateViewController(withIdentifier: "EmergencyViewController") as! EmergencyViewController
        emergencyViewController.emergencyDelegate = self
        emergencyViewController.setup = false
        self.navigationController?.pushViewController(emergencyViewController, animated: true)
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EmergencyManager.getInstance().emergencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: EmergencyTableViewCell! = tableView.dequeueReusableCell(withIdentifier: emergencyCellReuseIdentifier as String) as? EmergencyTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none;
        
        let emergency = EmergencyManager.getInstance().emergencies[indexPath.row]
        cell.phoneNumberLabel.text = emergency.phone
        cell.nameLabel.text = emergency.name
        cell.closeBtn.addTarget(self, action: #selector(closeBtnCicked), for: .touchUpInside)
        cell.closeBtn.tag = indexPath.row
        
        return cell
    }
    
    func closeBtnCicked(_ sender: UIButton) {
        Utils.showAlertAction(title: "Emergency Deletion", message: "Are you are want to delete this emergency?", viewController: self, alertDelegate: self)
        indexTable = sender.tag
    }
    
    var indexTable = 0
    func okAlertActionClicked() {
        if !Utils.isInternetAvailable() {
            Utils.showAlert(title: "Error", message: "Internet is not available. Please try again!", viewController: self)
            return
        }
        
        let emergency = EmergencyManager.getInstance().emergencies[indexTable]
        
        SwiftOverlays.showBlockingWaitOverlay()
        let user = UserDAO.getUser(id: UserDefaultManager.getInstance().getCurrentUser())
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        
        let body = ["_method": "DELETE"] as [String : Any]
        
        Alamofire.request(Global.baseURL + "emergency/" + String(emergency.id) + "?token=" + (user?.token)!, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            SwiftOverlays.removeAllBlockingOverlays()
            switch response.result {
            case .success(_):
                let result = Response(data: response.data!)
                if result.success == "true" {
                    EmergencyDAO.deleteEmergency(id: emergency.id)
                    EmergencyManager.getInstance().emergencies.remove(at: self.indexTable)
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
        
        let emergency = EmergencyManager.getInstance().emergencies[indexPath.row]
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let emergencyViewController = storyBoard.instantiateViewController(withIdentifier: "EmergencyViewController") as! EmergencyViewController
        emergencyViewController.emergencyDelegate = self
        emergencyViewController.emergency = emergency
        emergencyViewController.setup = false
        self.navigationController?.pushViewController(emergencyViewController, animated: true)
    }
    
    func saveNewEmergencyClicked() {
        tableView.reloadData()
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
