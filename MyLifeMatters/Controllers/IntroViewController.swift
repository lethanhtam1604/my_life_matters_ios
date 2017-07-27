//
//  IntroViewController.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 11/24/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import EAIntroView

class IntroViewController: UIViewController, EAIntroDelegate {
    
    @IBOutlet var rootView: UIView!

    var introView: EAIntroView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showIntro()
    }

    func showIntro() {
        
        let page1 = EAIntroPage(customViewFromNibNamed: "IntroPage")
        let introPage1 = page1?.customView as! IntroPage
        introPage1.titleLabel.text = "TITILE 1"
        introPage1.subTitleLabel.text = "SubTitle 1"
        page1?.bgImage = UIImage(named: "setup_1.jpg")
        
        let page2 = EAIntroPage(customViewFromNibNamed: "IntroPage")
        let introPage2 = page2?.customView as! IntroPage
        introPage2.titleLabel.text = "TITILE 2"
        introPage2.subTitleLabel.text = "SubTitle 2"
        page2?.bgImage = UIImage(named: "setup_2.jpg")
        
        let page3 = EAIntroPage(customViewFromNibNamed: "IntroPage")
        let introPage3 = page3?.customView as! IntroPage
        introPage3.titleLabel.text = "TITILE 3"
        introPage3.subTitleLabel.text = "SubTitle 3"
        page3?.bgImage = UIImage(named: "setup_3.jpg")
        
        let page4 = EAIntroPage(customViewFromNibNamed: "IntroPage")
        let introPage4 = page4?.customView as! IntroPage
        introPage4.titleLabel.text = "BELM"
        introPage4.subTitleLabel.text = "Because Every Life has Meaning"
        introPage4.getStartedBtn.isHidden = false
        introPage4.getStartedBtn.addTarget(self, action: #selector(getStartedClicked), for: .touchUpInside)
        page4?.bgImage = UIImage(named: "setup_4")
        
        let intro = EAIntroView(frame: rootView.bounds, andPages: [page1!, page2!, page3!, page4!])
        intro?.skipButton.isHidden = true
        intro?.delegate = self
        intro?.pageControlY = 30
        intro?.show(in: rootView, animateDuration: 0.3)
        intro?.swipeToExit = false
        introView = intro
    }
    
    func introDidFinish(_ introView: EAIntroView!, wasSkipped: Bool) {
        getStartedClicked()
    }
    
    func getStartedClicked() {
        UserDefaultManager.getInstance().setIsInitApp(value: true)
        openSignIn()
    }
    
    func openSignIn() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let signInViewController = storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        self.present(signInViewController, animated:true, completion:nil)
    }
}
