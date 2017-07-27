//
//  MessageChosenViewController.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 12/23/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import STPopup

protocol MessageChosenDelegate {
    func messageClicked(message: String)
}

class MessageChosenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let messageTemplateCellReuseIdentifier = "MessageTemplateCellReuseIdentifier"
    
    var messageChosenDelegate: MessageChosenDelegate!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.edgesForExtendedLayout = UIRectEdge.bottom
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Messages Template"
        self.contentSizeInPopup = CGSize(width: ScreenSize.SCREEN_WIDTH - 50, height: ScreenSize.SCREEN_HEIGHT - 200)
        self.landscapeContentSizeInPopup = CGSize(width: ScreenSize.SCREEN_WIDTH - 100, height: ScreenSize.SCREEN_HEIGHT - 50)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "MessageTemplateTableViewCell", bundle: nil), forCellReuseIdentifier: messageTemplateCellReuseIdentifier as String)
        tableView.tableFooterView = UIView()        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageManager.getInstance().messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MessageTemplateTableViewCell! = tableView.dequeueReusableCell(withIdentifier: messageTemplateCellReuseIdentifier as String) as? MessageTemplateTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        let message = MessageManager.getInstance().messages[indexPath.row]
        cell.messageLabel.text = message.content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = MessageManager.getInstance().messages[indexPath.row]
        if messageChosenDelegate != nil {
            messageChosenDelegate.messageClicked(message: message.content)
        }
    }
    
}
