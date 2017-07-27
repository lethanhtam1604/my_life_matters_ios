//
//  LoginViewController.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 11/24/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import PasswordTextField
import Alamofire

class SignUpViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var signUpView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var accountField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var passwordField: PasswordTextField!
    @IBOutlet weak var confirmPasswordField: PasswordTextField!
    @IBOutlet weak var createAccountBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    
    let accountBorder = UIView()
    let emailBorder = UIView()
    let phoneBorder = UIView()
    let passwordBorder = UIView()
    let confirmPasswordBorder = UIView()
    
    let gradientView = GradientView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.tintColor = Global.colorSecond
        self.view.addTapToDismiss()
        signUpView.layer.cornerRadius = 5
        signUpView.layer.cornerRadius = 5
        signUpView.layer.shadowColor = UIColor.black.cgColor
        signUpView.layer.shadowOpacity = 0.5
        signUpView.layer.shadowOffset = CGSize.zero
        signUpView.layer.shadowRadius = 5
        
        accountField.placeholder = "Account"
        accountField.delegate = self
        accountField.textColor = Global.colorSecond
        accountField.addSubview(accountBorder)
        accountField.returnKeyType = .next
        accountField.keyboardType = .emailAddress
        accountField.inputAccessoryView = UIView()
        accountField.autocorrectionType = .no
        accountField.autocapitalizationType = .none
        accountBorder.backgroundColor = Global.colorBg
        
        emailField.placeholder = "Email"
        emailField.delegate = self
        emailField.textColor = Global.colorSecond
        emailField.addSubview(emailBorder)
        emailField.returnKeyType = .next
        emailField.keyboardType = .emailAddress
        emailField.inputAccessoryView = UIView()
        emailField.autocorrectionType = .no
        emailField.autocapitalizationType = .none
        emailBorder.backgroundColor = Global.colorBg
        
        phoneField.placeholder = "Phone"
        phoneField.delegate = self
        phoneField.textColor = Global.colorSecond
        phoneField.addSubview(phoneBorder)
        phoneField.returnKeyType = .next
        phoneField.keyboardType = .phonePad
        phoneField.inputAccessoryView = UIView()
        phoneField.autocorrectionType = .no
        phoneField.autocapitalizationType = .none
        phoneBorder.backgroundColor = Global.colorBg
        
        passwordField.placeholder = "Password"
        passwordField.delegate = self
        passwordField.textColor = Global.colorSecond
        passwordField.addSubview(passwordBorder)
        passwordField.returnKeyType = .next
        passwordField.keyboardType = .asciiCapable
        passwordField.inputAccessoryView = UIView()
        passwordField.autocorrectionType = .no
        passwordField.autocapitalizationType = .none
        passwordBorder.backgroundColor = Global.colorBg
        
        confirmPasswordField.placeholder = "Confirm password"
        confirmPasswordField.delegate = self
        confirmPasswordField.textColor = Global.colorSecond
        confirmPasswordField.addSubview(confirmPasswordBorder)
        confirmPasswordField.returnKeyType = .go
        confirmPasswordField.keyboardType = .asciiCapable
        confirmPasswordField.inputAccessoryView = UIView()
        confirmPasswordField.autocorrectionType = .no
        confirmPasswordField.autocapitalizationType = .none
        confirmPasswordBorder.backgroundColor = Global.colorBg
        
        accountBorder.autoPinEdge(toSuperviewEdge: .left)
        accountBorder.autoPinEdge(toSuperviewEdge: .right)
        accountBorder.autoPinEdge(toSuperviewEdge: .bottom)
        accountBorder.autoSetDimension(.height, toSize: 1)
        
        emailBorder.autoPinEdge(toSuperviewEdge: .left)
        emailBorder.autoPinEdge(toSuperviewEdge: .right)
        emailBorder.autoPinEdge(toSuperviewEdge: .bottom)
        emailBorder.autoSetDimension(.height, toSize: 1)
        
        phoneBorder.autoPinEdge(toSuperviewEdge: .left)
        phoneBorder.autoPinEdge(toSuperviewEdge: .right)
        phoneBorder.autoPinEdge(toSuperviewEdge: .bottom)
        phoneBorder.autoSetDimension(.height, toSize: 1)
        
        passwordBorder.autoPinEdge(toSuperviewEdge: .left)
        passwordBorder.autoPinEdge(toSuperviewEdge: .right)
        passwordBorder.autoPinEdge(toSuperviewEdge: .bottom)
        passwordBorder.autoSetDimension(.height, toSize: 1)
        
        confirmPasswordBorder.autoPinEdge(toSuperviewEdge: .left)
        confirmPasswordBorder.autoPinEdge(toSuperviewEdge: .right)
        confirmPasswordBorder.autoPinEdge(toSuperviewEdge: .bottom)
        confirmPasswordBorder.autoSetDimension(.height, toSize: 1)
        
        errorLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
        errorLabel.textAlignment = .center
        errorLabel.textColor = UIColor.red.withAlphaComponent(0.7)
        errorLabel.adjustsFontSizeToFitWidth = true
        
        createAccountBtn.setTitleColor(UIColor.white, for: .normal)
        createAccountBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: (signInBtn.titleLabel?.font.pointSize)!)
        createAccountBtn.setTitleColor(Global.colorSelected, for: .highlighted)
        createAccountBtn.insertSubview(gradientView, at: 0)
        createAccountBtn.layer.cornerRadius = 5
        createAccountBtn.clipsToBounds = true
        createAccountBtn.addTarget(self, action: #selector(createAccount), for: .touchUpInside)
        
        gradientView.autoPinEdge(toSuperviewEdge: .left)
        gradientView.autoPinEdge(toSuperviewEdge: .right)
        gradientView.autoPinEdge(toSuperviewEdge: .top)
        gradientView.autoSetDimension(.height, toSize: 40)
        
        let signInUnder = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        let  signInValue = NSAttributedString(string: "Sign In", attributes: signInUnder)
        signInBtn.setAttributedTitle(signInValue, for: .normal)
        signInBtn.setTitleColor(UIColor.white, for: .normal)
        signInBtn.setTitleColor(Global.colorSelected, for: .highlighted)
        signInBtn.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        signInBtn.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func signIn() {
        dismiss(animated: true, completion: nil)
    }
    
    func createAccount() {
        if !checkInput(textField: accountField, value: accountField.text) {
            return
        }
        if !checkInput(textField: phoneField, value: phoneField.text) {
            return
        }
        if !checkInput(textField: emailField, value: emailField.text) {
            return
        }
        if !checkInput(textField: passwordField, value: passwordField.text) {
            return
        }
        if !checkInput(textField: confirmPasswordField, value: confirmPasswordField.text) {
            return
        }
        
        view.endEditing(true)
        
        let account = accountField.text!
        let phone = phoneField.text!
        let email = emailField.text!
        let password = passwordField.text!
        
        SwiftOverlays.showBlockingWaitOverlay()
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let body = ["account": account, "phone": phone,  "email": email,  "password": password]
        
        Alamofire.request(Global.baseURL + "api-signup", method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            SwiftOverlays.removeAllBlockingOverlays()
            switch response.result {
            case .success(_):
                let result = Response(data: response.data!)
                if result.success == "true" {
                    let userResult = UserResult(data: response.data!)
                    let user  = User()
                    user.id = userResult.id
                    user.account = userResult.account
                    user.phone = userResult.phone
                    user.email = userResult.email
                    user.password = password
                    user.token = userResult.token
                    user.birthday = userResult.birthday
                    user.firstname = userResult.firstname
                    user.lastname = userResult.lastname
                    user.address = userResult.address
                    user.bypass = userResult.bypass
                    user.setup = userResult.setup
                    user.transfer = userResult.transfer
                    UserDAO.addUser(user: user)
                    UserDefaultManager.getInstance().setCurrentUser(userID: user.id)
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let setupUserViewController = storyBoard.instantiateViewController(withIdentifier: "SetupUserViewController") as! SetupUserViewController
                    let nav = UINavigationController(rootViewController: setupUserViewController)
                    self.present(nav, animated:true, completion:nil)
                }
                else {
                    self.errorLabel.text = result.msg
                }
            case .failure(_):
                self.errorLabel.text = response.result.error?.localizedDescription
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
        case accountField:
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
                passwordField.becomeFirstResponder()
                return true
            }
        case passwordField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                confirmPasswordField.becomeFirstResponder()
                return true
            }
        default:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                createAccount()
                return true
            }
        }
        
        return false
    }
    
    func checkInput(textField: UITextField, value: String?) -> Bool {
        switch textField {
        case accountField:
            if value != nil && value!.isValidAccount() {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorBg
                return true
            }
            errorLabel.text = "Invalid account"
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
            
        case passwordField:
            if value != nil && value!.isValidPassword() {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorBg
                return true
            }
            errorLabel.text = "Invalid password"
            textField.subviews.first?.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            
        default:
            if value != nil && passwordField.text != nil && value! == passwordField.text! {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorBg
                return true
            }
            errorLabel.text = "Password mismatch"
            textField.subviews.first?.backgroundColor = UIColor.red.withAlphaComponent(0.8)
        }
        return false
    }
    
    func keyboardWillShow() {
        
    }
    
    func keyboardWillHide() {
        
    }
}
