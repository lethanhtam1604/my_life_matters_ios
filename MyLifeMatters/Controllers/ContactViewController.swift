//
//  ContactViewController.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 11/28/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import FontAwesomeKit
import Alamofire

class ContactViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var addressBookBtn: UIButton!
    @IBOutlet weak var profileNameField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var relationshipField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    let profileNameBorder = UIView()
    let firstNameBorder = UIView()
    let lastNameBorder = UIView()
    let phoneBorder = UIView()
    let emailBorder = UIView()
    let relationshipBorder = UIView()

    var contactDelegate: ContactDelegate!
    let gradientView = GradientView()
    
    var contact: Contact!
    var setup = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "New Contact"
        self.view.addTapToDismiss()
        
        let addressBookIcon = FAKFoundationIcons.addressBookIcon(withSize: 100)
        addressBookIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain)
        let addressBookImg  = addressBookIcon?.image(with: CGSize(width: 100, height: 100))
        addressBookBtn.setImage(addressBookImg, for: .normal)
        addressBookBtn.tintColor = Global.colorMain
        addressBookBtn.imageView?.contentMode = .scaleAspectFit
        
        profileNameField.placeholder = "Profile Name"
        profileNameField.delegate = self
        profileNameField.textColor = Global.colorSecond
        profileNameField.returnKeyType = .next
        profileNameField.keyboardType = .namePhonePad
        profileNameField.inputAccessoryView = UIView()
        profileNameField.autocorrectionType = .no
        profileNameField.autocapitalizationType = .none
        profileNameField.addSubview(profileNameBorder)
        profileNameBorder.backgroundColor = Global.colorBg
        profileNameBorder.autoPinEdge(toSuperviewEdge: .left)
        profileNameBorder.autoPinEdge(toSuperviewEdge: .right)
        profileNameBorder.autoPinEdge(toSuperviewEdge: .bottom)
        profileNameBorder.autoSetDimension(.height, toSize: 1)
        
        firstNameField.placeholder = "First Name"
        firstNameField.delegate = self
        firstNameField.textColor = Global.colorSecond
        firstNameField.returnKeyType = .next
        firstNameField.keyboardType = .namePhonePad
        firstNameField.inputAccessoryView = UIView()
        firstNameField.autocorrectionType = .no
        firstNameField.autocapitalizationType = .none
        firstNameField.addSubview(firstNameBorder)
        firstNameBorder.backgroundColor = Global.colorBg
        firstNameBorder.autoPinEdge(toSuperviewEdge: .left)
        firstNameBorder.autoPinEdge(toSuperviewEdge: .right)
        firstNameBorder.autoPinEdge(toSuperviewEdge: .bottom)
        firstNameBorder.autoSetDimension(.height, toSize: 1)
        
        lastNameField.placeholder = "Last Name"
        lastNameField.delegate = self
        lastNameField.textColor = Global.colorSecond
        lastNameField.returnKeyType = .next
        lastNameField.keyboardType = .namePhonePad
        lastNameField.inputAccessoryView = UIView()
        lastNameField.autocorrectionType = .no
        lastNameField.autocapitalizationType = .none
        lastNameField.addSubview(lastNameBorder)
        lastNameBorder.backgroundColor = Global.colorBg
        lastNameBorder.autoPinEdge(toSuperviewEdge: .left)
        lastNameBorder.autoPinEdge(toSuperviewEdge: .right)
        lastNameBorder.autoPinEdge(toSuperviewEdge: .bottom)
        lastNameBorder.autoSetDimension(.height, toSize: 1)
        
        phoneField.placeholder = "Phone"
        phoneField.delegate = self
        phoneField.textColor = Global.colorSecond
        phoneField.returnKeyType = .next
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
        
        emailField.placeholder = "Email"
        emailField.delegate = self
        emailField.textColor = Global.colorSecond
        emailField.returnKeyType = .next
        emailField.keyboardType = .emailAddress
        emailField.inputAccessoryView = UIView()
        emailField.autocorrectionType = .no
        emailField.autocapitalizationType = .none
        emailField.addSubview(emailBorder)
        emailBorder.backgroundColor = Global.colorBg
        emailBorder.autoPinEdge(toSuperviewEdge: .left)
        emailBorder.autoPinEdge(toSuperviewEdge: .right)
        emailBorder.autoPinEdge(toSuperviewEdge: .bottom)
        emailBorder.autoSetDimension(.height, toSize: 1)
        
        relationshipField.placeholder = "Relationship"
        relationshipField.delegate = self
        relationshipField.textColor = Global.colorSecond
        relationshipField.returnKeyType = .go
        relationshipField.keyboardType = .namePhonePad
        relationshipField.inputAccessoryView = UIView()
        relationshipField.autocorrectionType = .no
        relationshipField.autocapitalizationType = .none
        relationshipField.addSubview(relationshipBorder)
        relationshipBorder.backgroundColor = Global.colorBg
        relationshipBorder.autoPinEdge(toSuperviewEdge: .left)
        relationshipBorder.autoPinEdge(toSuperviewEdge: .right)
        relationshipBorder.autoPinEdge(toSuperviewEdge: .bottom)
        relationshipBorder.autoSetDimension(.height, toSize: 1)
        
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
        
        if contact != nil {
            profileNameField.text = contact.profile
            firstNameField.text = contact.firstname
            lastNameField.text = contact.lastname
            phoneField.text = contact.phone
            emailField.text = contact.email
            relationshipField.text = contact.relationship
            self.title = "Update Contact"
            saveBtn.setTitle("UPDATE", for: .normal)
            
            if contact.sent && setup {
                self.title = ""
                saveBtn.isHidden = true
                profileNameField.isEnabled = false
                firstNameField.isEnabled = false
                lastNameField.isEnabled = false
                phoneField.isEnabled = false
                emailField.isEnabled = false
                relationshipField.isEnabled = false
            }
        }
    }

    func saveBtnClicked() {
        if !checkInput(textField: profileNameField, value: profileNameField.text) {
            return
        }
        if !checkInput(textField: firstNameField, value: firstNameField.text) {
            return
        }
        if !checkInput(textField: lastNameField, value: lastNameField.text) {
            return
        }
        if !checkInput(textField: phoneField, value: phoneField.text) {
            return
        }
        if !checkInput(textField: emailField, value: emailField.text) {
            return
        }
        if !checkInput(textField: relationshipField, value: relationshipField.text) {
            return
        }
   
        view.endEditing(true)
        
        if !Utils.isInternetAvailable() {
            Utils.showAlert(title: "Error", message: "Internet is not available. Please try again!", viewController: self)
            return
        }
        
        let profileName = profileNameField.text!
        let firstName = firstNameField.text!
        let lastName = lastNameField.text!
        let phone = phoneField.text!
        let email = emailField.text!
        let relationship = relationshipField.text!
        
        let newContact  = Contact()
        newContact.user_id = UserDefaultManager.getInstance().getCurrentUser()
        newContact.profile = profileName
        newContact.firstname = firstName
        newContact.lastname = lastName
        newContact.phone = phone
        newContact.email = email
        newContact.relationship = relationship
        newContact.sent = false

        if setup {
            if contact == nil {
                newContact.number = ContactManager.getInstance().contacts.count
                newContact.id = ContactDAO.getNextId()
                ContactDAO.addContact(contact: newContact)
                ContactManager.getInstance().contacts.append(newContact)
            }
            else {
                newContact.number = contact.number
                newContact.id = contact.id
                ContactDAO.updateContact(contact: newContact)
            }
            
            if contactDelegate != nil {
                contactDelegate.saveNewContactClicked()
            }
            _ = navigationController?.popViewController(animated: true)
        }
        else {
            if contact == nil {
                newContact.number = ContactManager.getInstance().contacts.count
                uploadNewContact(contact: newContact)
            }
            else {
                newContact.number = contact.number
                newContact.id = contact.id
                updateContact(contact: newContact)
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
        case profileNameField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                firstNameField.becomeFirstResponder()
                return true
            }
        case firstNameField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                lastNameField.becomeFirstResponder()
                return true
            }
        case lastNameField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                phoneField.becomeFirstResponder()
                return true
            }
        case phoneField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                emailField.becomeFirstResponder()
                return true
            }
        case emailField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                relationshipField.becomeFirstResponder()
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
        case profileNameField:
            if value != nil && value!.isValidName() {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorBg
                return true
            }
            errorLabel.text = "Invalid profile name"
            textField.subviews.first?.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            
        case firstNameField:
            if value != nil && value!.isValidName() {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorBg
                return true
            }
            errorLabel.text = "Invalid first name"
            textField.subviews.first?.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            
        case lastNameField:
            if value != nil && value!.isValidName() {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorBg
                return true
            }
            errorLabel.text = "Invalid last name"
            textField.subviews.first?.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            
        case emailField:
            if value != nil && value!.isValidEmail() {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorBg
                return true
            }
            errorLabel.text = "Invalid email address"
            textField.subviews.first?.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            
        case phoneField:
            if value != nil && value!.isValidPhone() {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorBg
                return true
            }
            errorLabel.text = "Invalid phone number"
            textField.subviews.first?.backgroundColor = UIColor.red.withAlphaComponent(0.8)

        default:
            if value != nil && value!.isValidName() {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorBg
                return true
            }
            errorLabel.text = "Invalid relationship"
            textField.subviews.first?.backgroundColor = UIColor.red.withAlphaComponent(0.8)
        }
        return false
    }
    
    func uploadNewContact(contact: Contact) {
        SwiftOverlays.showBlockingWaitOverlay()
        let user = UserDAO.getUser(id: UserDefaultManager.getInstance().getCurrentUser())
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        
        let body = ["user_id": contact.user_id, "profile": contact.profile, "firstname": contact.firstname, "lastname": contact.lastname, "phone": contact.phone, "email": contact.email, "relationship": contact.relationship, "number": String(contact.number)] as [String : Any]
        
        Alamofire.request(Global.baseURL + "contact?token=" + (user?.token)!, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            SwiftOverlays.removeAllBlockingOverlays()
            switch response.result {
            case .success(_):
                let result = Response(data: response.data!)
                if result.success == "true" {
                    let contactResult = ContactResult(data: response.data!)
                    let newContact  = Contact()
                    newContact.id = contactResult.id
                    newContact.user_id = Int(contactResult.user_id)!
                    newContact.profile = contactResult.profile
                    newContact.firstname = contactResult.firstname
                    newContact.lastname = contactResult.lastname
                    newContact.phone = contactResult.phone
                    newContact.email = contactResult.email
                    newContact.relationship = contactResult.relationship
                    newContact.sent = true
                    newContact.number = contact.number

                    ContactDAO.addContact(contact: newContact)
                    ContactManager.getInstance().contacts.append(newContact)
                    _ = self.navigationController?.popViewController(animated: true)
                    
                    if self.contactDelegate != nil {
                        self.contactDelegate.saveNewContactClicked()
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
    
    func updateContact(contact: Contact) {
        SwiftOverlays.showBlockingWaitOverlay()
        let user = UserDAO.getUser(id: UserDefaultManager.getInstance().getCurrentUser())
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        
        let body = ["user_id": contact.user_id, "profile": contact.profile, "firstname": contact.firstname, "lastname": contact.lastname, "phone": contact.phone, "email": contact.email, "relationship": contact.relationship, "number": String(contact.number), "_method": "PUT"] as [String : Any]
        
        Alamofire.request(Global.baseURL + "contact/" + String(contact.id) + "?token=" + (user?.token)!, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            SwiftOverlays.removeAllBlockingOverlays()
            switch response.result {
            case .success(_):
                let result = Response(data: response.data!)
                if result.success == "true" {
                    let contactResult = ContactResult(data: response.data!)
                    let newContact  = Contact()
                    newContact.id = contactResult.id
                    newContact.user_id = Int(contactResult.user_id)!
                    newContact.profile = contactResult.profile
                    newContact.firstname = contactResult.firstname
                    newContact.lastname = contactResult.lastname
                    newContact.phone = contactResult.phone
                    newContact.email = contactResult.email
                    newContact.relationship = contactResult.relationship
                    newContact.sent = true
                    newContact.number = contact.number
                    
                    ContactDAO.updateContact(contact: newContact)
                    _ = self.navigationController?.popViewController(animated: true)
                    
                    if self.contactDelegate != nil {
                        self.contactDelegate.saveNewContactClicked()
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
