//
//  AddMessageViewController.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 12/21/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import FontAwesomeKit
import Alamofire

protocol MessageDelegate {
    func saveNewMessageClicked()
}

class AddMessageViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var contentField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    let contentBorder = UIView()
    
    var messageDelegate: MessageDelegate!
    var message: Message!
    let gradientView = GradientView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "New Message"
        self.view.addTapToDismiss()
        
        let chatbubbleWorkingIcon = FAKIonIcons.chatbubbleWorkingIcon(withSize: 100)
        chatbubbleWorkingIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain)
        let chatbubbleWorkingImg  = chatbubbleWorkingIcon?.image(with: CGSize(width: 100, height: 100))
        iconImgView.image = chatbubbleWorkingImg
        
        contentField.placeholder = "Content"
        contentField.delegate = self
        contentField.textColor = Global.colorSecond
        contentField.returnKeyType = .next
        contentField.keyboardType = .default
        contentField.inputAccessoryView = UIView()
        contentField.autocorrectionType = .no
        contentField.autocapitalizationType = .none
        contentField.addSubview(contentBorder)
        
        contentBorder.backgroundColor = Global.colorBg
        contentBorder.autoPinEdge(toSuperviewEdge: .left)
        contentBorder.autoPinEdge(toSuperviewEdge: .right)
        contentBorder.autoPinEdge(toSuperviewEdge: .bottom)
        contentBorder.autoSetDimension(.height, toSize: 1)
        
        saveBtn.setTitle("SAVE", for: .normal)
        saveBtn.setTitleColor(UIColor.white, for: .normal)
        saveBtn.setTitleColor(Global.colorSelected, for: .highlighted)
        saveBtn.insertSubview(gradientView, at: 0)
        saveBtn.layer.cornerRadius = 5
        saveBtn.clipsToBounds = true
        saveBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: (saveBtn.titleLabel?.font.pointSize)!)
        saveBtn.addTarget(self, action: #selector(saveBtnClicked), for: .touchUpInside)
        
        gradientView.autoPinEdge(toSuperviewEdge: .left)
        gradientView.autoPinEdge(toSuperviewEdge: .right)
        gradientView.autoPinEdge(toSuperviewEdge: .top)
        gradientView.autoSetDimension(.height, toSize: 40)
        
        errorLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
        errorLabel.textAlignment = .center
        errorLabel.textColor = UIColor.red.withAlphaComponent(0.7)
        errorLabel.adjustsFontSizeToFitWidth = true
        
        if message != nil {
            contentField.text = message.content
            self.title = "Update Message"
            saveBtn.setTitle("UPDATE", for: .normal)
        }
    }
    
    func saveBtnClicked() {
        if !checkInput(textField: contentField, value: contentField.text) {
            return
        }
        
        view.endEditing(true)
        
        if !Utils.isInternetAvailable() {
            Utils.showAlert(title: "Error", message: "Internet is not available. Please try again!", viewController: self)
            return
        }
        
        let content = contentField.text!
        
        let newMessage = Message()
        newMessage.user_id = UserDefaultManager.getInstance().getCurrentUser()
        newMessage.content = content
        
        if message == nil {
            uploadNewMessage(message: newMessage)
        }
        else {
            newMessage.id = message.id
            updateMessage(message: newMessage)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        _ = checkInput(textField: textField, value: newString)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        default:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                saveBtnClicked()
                return true
            }
        }
        
        return false
    }
    
    func checkInput(textField: UITextField, value: String?) -> Bool {
        switch textField {
        default:
            if value != nil && value!.isValidMessage() {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorBg
                return true
            }
            errorLabel.text = "Invalid content"
            textField.subviews.first?.backgroundColor = UIColor.red.withAlphaComponent(0.8)
        }
        return false
    }
    
    func uploadNewMessage(message: Message) {
        SwiftOverlays.showBlockingWaitOverlay()
        let user = UserDAO.getUser(id: UserDefaultManager.getInstance().getCurrentUser())
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        
        let body = ["user_id": message.user_id, "content": message.content] as [String : Any]
        
        Alamofire.request(Global.baseURL + "message?token=" + (user?.token)!, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            SwiftOverlays.removeAllBlockingOverlays()
            switch response.result {
            case .success(_):
                let result = Response(data: response.data!)
                if result.success == "true" {
                    let messageResult = MessageResult(data: response.data!)
                    let newMessage = Message()
                    newMessage.id = messageResult.id
                    newMessage.user_id = Int(messageResult.user_id)!
                    newMessage.content = messageResult.content
                    MessageDAO.addMessage(message: newMessage)
                    MessageManager.getInstance().messages.append(newMessage)
                    _ = self.navigationController?.popViewController(animated: true)
                    
                    if self.messageDelegate != nil {
                        self.messageDelegate.saveNewMessageClicked()
                    }
                }
                else {
                    Utils.showAlert(title: "Error", message: "Upload error. Please try again!", viewController: self)
                }
            case .failure(_):
                Utils.showAlert(title: "Error", message: "Upload error. Please try again!", viewController: self)
                return
            }
        }
    }
    
    func updateMessage(message: Message) {
        SwiftOverlays.showBlockingWaitOverlay()
        let user = UserDAO.getUser(id: UserDefaultManager.getInstance().getCurrentUser())
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        
        let body = ["user_id": message.user_id, "content": message.content, "_method": "PUT"] as [String : Any]
        
        Alamofire.request(Global.baseURL + "message/" + String(message.id) + "?token=" + (user?.token)!, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            SwiftOverlays.removeAllBlockingOverlays()
            switch response.result {
            case .success(_):
                let result = Response(data: response.data!)
                if result.success == "true" {
                    let messageResult = MessageResult(data: response.data!)
                    let newMessage = Message()
                    newMessage.id = messageResult.id
                    newMessage.user_id = Int(messageResult.user_id)!
                    newMessage.content = messageResult.content
                    MessageDAO.updateMessage(message: newMessage)
                    _ = self.navigationController?.popViewController(animated: true)
                    
                    if self.messageDelegate != nil {
                        self.messageDelegate.saveNewMessageClicked()
                    }
                }
                else {
                    Utils.showAlert(title: "Error", message: "Upload error. Please try again!", viewController: self)
                }
            case .failure(_):
                Utils.showAlert(title: "Error", message: "Upload error. Please try again!", viewController: self)
                return
            }
        }
    }
    
}
