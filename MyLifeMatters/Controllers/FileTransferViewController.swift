//
//  FileTransferViewController.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 12/21/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit

import UIKit
import FontAwesomeKit
import Alamofire

class FileTransferViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, AlertDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let fileTransferCellReuseIdentifier = "FileTransferCellReuseIdentifier"
    var switchBar: UISwitch!
    var user: User!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.edgesForExtendedLayout = UIRectEdge.bottom
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userID = UserDefaultManager.getInstance().getCurrentUser()
        user = UserDAO.getUser(id: userID)!
        
        self.title = "File Transfer"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "FileTransferTableViewCell", bundle: nil), forCellReuseIdentifier: fileTransferCellReuseIdentifier as String)
        tableView.tableFooterView = UIView()
        
        switchBar = UISwitch(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        switchBar.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
        if user.transfer == "no" {
            switchBar.isOn = false
        }
        else {
            switchBar.isOn = true
        }

        let switchBtn = UIBarButtonItem(customView: switchBar)
        self.navigationItem.rightBarButtonItem = switchBtn
        
        searchBar.delegate = self
        searchBar.placeholder = "Search..."
    }
    
    func backBtnClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MultimediaManager.getInstance().allMultimedia.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: FileTransferTableViewCell! = tableView.dequeueReusableCell(withIdentifier: fileTransferCellReuseIdentifier as String) as? FileTransferTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        let multimedia = MultimediaManager.getInstance().allMultimedia[indexPath.row]
        cell.pathLabel.text = multimedia.name
        if multimedia.type_id == 5 {
            let musicIcon = FAKFontAwesome.musicIcon(withSize: 20)
            musicIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
            let musicImg  = musicIcon?.image(with: CGSize(width: 25, height: 25))
            cell.iconBtn.setImage(musicImg, for: .normal)
        }
        else if multimedia.type_id == 6 {
            let fileImageOIcon = FAKFontAwesome.fileImageOIcon(withSize: 20)
            fileImageOIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
            let fileImageOImg  = fileImageOIcon?.image(with: CGSize(width: 25, height: 25))
            cell.iconBtn.setImage(fileImageOImg, for: .normal)
        }
        else if multimedia.type_id == 7 {
            let fileVideoOIcon = FAKFontAwesome.fileVideoOIcon(withSize: 20)
            fileVideoOIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
            let fileVideoOImg  = fileVideoOIcon?.image(with: CGSize(width: 25, height: 25))
            cell.iconBtn.setImage(fileVideoOImg, for: .normal)
        }
        else {
            let fileIcon = FAKFontAwesome.fileIcon(withSize: 20)
            fileIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
            let fileImg  = fileIcon?.image(with: CGSize(width: 25, height: 25))
            cell.iconBtn.setImage(fileImg, for: .normal)
        }

        cell.shareBtn.addTarget(self, action: #selector(moreClicked), for: .touchUpInside)
        cell.shareBtn.tag = indexPath.row
        
        return cell
    }
    
    func moreClicked(_ sender: UIButton!) {
        let multimedia = MultimediaManager.getInstance().allMultimedia[sender.tag]

        let optionMenu = UIAlertController(title: nil, message: "Choose option", preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: "Share", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if let myWebsite = NSURL(string: "http://yteannguyen.com/api/mylife/public/upload/" + multimedia.path) {
                let objectsToShare = ["", myWebsite] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                self.present(activityVC, animated: true, completion: nil)
            }
        })
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            Utils.showAlertAction(title: "File Deletion", message: "Are you are want to delete this file?", viewController: self, alertDelegate: self)
            self.indexTable = sender.tag
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(shareAction)
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        optionMenu.popoverPresentationController?.sourceView = sender
        optionMenu.popoverPresentationController?.sourceRect = sender.bounds
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    var indexTable = 0
    func okAlertActionClicked() {
        if !Utils.isInternetAvailable() {
            Utils.showAlert(title: "Error", message: "Internet is not available. Please try again!", viewController: self)
            return
        }
        
        let multimedia = MultimediaManager.getInstance().allMultimedia[indexTable]
        
        SwiftOverlays.showBlockingWaitOverlay()
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let body = ["_method": "DELETE"] as [String : Any]
        
        Alamofire.request(Global.baseURL + "multimedia/" + String(multimedia.id) + "?token=" + (user?.token)!, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            SwiftOverlays.removeAllBlockingOverlays()
            switch response.result {
            case .success(_):
                let result = Response(data: response.data!)
                if result.success == "true" {
                    if multimedia.type_id == 5{
                        UserDefaultManager.getInstance().setIndexAudioList(value: 0)
                    }
                    MultimediaDAO.deleteMultimedia(id: multimedia.id)
                    MultimediaManager.getInstance().allMultimedia.remove(at: self.indexTable)
                    self.tableView.reloadData()
                    MultimediaManager.getInstance().audios = [Multimedia]()
                    MultimediaManager.getInstance().audios = MultimediaDAO.getMultimediaByUserIdAndTypeId(userId: self.user.id, typeID: 5)
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
        
        let multimedia = MultimediaManager.getInstance().allMultimedia[indexPath.row]
        let url = URL(string: "http://yteannguyen.com/api/mylife/public/upload/" + multimedia.path)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        MultimediaManager.getInstance().allMultimedia = MultimediaDAO.querySearchMultimedia(userId: (user?.id)!, keyword: searchText)
        tableView.reloadData()
    }
    
    func switchValueDidChange(_ sender: UISwitch!) {
        toggle()
    }
    
    func toggle() {
        
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
        newUser.bypass = user.bypass
        newUser.setup = user.setup
        newUser.transfer = user.transfer
        newUser.sent_profile = true
        
        Alamofire.request(Global.baseURL + "transfer/" + String(user.id) + "?token=" + user.token, method: .post).responseJSON { response in
            switch response.result {
            case .success(_):
                let result = Response(data: response.data!)
                if result.success == "true" {
                    if self.switchBar.isOn {
                        self.switchBar.isOn = true
                        newUser.transfer = "yes"
                    }
                    else {
                        self.switchBar.isOn = false
                        newUser.transfer = "no"
                    }
                    UserDAO.updateUser(user: newUser)
                }
                else {
                    Utils.showAlert(title: "Error", message: "Could not connect to server. Please try again!", viewController: self)
                }
            case .failure(_):
                Utils.showAlert(title: "Error", message: "Could not connect to server. Please try again!", viewController: self)
            }
        }
        
    }
}
