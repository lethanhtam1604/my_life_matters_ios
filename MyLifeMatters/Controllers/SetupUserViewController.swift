//
//  SetupUserViewController.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 11/26/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import FontAwesomeKit
import RealmSwift
import Alamofire

class SetupUserViewController: UIViewController, UITextFieldDelegate, LoadDataDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var userIconBtn: UIButton!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    
    @IBOutlet weak var accountField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var birthDateField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    let gradientView = GradientView()
    let calendarBtn = UIButton()
    var loadDataFromServer = false
    
    @IBOutlet weak var firstNameBorder: UIView!
    @IBOutlet weak var lastNameBorder: UIView!
    @IBOutlet weak var birthdayBorder: UIView!
    @IBOutlet weak var addressBorder: UIView!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userID = UserDefaultManager.getInstance().getCurrentUser()
        user = UserDAO.getUser(id: userID)!
        
        if TypeDAO.getAllTypes().count == 0 {
            var newType  = Type()
            newType.id = TypeDAO.getNextId()
            newType.name = "Audio"
            TypeDAO.addType(type: newType)
            
            newType  = Type()
            newType.id = TypeDAO.getNextId()
            newType.name = "Photo"
            TypeDAO.addType(type: newType)
            
            newType  = Type()
            newType.id = TypeDAO.getNextId()
            newType.name = "Video"
            TypeDAO.addType(type: newType)
        }
        
        if MultimediaDAO.getMultimediaByUserIdAndTypeId(userId: userID, typeID: 5).count == 0 {
            let newAudio = Multimedia()
            newAudio.id = MultimediaDAO.getNextId()
            newAudio.name = "alarm_belm.mp3"
            newAudio.type_id = 5
            newAudio.sent = true
            newAudio.user_id = userID
            newAudio.choose = true
            MultimediaDAO.addMultimedia(multimedia: newAudio)
        }
        
        //init navigation bar
        navigationController!.navigationBar.barTintColor = Global.colorMain
        navigationController!.navigationBar.tintColor = UIColor.white
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationItem.title = "Setup your Profile"
        
        self.view.backgroundColor = Global.colorHeader
        self.view.tintColor = Global.colorSecond
        self.view.addTapToDismiss()
        
        let iosArrowForwardIcon = FAKIonIcons.iosArrowForwardIcon(withSize: 25)
        iosArrowForwardIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let iosArrowForwardImg  = iosArrowForwardIcon?.image(with: CGSize(width: 25, height: 25))
        nextBtn.setImage(iosArrowForwardImg, for: .normal)
        nextBtn.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
        nextBtn.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        nextBtn.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
        nextBtn.autoSetDimension(.height, toSize: 45)
        
        nextBtn.tintColor = UIColor.white
        nextBtn.addTarget(self, action: #selector(nextBtnClicked), for: .touchUpInside)
        nextBtn.imageView?.contentMode = .scaleAspectFit
        nextBtn.insertSubview(gradientView, at: 0)
        
        gradientView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
        gradientView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        gradientView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
        gradientView.autoSetDimension(.height, toSize: 45)
        
        firstNameField.placeholder = "First name"
        firstNameField.delegate = self
        firstNameField.textColor = Global.colorSecond
        firstNameField.returnKeyType = .next
        firstNameField.keyboardType = .default
        firstNameField.inputAccessoryView = UIView()
        firstNameField.autocorrectionType = .no
        firstNameField.autocapitalizationType = .none
        firstNameField.text = user.firstname
        firstNameBorder.backgroundColor = Global.colorBg
        
        lastNameField.placeholder = "Last name"
        lastNameField.delegate = self
        lastNameField.textColor = Global.colorSecond
        lastNameField.returnKeyType = .next
        lastNameField.keyboardType = .default
        lastNameField.inputAccessoryView = UIView()
        lastNameField.autocorrectionType = .no
        lastNameField.autocapitalizationType = .none
        lastNameField.text = user.lastname
        lastNameBorder.backgroundColor = Global.colorBg
        
        accountField.placeholder = "Account"
        accountField.delegate = self
        accountField.textColor = Global.colorGray
        accountField.returnKeyType = .next
        accountField.keyboardType = .namePhonePad
        accountField.inputAccessoryView = UIView()
        accountField.autocorrectionType = .no
        accountField.autocapitalizationType = .none
        accountField.text = user.account
        accountField.isEnabled = false
        
        emailField.placeholder = "Email"
        emailField.delegate = self
        emailField.textColor = Global.colorGray
        emailField.returnKeyType = .next
        emailField.keyboardType = .emailAddress
        emailField.inputAccessoryView = UIView()
        emailField.autocorrectionType = .no
        emailField.autocapitalizationType = .none
        emailField.text = user.email
        emailField.isEnabled = false
        
        phoneField.placeholder = "Phone"
        phoneField.delegate = self
        phoneField.textColor = Global.colorGray
        phoneField.returnKeyType = .next
        phoneField.keyboardType = .phonePad
        phoneField.inputAccessoryView = UIView()
        phoneField.autocorrectionType = .no
        phoneField.autocapitalizationType = .none
        phoneField.text = user.phone
        phoneField.isEnabled = false
        
        birthDateField.placeholder = "Birth date"
        birthDateField.delegate = self
        birthDateField.textColor = Global.colorSecond
        birthDateField.returnKeyType = .next
        birthDateField.keyboardType = .default
        birthDateField.inputAccessoryView = UIView()
        birthDateField.autocorrectionType = .no
        birthDateField.autocapitalizationType = .none
        birthDateField.isEnabled = false
        birthDateField.text = user.birthday
        birthdayBorder.backgroundColor = Global.colorBg
        
        calendarView.addSubview(calendarBtn)
        calendarBtn.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
        calendarBtn.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        calendarBtn.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
        calendarBtn.autoSetDimension(.width, toSize: 45)
        
        let calendarIcon = FAKFontAwesome.calendarIcon(withSize: 30)
        calendarIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain)
        let calendarImg  = calendarIcon?.image(with: CGSize(width: 30, height: 30))
        calendarBtn.setImage(calendarImg, for: .normal)
        calendarBtn.tintColor = Global.colorMain
        calendarBtn.addTarget(self, action: #selector(calenderBtnClicked), for: .touchUpInside)
        calendarBtn.imageView?.contentMode = .scaleAspectFit
        
        addressField.placeholder = "Address"
        addressField.delegate = self
        addressField.textColor = Global.colorSecond
        addressField.returnKeyType = .done
        addressField.keyboardType = .default
        addressField.inputAccessoryView = UIView()
        addressField.autocorrectionType = .no
        addressField.autocapitalizationType = .none
        addressField.text = user.address
        addressBorder.backgroundColor = Global.colorBg
        
        errorLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
        errorLabel.textAlignment = .center
        errorLabel.textColor = UIColor.red.withAlphaComponent(0.7)
        errorLabel.adjustsFontSizeToFitWidth = true
        
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: 170 + 50 + 229)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if loadDataFromServer {
            _ = SwiftOverlays.showBlockingWaitOverlayWithText("Loading data...")
            DataManager.loadData(loadDataDelegate: self)
        }
        else {
            EmergencyManager.getInstance().emergencies = EmergencyDAO.getEmergenciesByUserID(userID: user.id)
            CivilManager.getInstance().civils = CivilDAO.getCivilsByUserID(userID: user.id)
            ContactManager.getInstance().contacts = ContactDAO.getContactsByUserID(userID: user.id)
            MultimediaManager.getInstance().audios = MultimediaDAO.getMultimediaByUserIdAndTypeId(userId: user.id, typeID: 5)
        }
        ContactManager.getInstance().sortByNumber()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    func finish(thread: Int) {
        if thread == 4 {
            SwiftOverlays.removeAllBlockingOverlays()
        }
    }
    
    var fromDate : NSDate? {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            if fromDate != nil {
                birthDateField.text = dateFormatter.string(from: fromDate! as Date)
            } else {
                birthDateField.text = user.birthday
            }
        }
    }
    
    func calenderBtnClicked(sender: UIButton) {
        var date = NSDate()
        if(fromDate != nil) {
            date = fromDate!
        }
        
        var datePickerViewController : UIViewController!
        datePickerViewController = AIDatePickerController.picker(with: date as Date!, selectedBlock: {
            newDate in
            self.fromDate = newDate as NSDate?
            datePickerViewController.dismiss(animated: true, completion: nil)
        }, cancel: {
            datePickerViewController.dismiss(animated: true, completion: nil)
        }) as! UIViewController
        
        present(datePickerViewController, animated: true, completion: nil)
    }
    
    func nextBtnClicked() {
        
        if !checkInput(textField: firstNameField, value: firstNameField.text) {
            return
        }
        if !checkInput(textField: lastNameField, value: lastNameField.text) {
            return
        }
        if !checkInput(textField: birthDateField, value: birthDateField.text) {
            return
        }
        if !checkInput(textField: addressField, value: addressField.text) {
            return
        }
        
        view.endEditing(true)
        
        if !Utils.isInternetAvailable() {
            Utils.showAlert(title: "Error", message: "Internet is not available. Please try again!", viewController: self)
            return
        }
        
        SwiftOverlays.showBlockingWaitOverlay()
        
        let newUser = User()
        newUser.id = user.id
        newUser.account = user.account
        newUser.phone = user.phone
        newUser.email = user.email
        newUser.password = user.password
        newUser.firstname = firstNameField.text!
        newUser.lastname = lastNameField.text!
        newUser.birthday = birthDateField.text!
        newUser.address = addressField.text!
        newUser.token = user.token
        newUser.bypass = user.bypass
        newUser.setup = user.setup
        newUser.transfer = user.transfer
        newUser.sent_profile = false
        
        
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let body = ["firstname": newUser.firstname, "lastname": newUser.lastname,  "birthday": newUser.birthday,  "address": newUser.address, "bypass": newUser.bypass, "setup": newUser.setup, "_method": "PUT"]
        
        Alamofire.request(Global.baseURL + "profile/" + String(user.id) + "?token=" + user.token, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(_):
                self.finish()
                let result = Response(data: response.data!)
                if result.success == "true" {
                    newUser.sent_profile = true
                    UserDAO.updateUser(user: newUser)
                }
                else {
                    
                }
            case .failure(_):
                self.finish()
                return
            }
        }
    }
    
    func finish() {
        SwiftOverlays.removeAllBlockingOverlays()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let setupCivilViewController = storyBoard.instantiateViewController(withIdentifier: "SetupCivilViewController") as! SetupCivilViewController
        let nav = UINavigationController(rootViewController: setupCivilViewController)
        self.present(nav, animated:true, completion:nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                lastNameField.becomeFirstResponder()
                return true
            }
        case lastNameField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                return true
            }
        case addressField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                return true
            }
        default:
            textField.resignFirstResponder()
            nextBtnClicked()
            return true
        }
        return false
    }
    
    // delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        _ = checkInput(textField: textField, value: newString)
        return true
    }
    
    func checkInput(textField: UITextField, value: String?) -> Bool {
        switch textField {
        case firstNameField:
            if value != nil && value!.isValidName() {
                errorLabel.text = nil
                firstNameBorder.backgroundColor = Global.colorBg
                return true
            }
            errorLabel.text = "Invalid first name"
            firstNameBorder.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            
        case lastNameField:
            if value != nil && value!.isValidName() {
                errorLabel.text = nil
                lastNameBorder.backgroundColor = Global.colorBg
                return true
            }
            errorLabel.text = "Invalid last name"
            lastNameBorder.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            
        case birthDateField:
            if value != nil && value!.isValidName() {
                errorLabel.text = nil
                birthdayBorder.backgroundColor = Global.colorBg
                return true
            }
            errorLabel.text = "Invalid birthday"
            birthdayBorder.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            
        default:
            if value != nil && value!.isValidName() {
                errorLabel.text = nil
                addressBorder.backgroundColor = Global.colorBg
                return true
            }
            errorLabel.text = "Invalid address"
            addressBorder.backgroundColor = UIColor.red.withAlphaComponent(0.8)
        }
        return false
    }
}
