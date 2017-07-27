//
//  SettingViewController.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 11/27/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import FontAwesomeKit

class SettingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ProfileDelegate, AlertDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let backBtn = UIButton()
    let closeBtn = UIButton()
    let gradientView = GradientView()
    let settingCellReuseIdentifier = "SettingCellReuseIdentifier"
    
    var headerView: SettingHeaderTableViewCell!
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
        
        self.navigationItem.title = "Setting"
        
        
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
        tableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: settingCellReuseIdentifier as String)
        headerView = SettingHeaderTableViewCell.instanceFromNib() as? SettingHeaderTableViewCell
        headerView?.nameLabel.text = user.firstname + " " + user.lastname
        headerView?.addressLabel.text = user.address
        
        tableView.tableHeaderView = headerView
        tableView.backgroundColor = Global.colorHeader
    }
    
    func backBtnClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Manager TableView
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingManager.getInstance().settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: SettingTableViewCell! = tableView.dequeueReusableCell(withIdentifier: settingCellReuseIdentifier as String) as? SettingTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none;
        
        let setting = SettingManager.getInstance().settings[indexPath.row]
        cell.setData(setting: setting)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let setting = SettingManager.getInstance().settings[indexPath.row]
        
        if setting.id == 0 {
            let profileViewController = ProfileViewController()
            profileViewController.profileDelegate = self
            self.navigationController?.pushViewController(profileViewController, animated: true)
        }
        else if setting.id == 1 {
            self.navigationController?.pushViewController(LifeLinesViewController(), animated: true)
        }
        else if setting.id == 2 {
            self.navigationController?.pushViewController(MessageeTemplateViewController(), animated: true)
        }
        else if setting.id == 3 {
            self.navigationController?.pushViewController(FileTransferViewController(), animated: true)
        }
        else if setting.id == 4 {
            self.navigationController?.pushViewController(EmergencySettingViewController(), animated: true)
        }
        else if setting.id == 5 {
            self.navigationController?.pushViewController(AudioSettingsViewController(), animated: true)
        }
        else if setting.id == 6 {
            self.navigationController?.pushViewController(LifeLifeViewController(), animated: true)
        }
        else if setting.id == 7 {
            Utils.showAlertAction(title: "Log Out", message: "Are you sure want to log out?", viewController: self, alertDelegate: self)
        }
        
    }
    
    func okAlertActionClicked() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let signInViewController = storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = signInViewController
        UserDefaultManager.getInstance().setCurrentUser(userID: 0)
        MultimediaManager.getInstance().allMultimedia = [Multimedia]()
    }
    
    func back() {
        headerView?.nameLabel.text = user.firstname + " " + user.lastname
        headerView?.addressLabel.text = user.address
    }
}
