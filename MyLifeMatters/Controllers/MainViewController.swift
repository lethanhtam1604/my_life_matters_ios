//
//  MainViewController.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 11/17/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import FontAwesomeKit
import AVFoundation
import MapKit
import MessageUI
import Alamofire

class MainViewController: UIViewController, AVAudioPlayerDelegate, AlarmDelegate, CLLocationManagerDelegate, MFMessageComposeViewControllerDelegate {
    
    var constraintsAdded = false
    
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var messageBtn: UIButton!
    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var sosBtn: UIButton!
    @IBOutlet weak var numberBtn: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var audioBtn: UIButton!
    @IBOutlet weak var settingBtn: UIButton!
    
    var user: User!
    var loadDataFromServer = false
    let locationManager = CLLocationManager()
    
    var audioPlayer: AVAudioPlayer!
    var locationCurrentValue: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userID = UserDefaultManager.getInstance().getCurrentUser()
        user = UserDAO.getUser(id: userID)!
        
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
        
        if loadDataFromServer {
            DataManager.loadData(loadDataDelegate: nil)
        }
        else {
            EmergencyManager.getInstance().emergencies = EmergencyDAO.getEmergenciesByUserID(userID: userID)
            CivilManager.getInstance().civils = CivilDAO.getCivilsByUserID(userID: userID)
            ContactManager.getInstance().contacts = ContactDAO.getContactsByUserID(userID: userID)
            MessageManager.getInstance().messages = MessageDAO.getMessagesByUserID(userID: userID)
            MultimediaManager.getInstance().audios = MultimediaDAO.getMultimediaByUserIdAndTypeId(userId: userID, typeID: 5)
            for item in MultimediaDAO.getAllMultimedias() {
                if item.name == "alarm_belm.mp3" {
                    continue
                }
                MultimediaManager.getInstance().allMultimedia.append(item)
            }
        }
        ContactManager.getInstance().sortByNumber()
        
        //init navigation bar
        navigationController!.navigationBar.barTintColor = Global.colorMain
        navigationController!.navigationBar.tintColor = UIColor.white
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        self.navigationItem.title = "Because Every Life has Meaning"
        
        let callIcon = FAKFontAwesome.phoneIcon(withSize: 35)
        callIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let callImg  = callIcon?.image(with: CGSize(width: 80, height: 80))
        callBtn.setImage(callImg, for: .normal)
        callBtn.tintColor = UIColor.white
        callBtn.addTarget(self, action: #selector(callBtnClicked), for: .touchUpInside)
        callBtn.imageView?.contentMode = .scaleAspectFit
        callBtn.backgroundColor = Global.colorMain
        callBtn.layer.cornerRadius = 40
        
        let recordIcon = FAKFontAwesome.videoCameraIcon(withSize: 30)
        recordIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let recordImg  = recordIcon?.image(with: CGSize(width: 80, height: 80))
        recordBtn.setImage(recordImg, for: .normal)
        recordBtn.tintColor = UIColor.white
        recordBtn.addTarget(self, action: #selector(recordVideoBtnClicked), for: .touchUpInside)
        recordBtn.imageView?.contentMode = .scaleAspectFit
        recordBtn.backgroundColor = Global.colorMain
        recordBtn.layer.cornerRadius = 40
        
        let messageIcon = FAKFontAwesome.commentsIcon(withSize: 30)
        messageIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let messageImg  = messageIcon?.image(with: CGSize(width: 80, height: 80))
        messageBtn.setImage(messageImg, for: .normal)
        messageBtn.tintColor = UIColor.white
        messageBtn.addTarget(self, action: #selector(messageBtnClicked), for: .touchUpInside)
        messageBtn.imageView?.contentMode = .scaleAspectFit
        messageBtn.backgroundColor = Global.colorMain
        messageBtn.layer.cornerRadius = 40
        
        let allIcon = FAKFontAwesome.heartIcon(withSize: 40)
        allIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let allImg  = allIcon?.image(with: CGSize(width: 80, height: 80))
        allBtn.setImage(allImg, for: .normal)
        allBtn.tintColor = UIColor.white
        allBtn.addTarget(self, action: #selector(helpBtnClicked), for: .touchUpInside)
        allBtn.imageView?.contentMode = .scaleAspectFit
        allBtn.backgroundColor = Global.colorMain
        allBtn.layer.cornerRadius = 40
        
        let sosIcon = FAKFontAwesome.lifeRingIcon(withSize: 40)
        sosIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let sosImg  = sosIcon?.image(with: CGSize(width: 80, height: 80))
        sosBtn.setImage(sosImg, for: .normal)
        sosBtn.tintColor = UIColor.white
        sosBtn.addTarget(self, action: #selector(sosBtnClicked), for: .touchUpInside)
        sosBtn.imageView?.contentMode = .scaleAspectFit
        sosBtn.backgroundColor = UIColor.red
        sosBtn.layer.cornerRadius = 40
        
        let numberIcon = FAKFontAwesome.ttyIcon(withSize: 35)
        numberIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let numberImg  = numberIcon?.image(with: CGSize(width: 80, height: 80))
        numberBtn.setImage(numberImg, for: .normal)
        numberBtn.tintColor = UIColor.white
        numberBtn.addTarget(self, action: #selector(emergencyBtnClicked), for: .touchUpInside)
        numberBtn.imageView?.contentMode = .scaleAspectFit
        numberBtn.backgroundColor = Global.colorMain
        numberBtn.layer.cornerRadius = 40
        
        let cameracon = FAKFontAwesome.cameraIcon(withSize: 40)
        cameracon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let cameraImg  = cameracon?.image(with: CGSize(width: 80, height: 80))
        cameraBtn.setImage(cameraImg, for: .normal)
        cameraBtn.tintColor = UIColor.white
        cameraBtn.addTarget(self, action: #selector(cameraBtnClicked), for: .touchUpInside)
        cameraBtn.imageView?.contentMode = .scaleAspectFit
        cameraBtn.backgroundColor = Global.colorMain
        cameraBtn.layer.cornerRadius = 40
        
        let audioIcon = FAKIonIcons.iosBellIcon(withSize: 40)
        audioIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let audioImg  = audioIcon?.image(with: CGSize(width: 80, height: 80))
        audioBtn.setImage(audioImg, for: .normal)
        audioBtn.tintColor = UIColor.white
        audioBtn.addTarget(self, action: #selector(recordAudioBtnClicked), for: .touchUpInside)
        audioBtn.imageView?.contentMode = .scaleAspectFit
        audioBtn.backgroundColor = Global.colorMain
        audioBtn.layer.cornerRadius = 40
        
        let settingIcon = FAKFontAwesome.cogsIcon(withSize: 40)
        settingIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let settingImg  = settingIcon?.image(with: CGSize(width: 80, height: 80))
        settingBtn.setImage(settingImg, for: .normal)
        settingBtn.tintColor = UIColor.white
        settingBtn.addTarget(self, action: #selector(settingBtnClicked), for: .touchUpInside)
        settingBtn.imageView?.contentMode = .scaleAspectFit
        settingBtn.backgroundColor = Global.colorMain
        settingBtn.layer.cornerRadius = 40
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func callBtnClicked() {
        if ContactManager.getInstance().contacts.count == 0 {
            Utils.showAlert(title: "BELM", message: "Loading data from server. Please try again!", viewController: self)
            return
        }
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let callViewController = storyBoard.instantiateViewController(withIdentifier: "CallViewController") as! CallViewController
        let nav = UINavigationController(rootViewController: callViewController)
        self.present(nav, animated:true, completion:nil)
    }
    
    func recordVideoBtnClicked() {
        let cameraViewController = CameraViewController()
        cameraViewController.type = 2
        self.present(cameraViewController, animated: false, completion: nil)
    }
    
    func messageBtnClicked() {
        if ContactManager.getInstance().contacts.count == 0 {
            Utils.showAlert(title: "BELM", message: "Loading data from server. Please try again!", viewController: self)
            return
        }
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let messageViewController = storyBoard.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
        let nav = UINavigationController(rootViewController: messageViewController)
        self.present(nav, animated:true, completion:nil)
    }
    
    var oldIndexAudio = 0
    
    func helpBtnClicked() {
        do {
            if oldIndexAudio != UserDefaultManager.getInstance().getIndexAudioList() {
                oldIndexAudio = UserDefaultManager.getInstance().getIndexAudioList()
                audioPlayer = nil
            }
            if audioPlayer != nil && audioPlayer.isPlaying {
                audioPlayer.pause()
            }
            else if audioPlayer != nil {
                audioPlayer!.play()
            }
            else {
                var fileUrl: NSURL!
                for index in (0..<MultimediaManager.getInstance().audios.count) {
                    if index == UserDefaultManager.getInstance().getIndexAudioList() {
                        let audio = MultimediaManager.getInstance().audios[index]
                        if audio.name == "alarm_belm.mp3" {
                            fileUrl = Bundle.main.url(forResource: "alarm_belm.mp3", withExtension: nil) as NSURL!
                        }
                        else {
                            fileUrl = Utils.getDocumentsDirectory().appendingPathComponent(audio.name) as NSURL!
                        }
                        break
                    }
                }
                
                try audioPlayer = AVAudioPlayer(contentsOf: fileUrl as URL)
                audioPlayer!.delegate = self
                audioPlayer!.prepareToPlay()
                audioPlayer!.play()
            }
            
        } catch let error as NSError {
            Utils.showAlert(title: "Error", message: "audioPlayer error: \(error.localizedDescription)", viewController: self)
        }
    }
    
    func sosBtnClicked() {
        if ContactManager.getInstance().contacts.count == 0 {
            Utils.showAlert(title: "BELM", message: "Loading data from server... Please try again!", viewController: self)
            return
        }
        
        if locationCurrentValue == nil {
            Utils.showAlert(title: "Error", message: "Locating your currrent position. Please try again!", viewController: self)
            return
        }
        
        _ = SwiftOverlays.showBlockingWaitOverlayWithText("SOS sending...")
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let body = ["user_id": user.id, "gps": "http://maps.google.com/?q=" + String(locationCurrentValue.latitude) + "," + String(locationCurrentValue.longitude)] as [String : Any]
        
        Alamofire.request(Global.baseURL + "sos?token=" + user.token, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(_):
                SwiftOverlays.removeAllBlockingOverlays()
                if response.data?.count == 0 {
                    Utils.showAlert(title: "Error", message: "Could not send sos. Please try again!", viewController: self)
                    return
                }
                let result = Response(data: response.data!)
                if result.success == "true" {
                    Utils.showAlert(title: "Congratulation", message: "You sent sos successfully!", viewController: self)
                    
                    if (MFMessageComposeViewController.canSendText()) {
                        let controller = MFMessageComposeViewController()
                        controller.body = "SOS, HELP! GPS link: http://maps.google.com/?q=" + String(self.locationCurrentValue.latitude) + "," + String(self.locationCurrentValue.longitude)
                        var recipients = [String]()
                        for contact in ContactManager.getInstance().contacts {
                            recipients.append(contact.phone)
                        }
                        controller.recipients = recipients
                        controller.messageComposeDelegate = self
                        self.present(controller, animated: true, completion: nil)
//                        SwiftOverlays.removeAllBlockingOverlays()
                    }
                }
                else {
                    Utils.showAlert(title: "Error", message: "Could not send sos. Please try again!", viewController: self)
                }
            case .failure(_):
                SwiftOverlays.removeAllBlockingOverlays()
                Utils.showAlert(title: "Error", message: "Could not send sos. Please try again!", viewController: self)
            }
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func emergencyBtnClicked() {
        if EmergencyManager.getInstance().emergencies.count == 0 {
            Utils.showAlert(title: "BELM", message: "Loading data from server. Please try again!", viewController: self)
            return
        }
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let emergencyMainViewController = storyBoard.instantiateViewController(withIdentifier: "EmergencyMainViewController") as! EmergencyMainViewController
        let nav = UINavigationController(rootViewController: emergencyMainViewController)
        self.present(nav, animated:true, completion:nil)
    }
    
    func cameraBtnClicked() {
        let cameraViewController = CameraViewController()
        self.present(cameraViewController, animated: false, completion: nil)
    }
    
    func recordAudioBtnClicked() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let recordAlarmViewController = storyBoard.instantiateViewController(withIdentifier: "RecordAlarmViewController") as! RecordAlarmViewController
        recordAlarmViewController.alarmDelegate = self
        self.navigationController?.pushViewController(recordAlarmViewController, animated: true)
    }
    
    func saveNewAlarmClicked(audio: Multimedia) {
        _ = SwiftOverlays.showBlockingWaitOverlayWithText("Uploading...")
        let user = UserDAO.getUser(id: UserDefaultManager.getInstance().getCurrentUser())
        let path = Utils.getDocumentsDirectory().appendingPathComponent(audio.name).relativePath
        let user_id = audio.user_id
        let type_id = audio.type_id
        let name = audio.name
        let audioData = try! NSData(contentsOfFile: path, options: NSData.ReadingOptions.alwaysMapped)

        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(audioData as Data, withName: "path", fileName: name, mimeType: "audio/caf")
                multipartFormData.append(String(user_id).data(using: .utf8)!, withName: "user_id")
                multipartFormData.append(String(type_id).data(using: .utf8)!, withName: "type_id")
                multipartFormData.append(name.components(separatedBy: ".")[0].data(using: .utf8)!, withName: "name")
                
        },to: Global.baseURL + "multimedia?token=" + (user?.token)!,
          encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    SwiftOverlays.removeAllBlockingOverlays()
                    if response.data?.count == 0 {
                        Utils.showAlert(title: "Error", message: "Could not upload audio. Please try again!", viewController: self)
                        return
                    }
                    let result = Response(data: response.data!)
                    if result.success == "true" {
                        let multimediaResult = MultimediaResult(data: response.data!)
                        let newAudio = Multimedia()
                        newAudio.name = audio.name
                        newAudio.user_id = audio.user_id
                        newAudio.type_id = audio.type_id
                        newAudio.id = multimediaResult.id
                        newAudio.sent = true
                        newAudio.path = multimediaResult.path
                        MultimediaManager.getInstance().allMultimedia.append(newAudio)
                        MultimediaManager.getInstance().audios.append(newAudio)
                        MultimediaDAO.addMultimedia(multimedia: newAudio)
                        SwiftOverlays.removeAllBlockingOverlays()
                        Utils.showAlert(title: "Congratulation", message: "You uploaded a media file successfully!", viewController: self)
                    }
                    else {
                        Utils.showAlert(title: "Error", message: "Could not upload audio. Please try again!", viewController: self)
                    }
                }
            case .failure(_):
                SwiftOverlays.removeAllBlockingOverlays()
                Utils.showAlert(title: "Error", message: "Could not upload audio. Please try again!", viewController: self)
            }
        })
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        audioPlayer = nil
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        audioPlayer = nil
        Utils.showAlert(title: "Error", message: "Play audio error!", viewController: self)
    }
    
    func settingBtnClicked() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let settingViewController = storyBoard.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        let nav = UINavigationController(rootViewController: settingViewController)
        self.present(nav, animated:true, completion:nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedAlways && status != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.startUpdatingLocation()
        }
        
        locationCurrentValue = manager.location?.coordinate
    }
}
