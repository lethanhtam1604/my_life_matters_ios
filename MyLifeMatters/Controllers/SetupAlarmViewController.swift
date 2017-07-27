//
//  SetupAlarmViewController.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 11/26/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import FontAwesomeKit
import AVFoundation
import Alamofire
import MediaPlayer

class SetupAlarmViewController: UIViewController, AlarmDelegate, AVAudioPlayerDelegate, MPMediaPickerControllerDelegate {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var paperclipBtn: UIButton!
    @IBOutlet weak var microphoneBtn: UIButton!
    @IBOutlet weak var audioView: UIView!
    @IBOutlet weak var audioBtn: UIButton!
    @IBOutlet weak var audioNameLabel: UILabel!
    
    let gradientView = GradientView()
    
    var audioPlayer: AVAudioPlayer!
    var isPlayAudio = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.edgesForExtendedLayout = UIRectEdge.bottom
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init navigation bar
        navigationController!.navigationBar.barTintColor = Global.colorMain
        navigationController!.navigationBar.tintColor = UIColor.white
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        self.navigationItem.title = "Setup your Profile"
        
        let iosArrowBackIcon = FAKIonIcons.iosArrowBackIcon(withSize: 25)
        iosArrowBackIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let iosArrowBackImg  = iosArrowBackIcon?.image(with: CGSize(width: 25, height: 25))
        backBtn.setImage(iosArrowBackImg, for: .normal)
        backBtn.tintColor = UIColor.white
        backBtn.addTarget(self, action: #selector(backBtnClicked), for: .touchUpInside)
        backBtn.imageView?.contentMode = .scaleAspectFit
        
        let iosArrowForwardIcon = FAKIonIcons.iosArrowForwardIcon(withSize: 25)
        iosArrowForwardIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let iosArrowForwardImg  = iosArrowForwardIcon?.image(with: CGSize(width: 25, height: 25))
        nextBtn.setImage(iosArrowForwardImg, for: .normal)
        nextBtn.tintColor = UIColor.white
        nextBtn.addTarget(self, action: #selector(nextBtnClicked), for: .touchUpInside)
        nextBtn.imageView?.contentMode = .scaleAspectFit
        nextBtn.insertSubview(gradientView, at: 0)
        
        gradientView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
        gradientView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        gradientView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
        gradientView.autoSetDimension(.height, toSize: 45)
        
        let paperclipIcon = FAKFontAwesome.paperclipIcon(withSize: 25)
        paperclipIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain)
        let paperclipImg  = paperclipIcon?.image(with: CGSize(width: 25, height: 25))
        paperclipBtn.setImage(paperclipImg, for: .normal)
        paperclipBtn.tintColor = Global.colorMain
        paperclipBtn.addTarget(self, action: #selector(paperclipBtnClicked), for: .touchUpInside)
        paperclipBtn.imageView?.contentMode = .scaleAspectFit
        
        let microphoneIcon = FAKFontAwesome.microphoneIcon(withSize: 25)
        microphoneIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain)
        let microphoneImg  = microphoneIcon?.image(with: CGSize(width: 25, height: 25))
        microphoneBtn.setImage(microphoneImg, for: .normal)
        microphoneBtn.tintColor = Global.colorMain
        microphoneBtn.addTarget(self, action: #selector(microphoneBtnClicked), for: .touchUpInside)
        microphoneBtn.imageView?.contentMode = .scaleAspectFit
        
        let playIcon = FAKFontAwesome.playIcon(withSize: 15)
        playIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain)
        let playImg  = playIcon?.image(with: CGSize(width: 15, height: 15))
        audioBtn.setImage(playImg, for: .normal)
        audioBtn.tintColor = Global.colorMain
        audioBtn.backgroundColor = UIColor.white
        audioBtn.layer.cornerRadius = 20
        audioBtn.layer.borderColor = Global.colorMain.cgColor
        audioBtn.layer.borderWidth = 1
        audioBtn.addTarget(self, action: #selector(audioBtnClicked), for: .touchUpInside)
        audioBtn.imageView?.contentMode = .scaleAspectFit
        
        if MultimediaManager.getInstance().audios.count == 1 {
            audioNameLabel.text = MultimediaManager.getInstance().audios[0].name
        }
        else {
            audioNameLabel.text = MultimediaManager.getInstance().audios[1].name
        }
    }
    
    func backBtnClicked() {
        stop()
        audioPlayer = nil
        dismiss(animated: true, completion: nil)
    }
    
    func nextBtnClicked() {
        stop()
        audioPlayer = nil
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let setupSettingViewController = storyBoard.instantiateViewController(withIdentifier: "SetupSettingViewController") as! SetupSettingViewController
        let nav = UINavigationController(rootViewController: setupSettingViewController)
        self.present(nav, animated:true, completion:nil)
    }
    
    func microphoneBtnClicked() {
        stop()
        audioPlayer = nil
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let recordAlarmViewController = storyBoard.instantiateViewController(withIdentifier: "RecordAlarmViewController") as! RecordAlarmViewController
        recordAlarmViewController.alarmDelegate = self
        self.navigationController?.pushViewController(recordAlarmViewController, animated: true)
    }
    
    func paperclipBtnClicked() {
        stop()
        audioPlayer = nil
        
        let mediaPicker = MPMediaPickerController()
        mediaPicker.delegate = self
        mediaPicker.allowsPickingMultipleItems = true
        
        self.present(mediaPicker, animated: true, completion: nil)
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {

        print(mediaItemCollection)
        print(mediaItemCollection.value(forKeyPath: MPMediaItemPropertyAssetURL)!)
        self.dismiss(animated: true, completion: nil)
    }
    
    func audioBtnClicked() {
        if isPlayAudio {
            stop()
        }
        else {
            play()
            do {
                if audioPlayer != nil {
                    audioPlayer!.play()
                }
                else {
                    var fileUrl: NSURL!
                    if MultimediaManager.getInstance().audios.count == 1 {
                        fileUrl = Bundle.main.url(forResource: "alarm_belm.mp3", withExtension: nil) as NSURL!
                    }
                    else {
                        let audio = MultimediaManager.getInstance().audios[1]
                        fileUrl = Utils.getDocumentsDirectory().appendingPathComponent(audio.name) as NSURL!
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
    }
    
    func saveNewAlarmClicked(audio: Multimedia) {
        if !Utils.isInternetAvailable() {
            Utils.showAlert(title: "Error", message: "Internet is not available. Please try again!", viewController: self)
            return
        }

        _ = SwiftOverlays.showBlockingWaitOverlayWithText("Uploading...")

        let user = UserDAO.getUser(id: UserDefaultManager.getInstance().getCurrentUser())
        let path = Utils.getDocumentsDirectory().appendingPathComponent(audio.name).relativePath
        let user_id = audio.user_id
        let type_id = audio.type_id
        let name = audio.name
    
        let audioData = try! NSData(contentsOfFile: path, options: NSData.ReadingOptions.alwaysMapped)

        if MultimediaManager.getInstance().audios.count == 1 {
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
                            MultimediaManager.getInstance().audios.append(newAudio)
                            MultimediaDAO.addMultimedia(multimedia: newAudio)
                            Utils.showAlert(title: "Congratulation", message: "You uploaded a media file successfully!", viewController: self)
                            self.audioNameLabel.text = audio.name
                        }
                        else {
                            Utils.showAlert(title: "Error", message: "Could not upload audio. Please try again!", viewController: self)
                        }
                    }
                case .failure(_):
                    Utils.showAlert(title: "Error", message: "Could not upload audio. Please try again!", viewController: self)
                    SwiftOverlays.removeAllBlockingOverlays()
                    return
                }
            })
        }
        else {
            let oldAudio = MultimediaManager.getInstance().audios[1]
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(audioData as Data, withName: "path", fileName: name, mimeType: "audio/caf")
                    multipartFormData.append(String(user_id).data(using: .utf8)!, withName: "user_id")
                    multipartFormData.append(String(type_id).data(using: .utf8)!, withName: "type_id")
                    multipartFormData.append(name.components(separatedBy: ".")[0].data(using: .utf8)!, withName: "name")
                    multipartFormData.append("PUT".data(using: .utf8)!, withName: "_method")
                    
            },to: Global.baseURL + "multimedia/" + String(oldAudio.id) + "?token=" + (user?.token)!,
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
                            print(multimediaResult)
                            let newAudio = Multimedia()
                            newAudio.id = oldAudio.id
                            newAudio.user_id = oldAudio.user_id
                            newAudio.name = audio.name
                            newAudio.type_id = oldAudio.type_id
                            newAudio.sent = oldAudio.sent
                            newAudio.path = multimediaResult.path
                            MultimediaDAO.updateMultimedia(multimedia: newAudio)
                            Utils.showAlert(title: "Congratulation", message: "You uploaded a media file successfully!", viewController: self)
                            self.audioNameLabel.text = audio.name
                        }
                        else {
                            Utils.showAlert(title: "Error", message: "Could not upload audio. Please try again!", viewController: self)

                        }
                    }
                case .failure(_):
                    SwiftOverlays.removeAllBlockingOverlays()
                    Utils.showAlert(title: "Error", message: "Could not upload audio. Please try again!", viewController: self)
                    return
                }
            })
        }
    }
    
    private func stop() {
        let playIcon = FAKFontAwesome.playIcon(withSize: 15)
        playIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain)
        let playImg  = playIcon?.image(with: CGSize(width: 15, height: 15))
        audioBtn.setImage(playImg, for: .normal)
        isPlayAudio = false
        if audioPlayer != nil && audioPlayer.isPlaying {
            audioPlayer.pause()
        }
    }
    
    private func play() {
        let pauseIcon = FAKFontAwesome.pauseIcon(withSize: 15)
        pauseIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain)
        let pauseImg  = pauseIcon?.image(with: CGSize(width: 15, height: 15))
        audioBtn.setImage(pauseImg, for: .normal)
        isPlayAudio = true
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stop()
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        stop()
        Utils.showAlert(title: "Error", message: "Play audio error!", viewController: self)
    }
}
