//
//  SetupCivilViewController.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 11/26/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import FontAwesomeKit
import Alamofire

protocol CivilDelegate {
    func saveNewCivilClicked()
}

class SetupCivilViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FooterDelegate, CivilDelegate, AlertDelegate {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let civilCellReuseIdentifier = "CivilCellReuseIdentifier"
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
        tableView.register(UINib(nibName: "CivilTableViewCell", bundle: nil), forCellReuseIdentifier: civilCellReuseIdentifier as String)
        
        let headerView = CivilHeaderTableViewCell.instanceFromNib() as? CivilHeaderTableViewCell
        headerView?.valueLabel.text = "Define the upload coordinates (email address and civil rights groups/social media website)"
        
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
        if CivilManager.getInstance().civils.count == 0 {
            Utils.showAlert(title: "Error", message: "You have to add at least one civil item. Please try again!", viewController: self)
        }
        else {
//            if !Utils.isInternetAvailable() {
//                Utils.showAlert(title: "Error", message: "Internet is not available. Please try again!", viewController: self)
//                return
//            }
//
//            let user = UserDAO.getUser(id: UserDefaultManager.getInstance().getCurrentUser())
//            let civils = CivilManager.getInstance().civils
//            
//            let headers: HTTPHeaders = ["Content-Type": "application/json"]
//
//            for civil in civils {
//                if !civil.sent {
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
//            for civil in civils {
//                if civil.sent {
//                    continue
//                }
//
//                let body = ["user_id": civil.user_id, "name": civil.name, "phone": civil.phone,  "email": civil.email,  "address": civil.address, "website": civil.website] as [String : Any]
//
//                Alamofire.request(Global.baseURL + "civil?token=" + (user?.token)!, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
//                    switch response.result {
//                    case .success(_):
//                        self.finish()
//                        let result = Response(data: response.data!)
//                        if result.success == "true" {
//                            let newCivilResult = CivilResult(data: response.data!)
//                            let newCivil = Civil()
//                            newCivil.id = newCivilResult.id
//                            newCivil.user_id = civil.user_id
//                            newCivil.name = civil.name
//                            newCivil.phone = civil.phone
//                            newCivil.email = civil.email
//                            newCivil.address = civil.address
//                            newCivil.website = civil.website
//                            newCivil.sent = true
//                            CivilDAO.deleteCivil(id: civil.id)
//                            CivilDAO.addCivil(civil: newCivil)
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
        let setupEmergencyViewController = storyBoard.instantiateViewController(withIdentifier: "SetupEmergencyViewController") as! SetupEmergencyViewController
        let nav = UINavigationController(rootViewController: setupEmergencyViewController)
        self.present(nav, animated:true, completion:nil)
    }
    
    func addBtnClicked() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let civilViewController = storyBoard.instantiateViewController(withIdentifier: "CivilViewController") as! CivilViewController
        civilViewController.civilDelegate = self
        civilViewController.setup = false
        self.navigationController?.pushViewController(civilViewController, animated: true)
    }
    
    // MARK: - Manager TableView
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CivilManager.getInstance().civils.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: CivilTableViewCell! = tableView.dequeueReusableCell(withIdentifier: civilCellReuseIdentifier as String) as? CivilTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none;
        
        let civil = CivilManager.getInstance().civils[indexPath.row]
        cell.nameLabel.text = civil.name
        cell.phoneLabel.text = civil.phone
        cell.emailLabel.text = civil.email
        cell.closeBtn.addTarget(self, action: #selector(closeBtnCicked), for: .touchUpInside)
        cell.closeBtn.tag = indexPath.row
        
//        if civil.sent {
//            cell.closeBtn.isHidden = true
//        }
//        else {
//            cell.closeBtn.isHidden = false
//        }
        return cell
    }
    
    func closeBtnCicked(_ sender: UIButton) {
        Utils.showAlertAction(title: "Civil Deletion", message: "Are you are want to delete this civil?", viewController: self, alertDelegate: self)
        indexTable = sender.tag
    }
    
//    var indexTable = 0
//    func okAlertActionClicked() {
//        let civil = CivilManager.getInstance().civils[indexTable]
//        CivilDAO.deleteCivil(id: civil.id)
//        CivilManager.getInstance().civils.remove(at: self.indexTable)
//        self.tableView.reloadData()
//    }
    
    var indexTable = 0
    func okAlertActionClicked() {
        if !Utils.isInternetAvailable() {
            Utils.showAlert(title: "Error", message: "Internet is not available. Please try again!", viewController: self)
            return
        }
        
        let civil = CivilManager.getInstance().civils[indexTable]
        SwiftOverlays.showBlockingWaitOverlay()
        let user = UserDAO.getUser(id: UserDefaultManager.getInstance().getCurrentUser())
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        
        let body = ["_method": "DELETE"] as [String : Any]
        
        Alamofire.request(Global.baseURL + "civil/" + String(civil.id) + "?token=" + (user?.token)!, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            SwiftOverlays.removeAllBlockingOverlays()
            switch response.result {
            case .success(_):
                let result = Response(data: response.data!)
                if result.success == "true" {
                    CivilDAO.deleteCivil(id: civil.id)
                    CivilManager.getInstance().civils.remove(at: self.indexTable)
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
        let civil = CivilManager.getInstance().civils[indexPath.row]
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let civilViewController = storyBoard.instantiateViewController(withIdentifier: "CivilViewController") as! CivilViewController
        civilViewController.civilDelegate = self
        civilViewController.civil = civil
        civilViewController.setup = false
        self.navigationController?.pushViewController(civilViewController, animated: true)
    }
    
    func saveNewCivilClicked() {
        tableView.reloadData()
    }
}
