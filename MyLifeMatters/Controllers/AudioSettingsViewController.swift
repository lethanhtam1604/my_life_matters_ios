//
//  AudioSettingsViewController.swift
//  MyLifeMatters
//
//  Created by D on 12/17/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import FontAwesomeKit
import CNPPopupController
import AVFoundation

class AudioSettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CNPPopupControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tableViewPopup =  UITableView()
    var mapPopup: CNPPopupController!
    let headerBorder = UIView()
    
    let settingCellReuseIdentifier = "AudioSettingsCellReuseIdentifier"
    
    let titles: [String] = ["Output format", "Sample rate", "Encoder bitrate", "Audio List"]
    let sampleRates: [String] = ["44 kHz - CD quality", "32 kHz - FM radio quality", "22 kHz - AM radio quality", "16 kHz - Medium quality", "11 kHz - Lower quality", "8 kHz - Phone quality"]
    let outputFormats: [String] = ["caf", "m4a"]
    let encoderBitrates: [String] = ["320 kbps", "265 kbps", "192 kbps", "128 kbps", "96 kbps", "64 kbps", "32 kbps"]
    
    public static var selectedItemIndexInSampleRate = NSIndexPath(row: 1, section: 0)
    public static var selectedItemIndexInOutputFormat = NSIndexPath(row: 0, section: 0)
    public static var selectedItemIndexInEncoderBitrate = NSIndexPath(row: 3, section: 0)
    public static var selectedItemIndexAudioList = NSIndexPath(row: 0, section: 0)
    
    var optionIndex: Int = 0
    var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Audio Settings"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "AudioSettingsTableViewCell", bundle: nil), forCellReuseIdentifier: settingCellReuseIdentifier as String)
        tableView.alwaysBounceVertical = false
        tableView.tableFooterView = UIView()
        
        headerBorder.backgroundColor = Global.colorBg
        
        AudioSettingsViewController.selectedItemIndexInOutputFormat = NSIndexPath(row: UserDefaultManager.getInstance().getIndexOutputFormat(), section: 0)
        AudioSettingsViewController.selectedItemIndexInSampleRate = NSIndexPath(row: UserDefaultManager.getInstance().getIndexSampleRate(), section: 0)
        AudioSettingsViewController.selectedItemIndexInEncoderBitrate = NSIndexPath(row: UserDefaultManager.getInstance().getIndexEncodeBitRate(), section: 0)
        AudioSettingsViewController.selectedItemIndexAudioList = NSIndexPath(row: UserDefaultManager.getInstance().getIndexAudioList(), section: 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView.isEqual(self.tableView)){
            return self.titles.count
        }else {
            switch(optionIndex)
            {
            case 0:
                return self.outputFormats.count
            case 1:
                return self.sampleRates.count
            case 2:
                return self.encoderBitrates.count
            case 3:
                return MultimediaManager.getInstance().audios.count
            default:
                return 0
            }
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if (tableView.isEqual(self.tableView)){
            
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 40))
            
            let labelView = UILabel()
            
            labelView.backgroundColor = UIColor.clear
            labelView.text = "General"
            labelView.font = UIFont.boldSystemFont(ofSize: 17)
            labelView.textColor = Global.colorMain
            
            headerView.addSubview(labelView)
            headerView.addSubview(headerBorder)
            
            labelView.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
            labelView.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            labelView.autoSetDimension(.height, toSize: 20)
            labelView.autoAlignAxis(toSuperviewAxis: .horizontal)
            
            headerBorder.autoPinEdge(toSuperviewEdge: .bottom)
            headerBorder.autoPinEdge(toSuperviewEdge: .left)
            headerBorder.autoPinEdge(toSuperviewEdge: .right)
            headerBorder.autoSetDimension(.height, toSize: 1)
            
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView.isEqual(self.tableView)){
            
            let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: settingCellReuseIdentifier) as UITableViewCell!
            
            if let nameLabel = cell.viewWithTag(100) as? UILabel {
                nameLabel.text = self.titles[indexPath.row]
            }
            if let nameLabel = cell.viewWithTag(101) as? UILabel {
                if indexPath.row == 0 {
                    nameLabel.text = self.outputFormats[UserDefaultManager.getInstance().getIndexOutputFormat()]
                }
                else if indexPath.row == 1 {
                    nameLabel.text = self.sampleRates[UserDefaultManager.getInstance().getIndexSampleRate()]
                }
                else if indexPath.row == 2 {
                    nameLabel.text = self.encoderBitrates[UserDefaultManager.getInstance().getIndexEncodeBitRate()]
                }
                else {
                    let songName = MultimediaManager.getInstance().audios[UserDefaultManager.getInstance().getIndexAudioList()].name
                    let arrayList = songName.components(separatedBy: "_A")
                    if arrayList.count > 1 {
                        nameLabel.text = "A" + arrayList[1]
                    }
                    else {
                        nameLabel.text = songName
                    }
                }
            }
            return cell
        }
        else {
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell!
            var tempIndex: Int = 0
            switch(optionIndex)
            {
            case 0:
                cell.textLabel?.text = self.outputFormats[indexPath.row]
                tempIndex = UserDefaultManager.getInstance().getIndexOutputFormat()
            case 1:
                cell.textLabel?.text = self.sampleRates[indexPath.row]
                tempIndex = UserDefaultManager.getInstance().getIndexSampleRate()
            case 2:
                cell.textLabel?.text = self.encoderBitrates[indexPath.row]
                tempIndex = UserDefaultManager.getInstance().getIndexEncodeBitRate()
            case 3:
                let songName = MultimediaManager.getInstance().audios[indexPath.row].name
                let arrayList = songName.components(separatedBy: "_A")
                if arrayList.count > 1 {
                    cell.textLabel?.text = "A" + arrayList[1]
                }
                else {
                    cell.textLabel?.text = songName
                }
                tempIndex = UserDefaultManager.getInstance().getIndexAudioList()
            default:
                break
            }
            if(indexPath.row == tempIndex) {
                cell.accessoryType = .checkmark
            }
            else {
                cell.accessoryType = .none
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView.isEqual(self.tableView)) {
            
            optionIndex = indexPath.row
            var height: Int = 100
            switch(optionIndex)
            {
            case 0:
                height = 88
            case 1:
                height = 264
            case 2:
                height = 308
            case 3:
                height = MultimediaManager.getInstance().audios.count * 44
            default:
                break
            }
            tableViewPopup.frame         =   CGRect(x: 0, y: 0, width: Int(ScreenSize.SCREEN_WIDTH - 70), height: height)
            tableViewPopup.delegate      =   self
            tableViewPopup.dataSource    =   self
            tableViewPopup.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            tableViewPopup.reloadData()
            tableViewPopup.tableFooterView = UIView()
            
            mapPopup = CNPPopupController(contents: [tableViewPopup])
            mapPopup.delegate = self
            mapPopup.theme.popupStyle = .centered
            mapPopup.theme = .default()
            mapPopup.theme.backgroundColor = Global.colorBg
            mapPopup.present(animated: true)
        }
        else {
            let newCell = tableView.cellForRow(at: indexPath)
            newCell?.accessoryType = .checkmark
            let tempCell = self.tableView.cellForRow(at: NSIndexPath(row: optionIndex, section: 0) as IndexPath)
            
            switch(optionIndex) {
            case 0:
                let oldCell = tableView.cellForRow(at: AudioSettingsViewController.selectedItemIndexInOutputFormat as IndexPath)
                oldCell?.accessoryType = .none
                AudioSettingsViewController.selectedItemIndexInOutputFormat = indexPath as NSIndexPath
                if let nameLabel = tempCell?.viewWithTag(101) as? UILabel {
                    let index = AudioSettingsViewController.selectedItemIndexInOutputFormat.row
                    nameLabel.text = self.outputFormats[index]
                    UserDefaultManager.getInstance().setIndexOutputFormat(value: index)
                }
                break
            case 1:
                let oldCell = tableView.cellForRow(at: AudioSettingsViewController.selectedItemIndexInSampleRate as IndexPath)
                oldCell?.accessoryType = .none
                AudioSettingsViewController.selectedItemIndexInSampleRate = indexPath as NSIndexPath
                if let nameLabel = tempCell?.viewWithTag(101) as? UILabel {
                    let index = AudioSettingsViewController.selectedItemIndexInSampleRate.row
                    nameLabel.text = self.sampleRates[index]
                    UserDefaultManager.getInstance().setIndexSampleRate(value: index)
                }
                break
            case 2:
                let oldCell = tableView.cellForRow(at: AudioSettingsViewController.selectedItemIndexInEncoderBitrate as IndexPath)
                oldCell?.accessoryType = .none
                AudioSettingsViewController.selectedItemIndexInEncoderBitrate = indexPath as NSIndexPath
                if let nameLabel = tempCell?.viewWithTag(101) as? UILabel {
                    let index = AudioSettingsViewController.selectedItemIndexInEncoderBitrate.row
                    nameLabel.text = self.encoderBitrates[index]
                    UserDefaultManager.getInstance().setIndexEncodeBitRate(value: index)
                }
                break
            case 3:
                if UserDefaultManager.getInstance().getIndexAudioList() != indexPath.row {
                    let oldCell = tableView.cellForRow(at: AudioSettingsViewController.selectedItemIndexAudioList as IndexPath)
                    oldCell?.accessoryType = .none
                }

                AudioSettingsViewController.selectedItemIndexAudioList = indexPath as NSIndexPath
                if let nameLabel = tempCell?.viewWithTag(101) as? UILabel {
                    let index = AudioSettingsViewController.selectedItemIndexAudioList.row
                    let songName = MultimediaManager.getInstance().audios[index].name
                    let arrayList = songName.components(separatedBy: "_A")
                    if arrayList.count > 1 {
                        nameLabel.text = "A" + arrayList[1]
                    }
                    else {
                        nameLabel.text = songName
                    }
                    UserDefaultManager.getInstance().setIndexAudioList(value: index)
                    
                    do {
                        var fileUrl: NSURL!
                        if songName == "alarm_belm.mp3" {
                            fileUrl = Bundle.main.url(forResource: "alarm_belm.mp3", withExtension: nil) as NSURL!
                        }
                        else {
                            fileUrl = Utils.getDocumentsDirectory().appendingPathComponent(MultimediaManager.getInstance().audios[index].name) as NSURL!
                        }
                        
                        try audioPlayer = AVAudioPlayer(contentsOf: fileUrl as URL)
                        audioPlayer!.prepareToPlay()
                        audioPlayer!.play()
                    } catch let error as NSError {
                        Utils.showAlert(title: "Error", message: "audioPlayer error: \(error.localizedDescription)", viewController: self)
                    }
                    
                }
                break
            default:
                break
            }
        }
    }
    
    func popupControllerDidDismiss(_ controller: CNPPopupController) {
        if audioPlayer != nil {
            audioPlayer.stop()
        }
    }
    
}
