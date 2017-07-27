//
//  EmergencyViewController.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 11/29/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import FontAwesomeKit
import Alamofire

class EmergencyViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    let nameBorder = UIView()
    let phoneBorder = UIView()
    
    var emergencyDelegate: EmergencyDelegate!
    var emergency: Emergency!
    let gradientView = GradientView()
    var setup = true

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "New Emergency"
        self.view.addTapToDismiss()
        
        let ttyIcon = FAKFontAwesome.ttyIcon(withSize: 100)
        ttyIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain)
        let ttyImg  = ttyIcon?.image(with: CGSize(width: 100, height: 100))
        iconImgView.image = ttyImg
        
        nameField.placeholder = "Name"
        nameField.delegate = self
        nameField.textColor = Global.colorSecond
        nameField.returnKeyType = .next
        nameField.keyboardType = .default
        nameField.inputAccessoryView = UIView()
        nameField.autocorrectionType = .no
        nameField.autocapitalizationType = .none
        nameField.addSubview(nameBorder)
        nameBorder.backgroundColor = Global.colorBg
        nameBorder.autoPinEdge(toSuperviewEdge: .left)
        nameBorder.autoPinEdge(toSuperviewEdge: .right)
        nameBorder.autoPinEdge(toSuperviewEdge: .bottom)
        nameBorder.autoSetDimension(.height, toSize: 1)
        
        phoneField.placeholder = "Phone"
        phoneField.delegate = self
        phoneField.textColor = Global.colorSecond
        phoneField.returnKeyType = .go
        phoneField.keyboardType = .numberPad
        phoneField.inputAccessoryView = UIView()
        phoneField.autocorrectionType = .no
        phoneField.autocapitalizationType = .none
        phoneField.addSubview(phoneBorder)
        phoneBorder.backgroundColor = Global.colorBg
        phoneBorder.autoPinEdge(toSuperviewEdge: .left)
        phoneBorder.autoPinEdge(toSuperviewEdge: .right)
        phoneBorder.autoPinEdge(toSuperviewEdge: .bottom)
        phoneBorder.autoSetDimension(.height, toSize: 1)
        
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
        
        if emergency != nil {
            nameField.text = emergency.name
            phoneField.text = emergency.phone
            self.title = "Update Emergency"
            saveBtn.setTitle("UPDATE", for: .normal)
            
            if emergency.sent && setup {
                self.title = ""
                saveBtn.isHidden = true
                nameField.isEnabled = false
                phoneField.isEnabled = false
            }
        }
    }
    
    func saveBtnClicked() {
        if !checkInput(textField: nameField, value: nameField.text) {
            return
        }
        if !checkInput(textField: phoneField, value: phoneField.text) {
            return
        }
        
        view.endEditing(true)
        
        if !Utils.isInternetAvailable() {
            Utils.showAlert(title: "Error", message: "Internet is not available. Please try again!", viewController: self)
            return
        }
        
        let name = nameField.text!
        let phone = phoneField.text!
        
        let newEmergency = Emergency()
        newEmergency.user_id = UserDefaultManager.getInstance().getCurrentUser()
        newEmergency.name = name
        newEmergency.phone = phone
        newEmergency.sent = false
        
        if setup {
            if emergency == nil {
                newEmergency.id = EmergencyDAO.getNextId()
                EmergencyDAO.addEmergency(emergency: newEmergency)
                EmergencyManager.getInstance().emergencies.append(newEmergency)
            }
            else {
                newEmergency.id = emergency.id
                EmergencyDAO.updateEmergency(emergency: newEmergency)
            }
            
            if emergencyDelegate != nil {
                emergencyDelegate.saveNewEmergencyClicked()
            }
            _ = navigationController?.popViewController(animated: true)
        }
        else {
            if emergency == nil {
                uploadNewEmergency(emergency: newEmergency)
            }
            else {
                newEmergency.id = emergency.id
                updateEmergency(emergency: newEmergency)
            }
        }
    }
    
    // delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        _ = checkInput(textField: textField, value: newString)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                phoneField.becomeFirstResponder()
                return true
            }
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
        case nameField:
            if value != nil && value!.isValidName() {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorBg
                return true
            }
            errorLabel.text = "Invalid name"
            textField.subviews.first?.backgroundColor = UIColor.red.withAlphaComponent(0.8)
        default:
            if value != nil && value!.isValidPhone() {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorBg
                return true
            }
            errorLabel.text = "Invalid phone"
            textField.subviews.first?.backgroundColor = UIColor.red.withAlphaComponent(0.8)
        }
        return false
    }

    func uploadNewEmergency(emergency: Emergency) {
        SwiftOverlays.showBlockingWaitOverlay()
        let user = UserDAO.getUser(id: UserDefaultManager.getInstance().getCurrentUser())
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        
        let body = ["user_id": emergency.user_id, "name": emergency.name, "phone": emergency.phone] as [String : Any]
        
        Alamofire.request(Global.baseURL + "emergency?token=" + (user?.token)!, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            SwiftOverlays.removeAllBlockingOverlays()
            switch response.result {
            case .success(_):
                let result = Response(data: response.data!)
                if result.success == "true" {
                    let emergencyResult = EmergencyResult(data: response.data!)
                    let newEmergency = Emergency()
                    newEmergency.id = emergencyResult.id
                    newEmergency.user_id = Int(emergencyResult.user_id)!
                    newEmergency.name = emergencyResult.name
                    newEmergency.phone = emergencyResult.phone
                    newEmergency.sent = true
                    EmergencyDAO.addEmergency(emergency: newEmergency)
                    EmergencyManager.getInstance().emergencies.append(newEmergency)
                    _ = self.navigationController?.popViewController(animated: true)
                    
                    if self.emergencyDelegate != nil {
                        self.emergencyDelegate.saveNewEmergencyClicked()
                    }
                }
                else {
                    Utils.showAlert(title: "Error", message: "Upload error. Please try again!", viewController: self)
                }
            case .failure(_):
                Utils.showAlert(title: "Error", message: "Upload error. Please try again!", viewController: self)
            }
        }
    }
    
    func updateEmergency(emergency: Emergency) {
        SwiftOverlays.showBlockingWaitOverlay()
        let user = UserDAO.getUser(id: UserDefaultManager.getInstance().getCurrentUser())
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        
        let body = ["user_id": emergency.user_id, "name": emergency.name, "phone": emergency.phone, "_method": "PUT"] as [String : Any]
        
        Alamofire.request(Global.baseURL + "emergency/" + String(emergency.id) + "?token=" + (user?.token)!, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            SwiftOverlays.removeAllBlockingOverlays()
            switch response.result {
            case .success(_):
                let result = Response(data: response.data!)
                if result.success == "true" {
                    let emergencyResult = EmergencyResult(data: response.data!)
                    let newEmergency = Emergency()
                    newEmergency.id = emergencyResult.id
                    newEmergency.user_id = Int(emergencyResult.user_id)!
                    newEmergency.name = emergencyResult.name
                    newEmergency.phone = emergencyResult.phone
                    newEmergency.sent = true
                    EmergencyDAO.updateEmergency(emergency: newEmergency)
                    _ = self.navigationController?.popViewController(animated: true)
                    
                    if self.emergencyDelegate != nil {
                        self.emergencyDelegate.saveNewEmergencyClicked()
                    }
                }
                else {
                    Utils.showAlert(title: "Error", message: "Upload error. Please try again!", viewController: self)
                }
            case .failure(_):
                Utils.showAlert(title: "Error", message: "Upload error. Please try again!", viewController: self)
            }
        }
    }

}
