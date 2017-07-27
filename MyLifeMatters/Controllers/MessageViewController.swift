//
//  MessageViewController.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 12/14/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//
import UIKit
import FontAwesomeKit
import GrowingTextView
import MessageUI
import STPopup

class MessageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GrowingTextViewDelegate, AlertDelegate, MFMessageComposeViewControllerDelegate, MessageChosenDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let callCellReuseIdentifier = "CallCellReuseIdentifier"
    let chatView = UIView()
    let borderChat = UIView()
    let chatTextView = GrowingTextView()
    let sendBtn = UIButton()
    let messageBtn = UIButton()
    let closeBtn = UIButton()
    var heightChatView: NSLayoutConstraint!
    
    var constraintsAdded = false
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
        
        self.navigationItem.title = "Message"
        self.view.addTapToDismiss()
        
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
        
        let androidSendIcon = FAKIonIcons.androidSendIcon(withSize: 10)
        androidSendIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let  androidSendImg  = androidSendIcon?.image(with: CGSize(width: 15, height: 15))
        sendBtn.setImage(androidSendImg, for: .normal)
        sendBtn.tintColor = UIColor.white
        sendBtn.clipsToBounds = true
        sendBtn.layer.cornerRadius = 15
        sendBtn.backgroundColor = Global.colorMain
        sendBtn.imageView?.contentMode = .scaleAspectFit
        sendBtn.addTarget(self, action: #selector(sendSms), for: .touchUpInside)
        
        let chatboxWorkingIcon = FAKIonIcons.chatboxWorkingIcon(withSize: 10)
        chatboxWorkingIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let  chatboxWorkingImg  = chatboxWorkingIcon?.image(with: CGSize(width: 15, height: 15))
        messageBtn.setImage(chatboxWorkingImg, for: .normal)
        messageBtn.tintColor = UIColor.white
        messageBtn.clipsToBounds = true
        messageBtn.layer.cornerRadius = 15
        messageBtn.backgroundColor = Global.colorMain
        messageBtn.imageView?.contentMode = .scaleAspectFit
        messageBtn.addTarget(self, action: #selector(messageBtnClicked), for: .touchUpInside)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CallTableViewCell", bundle: nil), forCellReuseIdentifier: callCellReuseIdentifier as String)
        tableView.tableFooterView = UIView()

        borderChat.backgroundColor = Global.colorGray
        
        chatTextView.delegate = self
        chatTextView.layer.borderColor = Global.colorGray.cgColor
        chatTextView.layer.borderWidth = 0.3
        chatTextView.layer.cornerRadius = 5
        chatTextView.maxHeight = 150
        chatTextView.trimWhiteSpaceWhenEndEditing = true
        chatTextView.placeHolder = "Write message..."
        chatTextView.placeHolderColor = UIColor(white: 0.8, alpha: 1.0)
        chatTextView.placeHolderLeftMargin = 5.0
        chatTextView.font = UIFont.systemFont(ofSize: 15)
        
        if MessageManager.getInstance().messages.count > 0 {
            chatTextView.text = MessageManager.getInstance().messages[0].content
        }
        
        chatView.addSubview(borderChat)
        chatView.addSubview(chatTextView)
        chatView.addSubview(sendBtn)
        chatView.addSubview(messageBtn)

        view.addSubview(chatView)
        
        self.view.setNeedsUpdateConstraints()
    }
    
    func textViewDidChangeHeight(_ height: CGFloat) {
        if height <= 40 {
            heightChatView.constant = 40 + 10
        }
        else {
            heightChatView.constant = height + 15
        }
        print(height)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !constraintsAdded {
            constraintsAdded = true
            
            tableView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            tableView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            tableView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            tableView.autoPinEdge(.bottom, to: .top, of: chatView, withOffset: -5)
            
            chatView.autoPinEdge(toSuperviewEdge: .left)
            chatView.autoPinEdge(toSuperviewEdge: .right)
            chatView.autoPinEdge(toSuperviewEdge: .bottom)
            heightChatView = chatView.autoSetDimension(.height, toSize: 50)
            
            borderChat.autoPinEdge(toSuperviewEdge: .left)
            borderChat.autoPinEdge(toSuperviewEdge: .right)
            borderChat.autoPinEdge(toSuperviewEdge: .top)
            borderChat.autoSetDimension(.height, toSize: 0.5)
            
            chatTextView.autoPinEdge(toSuperviewEdge: .left, withInset: 5)
            chatTextView.autoPinEdge(.right, to: .left, of: messageBtn, withOffset: -10)
            chatTextView.autoAlignAxis(toSuperviewAxis: .horizontal)
            
            sendBtn.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            sendBtn.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)
            sendBtn.autoSetDimension(.height, toSize: 30)
            sendBtn.autoSetDimension(.width, toSize: 30)
            
            messageBtn.autoPinEdge(.trailing, to: .leading, of: sendBtn, withOffset: -10)
            messageBtn.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)
            messageBtn.autoSetDimension(.height, toSize: 30)
            messageBtn.autoSetDimension(.width, toSize: 30)
        }
    }
    
    var messageTemplatePopupController: STPopupController!

    func messageBtnClicked() {
        
        STPopupNavigationBar.appearance().tintColor = UIColor.white
        STPopupNavigationBar.appearance().barTintColor = Global.colorMain
        STPopupNavigationBar.appearance().barStyle = .default
        
        let messageChosenViewController = MessageChosenViewController()
        messageChosenViewController.messageChosenDelegate = self
        messageTemplatePopupController = STPopupController(rootViewController: messageChosenViewController)
        messageTemplatePopupController.containerView.layer.cornerRadius = 4
        messageTemplatePopupController.present(in: self)
    }
    
    func messageClicked(message: String) {
        chatTextView.text = message
        messageTemplatePopupController.dismiss()
    }
    
    func sendSms() {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = chatTextView.text
            var recipients = [String]()
            for contact in ContactManager.getInstance().contacts {
                recipients.append(contact.phone)
            }
            controller.recipients = recipients
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func okAlertActionClicked() {
        
    }
    
    func backBtnClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContactManager.getInstance().contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: CallTableViewCell! = tableView.dequeueReusableCell(withIdentifier: callCellReuseIdentifier as String) as? CallTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        let contact = ContactManager.getInstance().contacts[indexPath.row]
        cell.numberLabel.text = String(contact.number)
        let index = contact.profile.index(contact.profile.startIndex, offsetBy: 1)
        cell.numberLabel.text = contact.profile.substring(to: index).uppercased()
        
        cell.numberNameLabel.text = contact.profile
        cell.phoneNumberLabel.text = contact.phone
        return cell
    }
}
