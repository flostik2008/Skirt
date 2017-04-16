//
//  AppDelegate.swift
//  Skirt
//
//  Created by Evgeny Vlasov on 2/7/17.
//  Copyright © 2017 Evgeny Vlasov. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import FBSDKLoginKit
import Firebase
import Onboard

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var storyboard: UIStoryboard?

    let kUserHasOnboardedKey = String("user_has_onboarded")
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        IQKeyboardManager.sharedManager().enable = true
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        FIRApp.configure()
        
        // on boarding:
        let userHasOnboarded = UserDefaults.standard.bool(forKey: kUserHasOnboardedKey!)
        
        if userHasOnboarded {
            setupNormalRootViewController()
        } else {
            self.window?.rootViewController = generateStandardOnboardingVC()
        }
        
        return true
    }

    func setupNormalRootViewController() {
        
        self.storyboard =  UIStoryboard(name: "Main", bundle: Bundle.main)
        let currentUser = FIRAuth.auth()?.currentUser
        if currentUser != nil
        {
            self.window?.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "FeedVC")
        }
        else
        {
            self.window?.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        }
    
    }

    func handleOnboardingComplition() {
        _ = UserDefaults.standard.set(true, forKey: kUserHasOnboardedKey!)
        
        self.setupNormalRootViewController()
    }
    
    func generateStandardOnboardingVC()-> OnboardingViewController {
    
        let firstPage = OnboardingContentViewController(title: "See what others are wearing today", body: nil, image: UIImage(named: "onboard1"), buttonText: nil, action: nil)
      
        let secondPage = OnboardingContentViewController(title: "Swipe left to post", body: nil, image: UIImage(named: "onboard2"), buttonText: nil, action: nil)
        
        let thirdPage = OnboardingContentViewController(title: "Swipe right to see your profile", body: nil, image: UIImage(named: "onboard3"), buttonText: nil, action: nil)
        
        let forthPage = OnboardingContentViewController(title: "Flag inappropriate content", body: nil, image: UIImage(named: "onboard4"), buttonText: "Get Started", action: self.handleOnboardingComplition)
        
        let pages = [firstPage, secondPage, thirdPage, forthPage]
        
        let titleFont = UIFont(name: "Roboto-Regular", size: 30)
        let buttonFont = UIFont(name: "Roboto-Italic", size: 32)
        
        switch UIScreen.main.bounds.height{
        case 568.0:
            
            for page in pages {
                page.titleLabel.font = titleFont
                page.topPadding = 90
                page.iconWidth = 260
                page.iconHeight = 480
                page.underIconPadding = -550
            }
            forthPage.actionButton.titleLabel?.font = buttonFont
            forthPage.actionButton.setBackgroundImage(UIImage(named: "getStartedBtn"), for: .normal)
        
        //iphone6,6s,7
        case 667.0:
            
            for page in pages {
                page.titleLabel.font = titleFont
                page.topPadding = 160
                page.iconWidth = 276
                page.iconHeight = 510
                page.underIconPadding = -610
            }
            forthPage.actionButton.titleLabel?.font = buttonFont
            forthPage.actionButton.setBackgroundImage(UIImage(named: "getStartedBtn"), for: .normal)
            
        //iphone6+,6s+,7+
        case 736.0:
            for page in pages {
                page.titleLabel.font = titleFont
                page.topPadding = 180
                page.iconWidth = 303
                page.iconHeight = 560
                page.underIconPadding = -650
            }
            forthPage.actionButton.titleLabel?.font = buttonFont
            forthPage.actionButton.setBackgroundImage(UIImage(named: "getStartedBtn"), for: .normal)
            
        default:
            for page in pages {
                page.titleLabel.font = titleFont
                page.topPadding = 90
                page.iconWidth = 260
                page.iconHeight = 480
                page.underIconPadding = -550
            }
            forthPage.actionButton.titleLabel?.font = buttonFont
            forthPage.actionButton.setBackgroundImage(UIImage(named: "getStartedBtn"), for: .normal)
        }
        
        let onboardingVC = OnboardingViewController.onboard(withBackgroundImage: UIImage(named: "Background1"), contents: [firstPage,secondPage,thirdPage,forthPage])
        onboardingVC?.shouldMaskBackground = false
        
        return onboardingVC!
        
    }
    
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    
    }
 
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Skirt")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

