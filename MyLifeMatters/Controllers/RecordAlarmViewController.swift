//
//  RecordAlarmViewController.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 12/8/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import FontAwesomeKit
import AVFoundation

protocol AlarmDelegate {
    func saveNewAlarmClicked(audio: Multimedia)
}

class RecordAlarmViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var alarmNameLabel: UILabel!
    @IBOutlet weak var recordView: UIView!
    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    var isRecord = false
    var alarmDelegate: AlarmDelegate!
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    
    var arraySampleRate: [Float] = [44100,32000,22050,16000,11025,8000]
    var arrayEncoderBitRate: [Int] = [320000,265000,192000,128000,96000,64000,32000]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "New Record"
        self.view.addTapToDismiss()
        
        timerView.layer.cornerRadius = 100
        
        recordView.layer.borderColor = Global.colorMain.cgColor
        recordView.layer.borderWidth = 1
        recordView.layer.cornerRadius = 35
        
        saveView.layer.borderColor = Global.colorMain.cgColor
        saveView.layer.borderWidth = 1
        saveView.layer.cornerRadius = 25
        
        let circleIcon = FAKFontAwesome.circleIcon(withSize: 20)
        circleIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.red)
        let circleImg  = circleIcon?.image(with: CGSize(width: 25, height: 25))
        recordBtn.setImage(circleImg, for: .normal)
        recordBtn.tintColor = UIColor.red
        recordBtn.addTarget(self, action: #selector(recordBtnClicked), for: .touchUpInside)
        recordBtn.imageView?.contentMode = .scaleAspectFit
        
        let floppyOIcon = FAKFontAwesome.floppyOIcon(withSize: 15)
        floppyOIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorGray)
        let floppyOImg  = floppyOIcon?.image(with: CGSize(width: 25, height: 25))
        saveBtn.setImage(floppyOImg, for: .normal)
        saveBtn.tintColor = Global.colorGray
        saveBtn.addTarget(self, action: #selector(saveBtnClicked), for: .touchUpInside)
        saveBtn.imageView?.contentMode = .scaleAspectFit
        saveBtn.isEnabled = false
        
        statusLabel.isHidden = true
        
        initRecord()
    }
    
    func initRecord() {
        let fileMgr = FileManager.default
        let dirPaths = fileMgr.urls(for: .documentDirectory, in: .userDomainMask)
        
        var recordSettings: [String : Any]!
        
        if (UserDefaultManager.getInstance().getIndexOutputFormat() == 1){
            alarmNameLabel.text = "Audio" + Utils.getCurrentDateTime() + ".m4a"
            recordSettings =
                [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
                    AVNumberOfChannelsKey: 1,
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: arraySampleRate[UserDefaultManager.getInstance().getIndexSampleRate()]]
        }
        else {
            alarmNameLabel.text = "Audio" + Utils.getCurrentDateTime() + ".caf"
            recordSettings =
                [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
                    AVEncoderBitRateKey: arrayEncoderBitRate[UserDefaultManager.getInstance().getIndexEncodeBitRate()],
                    AVNumberOfChannelsKey: 1,
                    AVFormatIDKey: Int(kAudioFormatAppleLossless),
                    AVSampleRateKey: arraySampleRate[UserDefaultManager.getInstance().getIndexSampleRate()]]
        }
        
        let soundFileURL = dirPaths[0].appendingPathComponent(alarmNameLabel.text!)
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            Utils.showAlert(title: "Error", message: "audioSession error: \(error.localizedDescription)", viewController: self)
        }
        
        do {
            try audioRecorder = AVAudioRecorder(url: soundFileURL, settings: recordSettings as [String : AnyObject])
            audioRecorder?.prepareToRecord()
        } catch let error as NSError {
            Utils.showAlert(title: "Error", message: "audioSession error: \(error.localizedDescription)", viewController: self)
        }
    }
    
    func recordBtnClicked() {
        if isRecord {
            saveBtn.isEnabled = true
            statusLabel.isHidden = true
            isRecord = false

            let circleIcon = FAKFontAwesome.circleIcon(withSize: 20)
            circleIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.red)
            let circleImg  = circleIcon?.image(with: CGSize(width: 25, height: 25))
            recordBtn.setImage(circleImg, for: .normal)
            recordBtn.tintColor = UIColor.red
            
            stopTimer()
            stopAudio()
        }
        else {
            saveBtn.isEnabled = false
            statusLabel.isHidden = false
            statusLabel.text = "Recording..."
            isRecord = true
            
            let stopIcon = FAKFontAwesome.stopIcon(withSize: 20)
            stopIcon?.addAttribute(NSForegroundColorAttributeName, value: Global.colorMain)
            let stopImg  = stopIcon?.image(with: CGSize(width: 20, height: 20))
            recordBtn.setImage(stopImg, for: .normal)
            recordBtn.tintColor = Global.colorMain
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
            
            recordAudio()
        }
    }
    
    func saveBtnClicked() {
        saveBtn.isEnabled = false
        let audio = Multimedia()
        audio.name = alarmNameLabel.text!
        audio.user_id = UserDefaultManager.getInstance().getCurrentUser()
        audio.type_id = 5
        audio.sent = false
        audio.choose = false
        audio.path = ""
        audio.id = MultimediaDAO.getNextId()
                
        if alarmDelegate != nil {
            alarmDelegate.saveNewAlarmClicked(audio: audio)
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    var count = 0
    var timer: Timer!
    
    func update() {
        count = count + 1
        let minutes = Int(count) / 60 % 60
        let seconds = Int(count) % 60
        timerLabel.text =  String(format:"%02i:%02i", minutes, seconds)
    }
    
    func stopTimer() {
        timerLabel.text =  String(format:"%02i:%02i", 0, 0)
        count = 0
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        isRecord = false
    }
    
    func recordAudio() {
        if audioRecorder?.isRecording == false {
            audioRecorder?.record()
        }
    }
    
    func pauseAudio() {
        if audioRecorder?.isRecording == true {
            audioRecorder?.pause()
        } else {
            audioPlayer?.pause()
        }
    }
    
    func stopAudio() {
        if audioRecorder?.isRecording == true {
            audioRecorder?.stop()
        } else {
            audioPlayer?.stop()
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        recordBtnClicked()
        Utils.showAlert(title: "Error", message: "Audio Record Encode Error!", viewController: self)
    }
}
