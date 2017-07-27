//
//  AppDelegate.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 11/17/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import CoreData
import Fabric
import Crashlytics
import IQKeyboardManager
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //TestFairy
        TestFairy.begin("6b1dcc46265efb6be624802acd1cc9831b794e1d")
        
        //Crashlytics
        Fabric.with([Crashlytics.self])
        
        //set light status bar for whole ViewController
        UIApplication.shared.statusBarStyle = .lightContent
        
        // change status bar background color
        let statusView = (application.value(forKey: "statusBarWindow") as AnyObject).value(forKey: "statusBar") as! UIView
        statusView.backgroundColor = Global.colorStatus
        
        // change navigation bar background color and tint color
        UINavigationBar.appearance().backgroundColor = Global.colorSelected
        UINavigationBar.appearance().setBackgroundImage(UIImage(named:"navBar.png"), for: .default)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        // keyboard
        let keyboardManager = IQKeyboardManager.shared()
        keyboardManager.isEnabled = true
        keyboardManager.shouldHidePreviousNext = true
        keyboardManager.shouldShowTextFieldPlaceholder = false
        
        //
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("AVAudioSession is Active")
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        //
//        let result = UserDefaultManager.getInstance().getIsInitApp()
//        if (result) {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let userID = UserDefaultManager.getInstance().getCurrentUser()
            if userID == 0 {
                let signInViewController = storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
                self.window?.rootViewController = signInViewController
            }
            else {
                let user = UserDAO.getUser(id: userID)
                if user?.setup == "no" {
                    let setupUserViewController = storyBoard.instantiateViewController(withIdentifier: "SetupUserViewController") as! SetupUserViewController
                    let nav = UINavigationController(rootViewController: setupUserViewController)
                    self.window?.rootViewController = nav
                }
                else {
                    let mainViewController = storyBoard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                    let nav = UINavigationController(rootViewController: mainViewController)
                    self.window?.rootViewController = nav
                }
 
            }
//        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {

    }
    
    // MARK: - Core Data stack
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MyLifeMatters")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        var context: NSManagedObjectContext!
        
        if #available(iOS 10.0, *) {
            context = persistentContainer.viewContext
        } else {
            guard let modelURL = Bundle.main.url(forResource: "Model", withExtension:"momd") else {
                fatalError("Error loading model from bundle")
            }
            guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
                fatalError("Error initializing mom from: \(modelURL)")
            }
            let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
            context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let docURL = urls[urls.endIndex-1]
            let storeURL = docURL.appendingPathComponent("Model.sqlite")
            do {
                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

