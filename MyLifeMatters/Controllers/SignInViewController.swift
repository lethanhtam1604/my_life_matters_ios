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

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var signInView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: PasswordTextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var createBtn: UIButton!
    
    let gradientView = GradientView()
    
    let emailBorder = UIView()
    let passwordBorder = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.tintColor = Global.colorSecond
        self.view.addTapToDismiss()
        signInView.layer.cornerRadius = 5
        signInView.layer.shadowColor = UIColor.black.cgColor
        signInView.layer.shadowOpacity = 0.5
        signInView.layer.shadowOffset = CGSize.zero
        signInView.layer.shadowRadius = 5
        
        emailField.placeholder = "Account or Email"
        emailField.delegate = self
        emailField.textColor = Global.colorSecond
        emailField.addSubview(emailBorder)
        emailField.returnKeyType = .next
        emailField.keyboardType = .emailAddress
        emailField.inputAccessoryView = UIView()
        emailField.autocorrectionType = .no
        emailField.autocapitalizationType = .none
        emailBorder.backgroundColor = Global.colorBg
        
        passwordField.placeholder = "Password"
        passwordField.delegate = self
        passwordField.textColor = Global.colorSecond
        passwordField.addSubview(passwordBorder)
        passwordField.returnKeyType = .go
        passwordField.keyboardType = .asciiCapable
        passwordField.inputAccessoryView = UIView()
        passwordField.autocorrectionType = .no
        passwordField.autocapitalizationType = .none
        passwordBorder.backgroundColor = Global.colorBg
        
        emailBorder.autoPinEdge(toSuperviewEdge: .left)
        emailBorder.autoPinEdge(toSuperviewEdge: .right)
        emailBorder.autoPinEdge(toSuperviewEdge: .bottom)
        emailBorder.autoSetDimension(.height, toSize: 1)
        
        passwordBorder.autoPinEdge(toSuperviewEdge: .left)
        passwordBorder.autoPinEdge(toSuperviewEdge: .right)
        passwordBorder.autoPinEdge(toSuperviewEdge: .bottom)
        passwordBorder.autoSetDimension(.height, toSize: 1)
        
        errorLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
        errorLabel.textAlignment = .center
        errorLabel.textColor = UIColor.red.withAlphaComponent(0.7)
        errorLabel.adjustsFontSizeToFitWidth = true
        
        signInBtn.setTitleColor(UIColor.white, for: .normal)
        signInBtn.setTitleColor(Global.colorSelected, for: .highlighted)
        signInBtn.insertSubview(gradientView, at: 0)
        signInBtn.layer.cornerRadius = 5
        signInBtn.clipsToBounds = true
        signInBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: (signInBtn.titleLabel?.font.pointSize)!)
        signInBtn.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        
        gradientView.autoPinEdge(toSuperviewEdge: .left)
        gradientView.autoPinEdge(toSuperviewEdge: .right)
        gradientView.autoPinEdge(toSuperviewEdge: .top)
        gradientView.autoSetDimension(.height, toSize: 40)
        
        let create = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        let  createValue = NSAttributedString(string: "Create", attributes: create)
        createBtn.setAttributedTitle(createValue, for: .normal)
        createBtn.setTitleColor(UIColor.white, for: .normal)
        createBtn.setTitleColor(Global.colorSelected, for: .highlighted)
        createBtn.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        createBtn.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func signIn() {
        if !checkInput(textField: emailField, value: emailField.text) {
            return
        }
        if !checkInput(textField: passwordField, value: passwordField.text) {
            return
        }
        
        view.endEditing(true)
        
        let email = emailField.text!
        let password = passwordField.text!
        
        SwiftOverlays.showBlockingWaitOverlay()
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let body = ["account_or_email": email, "password": password,]
        
        Alamofire.request(Global.baseURL + "api-login", method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
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
                    UserDefaultManager.getInstance().setCurrentUser(userID: (user.id))
                    let localUser  = UserDAO.getUser(id: user.id)
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    if user.setup == "no" {
                        let setupUserViewController = storyBoard.instantiateViewController(withIdentifier: "SetupUserViewController") as! SetupUserViewController
                        if localUser == nil {
                            setupUserViewController.loadDataFromServer = true
                            UserDAO.addUser(user: user)
                        }
                        let nav = UINavigationController(rootViewController: setupUserViewController)
                        self.present(nav, animated:true, completion:nil)
                    }
                    else {
                        let mainViewController = storyBoard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                        if localUser == nil {
                            mainViewController.loadDataFromServer = true
                            UserDAO.addUser(user: user)
                        }
                        let nav = UINavigationController(rootViewController: mainViewController)
                        self.present(nav, animated:true, completion:nil)
                    }
                }
                else {
                    self.errorLabel.text = result.msg
                }
            case .failure(_):
                self.errorLabel.text = response.result.error?.localizedDescription
            }
        }
    }
    
    func signUp() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let signUpViewController = storyBoard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.present(signUpViewController, animated:true, completion:nil)
    }
    
    
    // delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        _ = checkInput(textField: textField, value: newString)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                passwordField.becomeFirstResponder()
                return true
            }
            return false
        } else {
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                signIn()
                return true
            }
            return false
        }
    }
    
    func checkInput(textField: UITextField, value: String?) -> Bool {
        if textField == emailField {
            if value != nil && (value!.isValidAccount() || value!.isValidEmail()) {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorBg
                return true
            }
            
            errorLabel.text = "Invalid account/email"
            textField.subviews.first?.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            return false
            
        } else {
            if value != nil && value!.isValidPassword() {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorBg
                return true
            }
            
            errorLabel.text = "Invalid password"
            textField.subviews.first?.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            return false
        }
    }
    
    func keyboardWillShow() {
        
    }
    
    func keyboardWillHide() {
        
    }
}
