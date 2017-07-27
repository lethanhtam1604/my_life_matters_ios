//
//  CivilViewController.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 11/29/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import FontAwesomeKit
import CNPPopupController
import MapKit
import Alamofire

class CivilViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate, CLLocationManagerDelegate, CNPPopupControllerDelegate, UIWebViewDelegate {
    
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var websiteField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var mapBtn: UIButton!
    @IBOutlet weak var websiteBtn: UIButton!
    
    let nameBorder = UIView()
    let phoneBorder = UIView()
    let emailBorder = UIView()
    let addressBorder = UIView()
    let websiteBorder = UIView()
    
    var civilDelegate: CivilDelegate!
    let gradientView = GradientView()
    
    var civil: Civil!
    var user: User!
    var mapPopup: CNPPopupController!
    let mapView = MKMapView()
    let locationManager = CLLocationManager()
    var anotation = MKPointAnnotation()
    var setup = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "New Civil"
        self.view.addTapToDismiss()
        
        let globeIcon = FAKFontAwesome.globeIcon(withSize: 100)
        globeIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain)
        let globeImg  = globeIcon?.image(with: CGSize(width: 100, height: 100))
        iconImgView.image = globeImg
        
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
        
        addressField.placeholder = "Address"
        addressField.delegate = self
        addressField.textColor = Global.colorSecond
        addressField.returnKeyType = .next
        addressField.keyboardType = .default
        addressField.inputAccessoryView = UIView()
        addressField.autocorrectionType = .no
        addressField.autocapitalizationType = .none
        addressField.addSubview(addressBorder)
        addressBorder.backgroundColor = Global.colorBg
        addressBorder.autoPinEdge(toSuperviewEdge: .left)
        addressBorder.autoPinEdge(toSuperviewEdge: .right)
        addressBorder.autoPinEdge(toSuperviewEdge: .bottom)
        addressBorder.autoSetDimension(.height, toSize: 1)
        
        websiteField.placeholder = "Website"
        websiteField.delegate = self
        websiteField.textColor = Global.colorSecond
        websiteField.returnKeyType = .go
        websiteField.keyboardType = .default
        websiteField.inputAccessoryView = UIView()
        websiteField.autocorrectionType = .no
        websiteField.autocapitalizationType = .none
        websiteField.addSubview(websiteBorder)
        websiteBorder.backgroundColor = Global.colorBg
        websiteBorder.autoPinEdge(toSuperviewEdge: .left)
        websiteBorder.autoPinEdge(toSuperviewEdge: .right)
        websiteBorder.autoPinEdge(toSuperviewEdge: .bottom)
        websiteBorder.autoSetDimension(.height, toSize: 1)
        
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
        
        let androidMapIcon = FAKIonIcons.androidMapIcon(withSize: 30)
        androidMapIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain)
        let androidMapImg  = androidMapIcon?.image(with: CGSize(width: 30, height: 30))
        mapBtn.setImage(androidMapImg, for: .normal)
        mapBtn.tintColor = Global.colorMain
        mapBtn.addTarget(self, action: #selector(mapBtnClicked), for: .touchUpInside)
        mapBtn.imageView?.contentMode = .scaleAspectFit
        
        let webIcon = FAKFoundationIcons.webIcon(withSize: 30)
        webIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain)
        let webImg  = webIcon?.image(with: CGSize(width: 30, height: 30))
        websiteBtn.setImage(webImg, for: .normal)
        websiteBtn.tintColor = Global.colorMain
        websiteBtn.addTarget(self, action: #selector(websiteBtnClicked), for: .touchUpInside)
        websiteBtn.imageView?.contentMode = .scaleAspectFit
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.addAnnotation(anotation)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if civil != nil {
            nameField.text = civil.name
            phoneField.text = civil.phone
            emailField.text = civil.email
            addressField.text = civil.address
            websiteField.text = civil.website
            self.title = "Update Civil"
            saveBtn.setTitle("UPDATE", for: .normal)
            
            if civil.sent && setup {
                self.title = ""
                saveBtn.isHidden = true
                nameField.isEnabled = false
                phoneField.isEnabled = false
                emailField.isEnabled = false
                addressField.isEnabled = false
                websiteField.isEnabled = false
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
        if !checkInput(textField: emailField, value: emailField.text) {
            return
        }
        if !checkInput(textField: addressField, value: addressField.text) {
            return
        }
        if !checkInput(textField: websiteField, value: websiteField.text) {
            return
        }
        
        view.endEditing(true)
        
        if !Utils.isInternetAvailable() {
            Utils.showAlert(title: "Error", message: "Internet is not available. Please try again!", viewController: self)
            return
        }
        
        let name = nameField.text!
        let phone = phoneField.text!
        let email = emailField.text!
        let address = addressField.text!
        let website = websiteField.text!
        let userID = UserDefaultManager.getInstance().getCurrentUser()
        
        let newCivil = Civil()
        newCivil.user_id = userID
        newCivil.name = name
        newCivil.phone = phone
        newCivil.email = email
        newCivil.address = address
        newCivil.website = website
        newCivil.sent = false
        
        if setup {
            if civil == nil {
                newCivil.id = CivilDAO.getNextId()
                CivilDAO.addCivil(civil: newCivil)
                CivilManager.getInstance().civils.append(newCivil)
            }
            else {
                newCivil.id = civil.id
                CivilDAO.updateCivil(civil: newCivil)
            }
            
            if self.civilDelegate != nil {
                self.civilDelegate.saveNewCivilClicked()
            }
            _ = self.navigationController?.popViewController(animated: true)
        }
        else {
            if civil == nil {
                uploadNewCivil(civil: newCivil)
            }
            else {
                newCivil.id = civil.id
                updateCivil(civil: newCivil)
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
        case phoneField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                emailField.becomeFirstResponder()
                return true
            }
        case emailField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                addressField.becomeFirstResponder()
                return true
            }
        case addressField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                websiteField.becomeFirstResponder()
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
            
        case addressField:
            if value != nil && value!.isValidName() {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorBg
                return true
            }
            errorLabel.text = "Invalid address"
            textField.subviews.first?.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            
        default:
            if value != nil && value!.isValidUrl() {
                errorLabel.text = nil
                textField.subviews.first?.backgroundColor = Global.colorBg
                return true
            }
            errorLabel.text = "Invalid website"
            textField.subviews.first?.backgroundColor = UIColor.red.withAlphaComponent(0.8)
        }
        return false
    }
    
    func mapBtnClicked() {
        
        nameField.resignFirstResponder()
        phoneField.resignFirstResponder()
        emailField.resignFirstResponder()
        addressField.resignFirstResponder()
        websiteField.resignFirstResponder()
        
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeLocation)))
        mapView.backgroundColor = Global.colorBg
        mapView.frame = CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH - 70, height: ScreenSize.SCREEN_HEIGHT - 250)
        mapView.layer.cornerRadius = 5
        
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH - 70, height: ScreenSize.SCREEN_HEIGHT - 250))
        customView.addSubview(mapView)
        
        let closeBtn = UIButton(frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH - 70, height: 40))
        closeBtn.setTitleColor(UIColor.white, for: .normal)
        closeBtn.setTitleColor(Global.colorSelected, for: .highlighted)
        closeBtn.layer.cornerRadius = 5
        closeBtn.backgroundColor = Global.colorMain
        closeBtn.clipsToBounds = true
        closeBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: (closeBtn.titleLabel?.font.pointSize)!)
        closeBtn.addTarget(self, action: #selector(pickMap), for: .touchUpInside)
        closeBtn.setTitle("Pick", for: .normal)
        let closeGradientView = GradientView(frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH - 70, height: 40))
        closeBtn.insertSubview(closeGradientView, at: 0)
        
        mapPopup = CNPPopupController(contents: [customView, closeBtn])
        mapPopup.delegate = self
        mapPopup.theme.popupStyle = .centered
        mapPopup.theme = .default()
        mapPopup.theme.backgroundColor = Global.colorBg
        mapPopup.present(animated: true)
    }
    
    // map
    var customLocation = false
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if !customLocation {
            var mapRegion = MKCoordinateRegion()
            anotation.coordinate = mapView.userLocation.coordinate
            mapRegion.center = mapView.userLocation.coordinate
            mapRegion.span.latitudeDelta = 0.002
            mapRegion.span.longitudeDelta = 0.002
            mapView.setRegion(mapRegion, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedAlways && status != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.startUpdatingLocation()
        }
    }
    
    func changeLocation(gestureRecognizer: UIGestureRecognizer) {
        customLocation = true
        let touchPoint = gestureRecognizer.location(in: mapView)
        let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        anotation.coordinate = touchMapCoordinate
    }
    
    var linkLabel: UILabel!
    var webView: UIWebView!
    func websiteBtnClicked() {
        nameField.resignFirstResponder()
        phoneField.resignFirstResponder()
        emailField.resignFirstResponder()
        addressField.resignFirstResponder()
        websiteField.resignFirstResponder()
        
        webView = UIWebView(frame: CGRect(x:
            0, y: 40, width: ScreenSize.SCREEN_WIDTH - 70, height: ScreenSize.SCREEN_HEIGHT - 250))
        webView.delegate = self
        let url = URL(string: "https://google.com")!
        webView.loadRequest(URLRequest(url: url))
        
        let androidCloseIcon = FAKIonIcons.androidCloseIcon(withSize: 30)
        androidCloseIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let androidCloseImg  = androidCloseIcon?.image(with: CGSize(width: 40, height: 40))
        let closeBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        closeBtn.setImage(androidCloseImg, for: .normal)
        closeBtn.tintColor = UIColor.white
        closeBtn.addTarget(self, action: #selector(closeWebView), for: .touchUpInside)
        closeBtn.imageView?.contentMode = .scaleAspectFit
        
        linkLabel = UILabel(frame: CGRect(x: 45, y: 0, width: ScreenSize.SCREEN_WIDTH - 115, height: 40))
        linkLabel.textColor = UIColor.white
        linkLabel.textAlignment = .left
        linkLabel.text = "https://google.com"
        
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH - 70, height: 40))
        topView.backgroundColor = Global.colorMain
        
        topView.addSubview(closeBtn)
        topView.addSubview(linkLabel)
        
        let customView = UIView(frame: CGRect(x: 0, y: 40, width: ScreenSize.SCREEN_WIDTH - 70, height: ScreenSize.SCREEN_HEIGHT - 210))
        
        customView.addSubview(webView)
        customView.addSubview(topView)
        
        let getLinkBtn = UIButton(frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH - 70, height: 40))
        getLinkBtn.setTitleColor(UIColor.white, for: .normal)
        getLinkBtn.setTitleColor(Global.colorSelected, for: .highlighted)
        getLinkBtn.layer.cornerRadius = 5
        getLinkBtn.backgroundColor = Global.colorMain
        getLinkBtn.clipsToBounds = true
        getLinkBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: (getLinkBtn.titleLabel?.font.pointSize)!)
        getLinkBtn.addTarget(self, action: #selector(getLink), for: .touchUpInside)
        getLinkBtn.setTitle("Get", for: .normal)
        let closeGradientView = GradientView(frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH - 70, height: 40))
        getLinkBtn.insertSubview(closeGradientView, at: 0)
        
        mapPopup = CNPPopupController(contents: [customView, getLinkBtn])
        mapPopup.delegate = self
        mapPopup.theme.popupStyle = .centered
        mapPopup.theme = .default()
        mapPopup.theme.backgroundColor = Global.colorBg
        mapPopup.present(animated: true)
    }
    
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        linkLabel.text = webView.request?.url?.absoluteString
    }
    
    func getLink() {
        websiteField.text = webView.request?.url?.absoluteString
        print(websiteField.text!)
        mapPopup.dismiss(animated: true)
    }
    
    func closeWebView () {
        mapPopup.dismiss(animated: true)
    }
    
    func pickMap() {
        let loc = CLLocation(latitude: anotation.coordinate.latitude, longitude: anotation.coordinate.longitude)
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(loc, completionHandler: { (placemarks, error) -> Void in
            if let placeMark = placemarks?[0] {
                self.addressField.text = "Unknown"
                if let address = placeMark.addressDictionary {
                    if let locationName = address["Name"] as? String {
                        self.addressField.text = locationName
                    }
                }
            }
        })
        mapPopup.dismiss(animated: true)
    }
    
    func popupControllerDidDismiss(_ controller: CNPPopupController) {
        
    }
    
    func uploadNewCivil(civil: Civil) {
        SwiftOverlays.showBlockingWaitOverlay()
        let user = UserDAO.getUser(id: UserDefaultManager.getInstance().getCurrentUser())
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        
        let body = ["user_id": civil.user_id, "name": civil.name, "phone": civil.phone,  "email": civil.email,  "address": civil.address, "website": civil.website] as [String : Any]
        
        Alamofire.request(Global.baseURL + "civil?token=" + (user?.token)!, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            SwiftOverlays.removeAllBlockingOverlays()
            switch response.result {
            case .success(_):
                let result = Response(data: response.data!)
                if result.success == "true" {
                    let newCivilResult = CivilResult(data: response.data!)
                    let newCivil = Civil()
                    newCivil.id = newCivilResult.id
                    newCivil.user_id = Int(newCivilResult.user_id)!
                    newCivil.name = newCivilResult.name
                    newCivil.phone = newCivilResult.phone
                    newCivil.email = newCivilResult.email
                    newCivil.address = newCivilResult.address
                    newCivil.website = newCivilResult.website
                    newCivil.sent = true
                    CivilDAO.addCivil(civil: newCivil)
                    CivilManager.getInstance().civils.append(newCivil)
                    _ = self.navigationController?.popViewController(animated: true)
                    
                    if self.civilDelegate != nil {
                        self.civilDelegate.saveNewCivilClicked()
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
    
    func updateCivil(civil: Civil) {
        SwiftOverlays.showBlockingWaitOverlay()
        let user = UserDAO.getUser(id: UserDefaultManager.getInstance().getCurrentUser())
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        
        let body = ["user_id": civil.user_id, "name": civil.name, "phone": civil.phone,  "email": civil.email,  "address": civil.address, "website": civil.website, "_method": "PUT"] as [String : Any]
        
        Alamofire.request(Global.baseURL + "civil/" + String(civil.id) + "?token=" + (user?.token)!, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            SwiftOverlays.removeAllBlockingOverlays()
            switch response.result {
            case .success(_):
                let result = Response(data: response.data!)
                if result.success == "true" {
                    let newCivilResult = CivilResult(data: response.data!)
                    let newCivil = Civil()
                    newCivil.id = newCivilResult.id
                    newCivil.user_id = Int(newCivilResult.user_id)!
                    newCivil.name = newCivilResult.name
                    newCivil.phone = newCivilResult.phone
                    newCivil.email = newCivilResult.email
                    newCivil.address = newCivilResult.address
                    newCivil.website = newCivilResult.website
                    newCivil.sent = true
                    CivilDAO.updateCivil(civil: newCivil)
                    _ = self.navigationController?.popViewController(animated: true)
                    
                    if self.civilDelegate != nil {
                        self.civilDelegate.saveNewCivilClicked()
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
