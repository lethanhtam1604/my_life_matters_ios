
//
//  CameraViewController.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 11/23/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import MobileCoreServices
import PureLayout
import FontAwesomeKit
import AVFoundation
import QuartzCore
import Alamofire

class CameraViewController: UIImagePickerController, UINavigationControllerDelegate, CaptureButtonDelegate, UIImagePickerControllerDelegate {
    var constraintsAdded = false
    
    var torchOn = false
    var capturing = false
    
    let overlayView = UIView()
    let captureButton = CaptureButton()
    let switchButton = UIButton()
    let menuButton = UIButton()
    let flashButton = UIButton()
    
    let preview = UIView()
    let imageView = UIImageView()
    var resultImage : UIImage?
    let closeBtn = UIButton()
    
    var user: User!
    var type = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup overlay
        captureButton.delegate = self
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.black
        preview.isHidden = true
        preview.backgroundColor = UIColor.black

        let iosArrowBackIcon = FAKIonIcons.iosArrowBackIcon(withSize: 30)
        iosArrowBackIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let iosArrowBackImg  = iosArrowBackIcon?.image(with: CGSize(width: 40, height: 40))
        
        menuButton.setImage(iosArrowBackImg, for: .normal)
        menuButton.tintColor = UIColor.white
        menuButton.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
        menuButton.imageView?.contentMode = .scaleAspectFit
        
        let flashIcon = FAKIonIcons.flashIcon(withSize: 40)
        flashIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let flashImg  = flashIcon?.image(with: CGSize(width: 40, height: 40))
        flashButton.setImage(flashImg, for: .normal)
        flashButton.addTarget(self, action: #selector(toggleFlash), for: .touchUpInside)
        flashButton.imageView?.contentMode = .scaleAspectFit
        
        switchButton.setImage(UIImage(named: "switch-camera.png"), for: .normal)
        switchButton.addTarget(self, action: #selector(switchCamera), for: .touchUpInside)
        switchButton.imageView?.contentMode = .scaleAspectFit
        
        let closeCircledIcon = FAKIonIcons.closeCircledIcon(withSize: 30)
        closeCircledIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let closeCircledImg  = closeCircledIcon?.image(with: CGSize(width: 40, height: 40))
        closeBtn.setImage(closeCircledImg, for: .normal)
        closeBtn.tintColor = UIColor.white
        closeBtn.addTarget(self, action: #selector(closeImageView), for: .touchUpInside)
        closeBtn.imageView?.contentMode = .scaleAspectFit
        
        overlayView.addSubview(captureButton)
        overlayView.addSubview(switchButton)
        overlayView.addSubview(menuButton)
        overlayView.addSubview(flashButton)
        
        preview.addSubview(imageView)
        preview.addSubview(closeBtn)
        view.addSubview(overlayView)
        view.addSubview(preview)
        self.view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        if !constraintsAdded {
            constraintsAdded = true
            
            overlayView.autoPinEdgesToSuperviewEdges()
            preview.autoPinEdgesToSuperviewEdges()
            imageView.autoPinEdgesToSuperviewEdges()
            
            captureButton.autoAlignAxis(toSuperviewAxis: .vertical)
            captureButton.autoPinEdge(toSuperviewMargin: .bottom)
            captureButton.autoSetDimension(.width, toSize: 80)
            captureButton.autoSetDimension(.height, toSize: 80)
            
            menuButton.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            menuButton.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            menuButton.autoSetDimension(.width, toSize: 40)
            menuButton.autoSetDimension(.height, toSize: 40)
            
            flashButton.autoPinEdge(toSuperviewMargin: .right)
            flashButton.autoPinEdge(toSuperviewMargin: .top)
            flashButton.autoSetDimension(.width, toSize: 40)
            flashButton.autoSetDimension(.height, toSize: 40)
            
            switchButton.autoPinEdge(toSuperviewMargin: .left)
            switchButton.autoPinEdge(toSuperviewMargin: .bottom)
            switchButton.autoSetDimension(.width, toSize: 40)
            switchButton.autoSetDimension(.height, toSize: 30)
            
            closeBtn.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            closeBtn.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            closeBtn.autoSetDimension(.width, toSize: 40)
            closeBtn.autoSetDimension(.height, toSize: 40)
            
        }
        super.updateViewConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBarHidden(true, with: .fade)
        
        showPicker()
        
        if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) !=  AVAuthorizationStatus.authorized {
            overlayView.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    func showPicker() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            self.allowsEditing = true
            self.sourceType = .camera
            self.showsCameraControls = false
            
            if #available(iOS 10.0, *) {
                self.mediaTypes = [kUTTypeMovie as String]
            } else {
                let screenSize = UIScreen.main.bounds.size
                let scale = screenSize.height / (screenSize.width / 3 * 4)
                let translateY = (screenSize.height - (screenSize.width / 3 * 4)) / 2
                
                self.cameraViewTransform = CGAffineTransform.identity.translatedBy(x: 0, y: translateY)
                self.cameraViewTransform = self.cameraViewTransform.scaledBy(x: scale, y: scale)
                
                self.mediaTypes = [kUTTypeImage as String]
            }
            
            self.delegate = self
            self.cameraFlashMode = .on
            
            let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
            if (device? .hasTorch)! && (device?.hasFlash)! {
                try! device?.lockForConfiguration()
                device?.torchMode = .off
                device?.flashMode = .off
                device?.unlockForConfiguration()
            }
        } else {
            self.overlayView.backgroundColor = UIColor.black
            self.captureButton.enabled = false
            Utils.showAlert(title: "BELM", message: "Camera not available", viewController: self)
        }
        
        self.overlayView.isHidden = false
        self.menuButton.isHidden = false
        self.flashButton.isHidden = false
        self.switchButton.isHidden = false
        self.captureButton.isHidden = false
        self.torchOn = false
        
        self.view.setNeedsUpdateConstraints()
    }
    
    func toggleFlash() {
        var flashIcon : FAKIcon!
        
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        if (device? .hasTorch)! && (device?.hasFlash)! {
            try! device?.lockForConfiguration()
            if !(device?.isTorchActive)! {
                device?.torchMode = .on
                device?.flashMode = .on
                torchOn = true
                flashIcon = FAKIonIcons.flashIcon(withSize: 40)
            } else {
                device?.torchMode = .off
                device?.flashMode = .off
                torchOn = false
                flashIcon = FAKIonIcons.flashOffIcon(withSize: 40)
            }
            device?.unlockForConfiguration()
        }
        
        flashIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        let flashImg  = flashIcon.image(with: CGSize(width: 40, height: 40))
        flashButton.setImage(flashImg, for: .normal)
    }
    
    func closeImageView() {
        self.preview.isHidden = true
    }
    
    func showMenu() {
        dismiss(animated: true, completion: nil)
    }
    
    func switchCamera() {
        if(self.cameraDevice == .front) {
            self.cameraDevice = .rear;
            torchOn = false
            let flashIcon = FAKIonIcons.flashIcon(withSize: 40)
            flashIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
            let flashImg  = flashIcon?.image(with: CGSize(width: 40, height: 40))
            flashButton.setImage(flashImg, for: .normal)
            flashButton.isHidden = false
        } else {
            self.cameraDevice = .front;
            flashButton.isHidden = true
        }
    }
    
    func shouldTakePicture() {
        if type == 1 {
            self.takePicture()
        }
        else {
            if !capturing {
                if #available(iOS 10.0, *) {
                    capturing = true
                    self.startVideoCapture()
                    checkTorchStatus()
                } else {
                    overlayView.backgroundColor = UIColor.black
                    self.mediaTypes = [kUTTypeMovie as String]
                    self.cameraViewTransform = CGAffineTransform.identity
                    
                    let when = DispatchTime.now() + 1
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        self.capturing = true
                        self.overlayView.backgroundColor = UIColor.clear
                        self.startVideoCapture()
                        self.checkTorchStatus()
                    }
                }
                
            }
            else {
                if capturing {
                    self.stopVideoCapture()
                    capturing = false
                }
            }
            
        }
    }
    
    func shouldCaptureVideo() {
        
    }
    
    func shouldStopCapturingVideo() {
        
    }
    
    func checkTorchStatus() {
        if self.torchOn {
            let when = DispatchTime.now() + 0.8
            DispatchQueue.main.asyncAfter(deadline: when) {
                if (self.capturing) {
                    let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
                    if (device? .hasTorch)! && (device?.hasFlash)! {
                        try! device?.lockForConfiguration()
                        device?.torchMode = .on
                        device?.flashMode = .on
                        device?.unlockForConfiguration()
                    }
                }
                
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        showPicker()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var info = info
        
        let type = info[UIImagePickerControllerMediaType] as! String
        if type == (kUTTypeImage as String) {
            if self.sourceType == .camera {
                let media = info[UIImagePickerControllerOriginalImage] as! UIImage
                let result = media.crop(to: UIScreen.main.bounds.size)
                info[UIImagePickerControllerOriginalImage] = result
                info["source"] = "camera" as AnyObject?
            } else {
                info["source"] = "gallery" as AnyObject?
            }
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            let imageData = UIImageJPEGRepresentation(image.resize(newSize: Global.imageSize), 1)
            self.resultImage = UIImage(data: imageData!)
            self.preview.isHidden = false
            self.closeBtn.isHidden = true
            self.imageView.image = nil
            uploadImage(image: imageData!)
        }
        
        if type == (kUTTypeMovie as String) {
            let media = info[UIImagePickerControllerMediaURL] as! NSURL
            let videoPath = media.relativePath!
            let movieData = try! NSData(contentsOfFile: videoPath, options: NSData.ReadingOptions.alwaysMapped)
            self.preview.isHidden = false
            self.closeBtn.isHidden = true
            uploadVideo(video: movieData as Data)
        }
    }
    
    func displayPreview() {
        self.imageView.image = self.resultImage
        self.closeBtn.isHidden = false
        DispatchQueue.main.async {
            SwiftOverlays.removeAllBlockingOverlays()
            self.preview.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
                self.preview.transform = CGAffineTransform.identity
            }, completion: {
                _ in
            })
        }
    }
    
    func uploadImage(image: Data) {
        user = UserDAO.getUser(id: UserDefaultManager.getInstance().getCurrentUser())
        let user_id = user.id
        let type_id = 6
        let name = "Photo" + Utils.getCurrentDateTime()
        
        SwiftOverlays.showBlockingWaitOverlay()
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(image, withName: "path", fileName: "photo.jpeg", mimeType: "image/jpeg")
                multipartFormData.append(String(user_id).data(using: .utf8)!, withName: "user_id")
                multipartFormData.append(String(type_id).data(using: .utf8)!, withName: "type_id")
                multipartFormData.append(name.data(using: .utf8)!, withName: "name")
                
        },to: Global.baseURL + "multimedia?token=" + (user?.token)!,
          encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    SwiftOverlays.removeAllBlockingOverlays()
                    self.preview.isHidden = true
                    if response.data?.count == 0 {
                        Utils.showAlert(title: "Error", message: "Could not upload photo. Please try again!", viewController: self)
                        return
                    }
                    let result = Response(data: response.data!)
                    if result.success == "true" {
                        let multimediaResult = MultimediaResult(data: response.data!)
                        
                        let multimedia = Multimedia()
                        multimedia.name = multimediaResult.name
                        multimedia.user_id = user_id
                        multimedia.type_id = type_id
                        multimedia.id = multimediaResult.id
                        multimedia.sent = true
                        multimedia.path = multimediaResult.path
                        
                        MultimediaManager.getInstance().allMultimedia.append(multimedia)
                        MultimediaDAO.addMultimedia(multimedia: multimedia)
                        
                        Utils.showAlert(title: "Congratulation", message: "You uploaded photo to server successfully!", viewController: self)
                        
                    }
                    else {
                        Utils.showAlert(title: "Error", message: "Could not upload photo to server. Please try again!", viewController: self)
                        //SwiftOverlays.removeAllBlockingOverlays()
                    }
                }
            case .failure(_):
                self.preview.isHidden = true
                Utils.showAlert(title: "Error", message: "Could not upload photo to server. Please try again!", viewController: self)
                SwiftOverlays.removeAllBlockingOverlays()
            }
        })
    }
    
    func uploadVideo(video: Data) {
        user = UserDAO.getUser(id: UserDefaultManager.getInstance().getCurrentUser())
        let user_id = user.id
        let type_id = 7
        let name = "Video" + Utils.getCurrentDateTime()
        
        SwiftOverlays.showBlockingWaitOverlay()
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(video, withName: "path", fileName: "video.mov", mimeType: "video/mov")
                multipartFormData.append(String(user_id).data(using: .utf8)!, withName: "user_id")
                multipartFormData.append(String(type_id).data(using: .utf8)!, withName: "type_id")
                multipartFormData.append(name.data(using: .utf8)!, withName: "name")
                
        },to: Global.baseURL + "multimedia?token=" + (user?.token)!,
          encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    SwiftOverlays.removeAllBlockingOverlays()
                    self.preview.isHidden = true
                    if response.data?.count == 0 {
                        Utils.showAlert(title: "Error", message: "Could not upload video. Please try again!", viewController: self)
                        return
                    }
                    let result = Response(data: response.data!)
                    if result.success == "true" {
                        let multimediaResult = MultimediaResult(data: response.data!)
                        let multimedia = Multimedia()
                        multimedia.name = multimediaResult.name
                        multimedia.user_id = user_id
                        multimedia.type_id = type_id
                        multimedia.id = multimediaResult.id
                        multimedia.sent = true
                        multimedia.path = multimediaResult.path
                        
                        MultimediaManager.getInstance().allMultimedia.append(multimedia)
                        MultimediaDAO.addMultimedia(multimedia: multimedia)
                        Utils.showAlert(title: "Congratulation", message: "You uploaded video to server successfully!", viewController: self)
                        
                    }
                    else {
                        Utils.showAlert(title: "Error", message: "Could not upload video to server. Please try again!", viewController: self)
                    }
                }
            case .failure(_):
                self.preview.isHidden = true
                Utils.showAlert(title: "Error", message: "Could not upload video to server. Please try again!", viewController: self)
                SwiftOverlays.removeAllBlockingOverlays()
            }
        })
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        if self.sourceType == .camera {
            self.showsCameraControls = false
        }
    }
}