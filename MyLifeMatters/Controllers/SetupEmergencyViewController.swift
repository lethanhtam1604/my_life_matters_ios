//
//  SetupEmergencyViewController.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 11/26/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import FontAwesomeKit
import Alamofire

protocol EmergencyDelegate {
    func saveNewEmergencyClicked()
}

class SetupEmergencyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FooterDelegate, EmergencyDelegate, AlertDelegate {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let emergencyCellReuseIdentifier = "EmergencyCellReuseIdentifier"
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
        tableView.register(UINib(nibName: "EmergencyTableViewCell", bundle: nil), forCellReuseIdentifier: emergencyCellReuseIdentifier as String)
        
        let headerView = CivilHeaderTableViewCell.instanceFromNib() as? CivilHeaderTableViewCell
        headerView?.valueLabel.text = "Define Emergency dialling contact. Eg 911"
        
        let footerView = CivilFooterTableViewCell.instanceFromNib() as? CivilFooterTableViewCell
        footerView?.footerDelegate = self
        
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = footerView
        tableView.backgroundColor = Global.colorHeader

    }
    
    func backBtnClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    var index = 0, sumRequest = 0
    
    func nextBtnClicked() {
        if EmergencyManager.getInstance().emergencies.count == 0 {
            Utils.showAlert(title: "Error", message: "You have to add at least one emergency item. Please try again!", viewController: self)
        }
        else {
//            if !Utils.isInternetAvailable() {
//                Utils.showAlert(title: "Error", message: "Internet is not available. Please try again!", viewController: self)
//                return
//            }
//            
//            let user = UserDAO.getUser(id: UserDefaultManager.getInstance().getCurrentUser())
//            let emergencies = EmergencyManager.getInstance().emergencies
//            let headers: HTTPHeaders = ["Content-Type": "application/json"]
//            
//            for emergency in emergencies {
//                if !emergency.sent {
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
//            for emergency in emergencies {
//                if emergency.sent {
//                    continue
//                }
//                let body = ["user_id": emergency.user_id, "name": emergency.name, "phone": emergency.phone] as [String : Any]
//
//                Alamofire.request(Global.baseURL + "emergency?token=" + (user?.token)!, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
//                    switch response.result {
//                    case .success(_):
//                        self.finish()
//                        let result = Response(data: response.data!)
//                        if result.success == "true" {
//                            let emergencyResult = EmergencyResult(data: response.data!)
//                            let newEmergency = Emergency()
//                            newEmergency.id = emergencyResult.id
//                            newEmergency.user_id = emergency.user_id
//                            newEmergency.name = emergency.name
//                            newEmergency.phone = emergency.phone
//                            newEmergency.sent = true
//                            print(emergency)
//                            print(newEmergency)
//
//                            EmergencyDAO.deleteEmergency(id: emergency.id)
//                            EmergencyDAO.addEmergency(emergency: newEmergency)
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
        let setupContactViewController = storyBoard.instantiateViewController(withIdentifier: "SetupContactViewController") as! SetupContactViewController
        let nav = UINavigationController(rootViewController: setupContactViewController)
        self.present(nav, animated:true, completion:nil)
    }
    
    func addBtnClicked() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let emergencyViewController = storyBoard.instantiateViewController(withIdentifier: "EmergencyViewController") as! EmergencyViewController
        emergencyViewController.emergencyDelegate = self
        emergencyViewController.setup = false
        self.navigationController?.pushViewController(emergencyViewController, animated: true)
    }
    
    // MARK: - Manager TableView
    
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
        
//        if emergency.sent {
//            cell.closeBtn.isHidden = true
//        }
//        else {
//            cell.closeBtn.isHidden = false
//        }
        
        return cell
    }
    
    func closeBtnCicked(_ sender: UIButton) {
        Utils.showAlertAction(title: "Emergency Deletion", message: "Are you are want to delete this emergency?", viewController: self, alertDelegate: self)
        indexTable = sender.tag
    }
    
//    var indexTable = 0
//    func okAlertActionClicked() {
//        let emergency = EmergencyManager.getInstance().emergencies[indexTable]
//        EmergencyDAO.deleteEmergency(id: emergency.id)
//        EmergencyManager.getInstance().emergencies.remove(at: indexTable)
//        tableView.reloadData()
//    }
    
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
}
