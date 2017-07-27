//
//  MessageeTemplateViewController.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 12/21/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import FontAwesomeKit
import Alamofire

class MessageeTemplateViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AlertDelegate, MessageDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let messageCellReuseIdentifier = "MessageCellReuseIdentifier"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.edgesForExtendedLayout = UIRectEdge.bottom
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Message Template"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: messageCellReuseIdentifier as String)
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
    
    func addBtnClicked() {
        let addMessageViewController = AddMessageViewController()
        addMessageViewController.messageDelegate = self
        self.navigationController?.pushViewController(addMessageViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageManager.getInstance().messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MessageTableViewCell! = tableView.dequeueReusableCell(withIdentifier: messageCellReuseIdentifier as String) as? MessageTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        let message = MessageManager.getInstance().messages[indexPath.row]
        cell.messageLabel.text = message.content
        
        cell.closeBtn.addTarget(self, action: #selector(closeBtnCicked), for: .touchUpInside)
        cell.closeBtn.tag = indexPath.row

        return cell
    }
    
    func closeBtnCicked(_ sender: UIButton) {
        Utils.showAlertAction(title: "Message Deletion", message: "Are you are want to delete this message?", viewController: self, alertDelegate: self)
        indexTable = sender.tag
    }
    
    var indexTable = 0
    func okAlertActionClicked() {
        if !Utils.isInternetAvailable() {
            Utils.showAlert(title: "Error", message: "Internet is not available. Please try again!", viewController: self)
            return
        }
        
        let message = MessageManager.getInstance().messages[indexTable]
        SwiftOverlays.showBlockingWaitOverlay()
        let user = UserDAO.getUser(id: UserDefaultManager.getInstance().getCurrentUser())
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        
        let body = ["_method": "DELETE"] as [String : Any]
        
        Alamofire.request(Global.baseURL + "message/" + String(message.id) + "?token=" + (user?.token)!, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            SwiftOverlays.removeAllBlockingOverlays()
            switch response.result {
            case .success(_):
                let result = Response(data: response.data!)
                if result.success == "true" {
                    MessageDAO.deleteMessage(id: message.id)
                    MessageManager.getInstance().messages.remove(at: self.indexTable)
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
        let message = MessageManager.getInstance().messages[indexPath.row]
        let addMessageViewController = AddMessageViewController()
        addMessageViewController.messageDelegate = self
        addMessageViewController.message = message
        self.navigationController?.pushViewController(addMessageViewController, animated: true)
    }
    
    func saveNewMessageClicked () {
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let user = UserDAO.getUser(id: UserDefaultManager.getInstance().getCurrentUser())
        MessageManager.getInstance().messages = MessageDAO.querySearchMessage(userId:(user?.id)!, keyword: searchText)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParentViewController {
            MessageManager.getInstance().messages = MessageDAO.getAllMessages()
        }
    }
}
