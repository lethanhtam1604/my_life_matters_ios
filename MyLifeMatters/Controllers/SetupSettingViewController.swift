//
//  SetupSettingViewController.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 11/26/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import FontAwesomeKit
import Alamofire

class SetupSettingViewController: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var byPassBtn: UIButton!
    
    var isByPass = false
    let gradientView = GradientView()
    var user: User!
    var timer: Timer!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.edgesForExtendedLayout = UIRectEdge.bottom
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userId = UserDefaultManager.getInstance().getCurrentUser()
        user = UserDAO.getUser(id: userId)!
        
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
        
        let iosCheckmarkEmptyIcon = FAKIonIcons.iosCheckmarkEmptyIcon(withSize: 40)
        iosCheckmarkEmptyIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let iosCheckmarkEmptyImg  = iosCheckmarkEmptyIcon?.image(with: CGSize(width: 40, height: 35))
        nextBtn.setImage(iosCheckmarkEmptyImg, for: .normal)
        nextBtn.tintColor = UIColor.white
        nextBtn.addTarget(self, action: #selector(nextBtnClicked), for: .touchUpInside)
        nextBtn.imageView?.contentMode = .scaleAspectFit
        nextBtn.insertSubview(gradientView, at: 0)
        
        gradientView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
        gradientView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        gradientView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
        gradientView.autoSetDimension(.height, toSize: 45)
        
        let circleThinIcon = FAKFontAwesome.circleThinIcon(withSize: 40)
        circleThinIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain)
        let circleThinImg  = circleThinIcon?.image(with: CGSize(width: 40, height: 40))
        byPassBtn.setImage(circleThinImg, for: .normal)
        byPassBtn.tintColor = Global.colorMain
        byPassBtn.addTarget(self, action: #selector(byPassBtnClicked), for: .touchUpInside)
        byPassBtn.imageView?.contentMode = .scaleAspectFit

        if user.bypass == "yes" {
            onByPass()
        }
        print(user)
    }
    
    func backBtnClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    func nextBtnClicked() {
        if !Utils.isInternetAvailable() {
            Utils.showAlert(title: "Error", message: "Internet is not available. Please try again!", viewController: self)
            return
        }
        _ = SwiftOverlays.showBlockingWaitOverlayWithText("Uploading data...")
        
        let newUser = User()
        newUser.id = user.id
        newUser.account = user.account
        newUser.phone = user.phone
        newUser.email = user.email
        newUser.password = user.password
        newUser.firstname = user.firstname
        newUser.lastname = user.lastname
        newUser.birthday = user.birthday
        newUser.address = user.address
        newUser.token = user.token
        newUser.sent_profile = user.sent_profile
        newUser.sent_bypass = false
        if isByPass {
            newUser.bypass = "yes"
        }
        else {
            newUser.bypass = "no"
        }
        newUser.setup = "yes"
        
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let body = ["firstname": newUser.firstname, "lastname": newUser.lastname,  "birthday": "2016-12-10",  "address": newUser.address, "bypass": newUser.bypass, "setup": newUser.setup, "_method": "PUT"]
        
        Alamofire.request(Global.baseURL + "profile/" + String(user.id) + "?token=" + user.token, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(_):
                let result = Response(data: response.data!)
                if result.success == "true" {
                    newUser.sent_bypass = true
                    UserDAO.updateUser(user: newUser)
                    self.checkUploadDataToServer()
//                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.checkUploadDataToServer), userInfo: nil, repeats: true)
                }
                else {
                    SwiftOverlays.removeAllBlockingOverlays()
                    Utils.showAlert(title: "Error", message: "Could not upload data to server. Please try again!", viewController: self)
                }
            case .failure(_):
                Utils.showAlert(title: "Error", message: "Could not upload data to server. Please try again!", viewController: self)
                SwiftOverlays.removeAllBlockingOverlays()
                return
            }
        }
    }
    
    var success = true
    func checkUploadDataToServer() {
        
//        let user = UserDAO.getUser(id: UserDefaultManager.getInstance().getCurrentUser())!
//        
//        if !user.sent_profile {
//            return
//        }
//        
//        CivilManager.getInstance().civils = CivilDAO.getAllCivils()
//        ContactManager.getInstance().contacts = ContactDAO.getAllContacts()
//        EmergencyManager.getInstance().emergencies = EmergencyDAO.getAllEmergencys()
//        
//        for civil in CivilManager.getInstance().civils {
//            if !civil.sent {
//                success = false
//                break
//            }
//        }
//        
//        for contact in ContactManager.getInstance().contacts {
//            if !contact.sent {
//                success = false
//                break
//            }
//        }
//        
//        for emergency in EmergencyManager.getInstance().emergencies {
//            if !emergency.sent {
//                success = false
//                break
//            }
//        }
//        
//        if !success {
//            return
//        }
        
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        
        SwiftOverlays.removeAllBlockingOverlays()
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let mainViewController = storyBoard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        let nav = UINavigationController(rootViewController: mainViewController)
        self.present(nav, animated:true, completion:nil)
    }
    
    func byPassBtnClicked() {
        if !isByPass {
            onByPass()
        }
        else {
            offByPass()
        }
    }
    
    func onByPass() {
        let checkCircleIcon = FAKFontAwesome.checkCircleIcon(withSize: 40)
        checkCircleIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain)
        let checkCircleImg  = checkCircleIcon?.image(with: CGSize(width: 40, height: 40))
        byPassBtn.setImage(checkCircleImg, for: .normal)
        isByPass = true
    }
    
    func offByPass() {
        let circleThinIcon = FAKFontAwesome.circleThinIcon(withSize: 40)
        circleThinIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain)
        let circleThinImg  = circleThinIcon?.image(with: CGSize(width: 40, height: 40))
        byPassBtn.setImage(circleThinImg, for: .normal)
        isByPass = false
    }
}

