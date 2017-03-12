//
//  LogInVC.swift
//  Skirt
//
//  Created by Evgeny Vlasov on 2/24/17.
//  Copyright © 2017 Evgeny Vlasov. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper


class LogInVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    var avatarUrlRef: FIRDatabaseReference!
    var usernameRef: FIRDatabaseReference!
    var genderRef: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 75
    }
    
    override func viewDidAppear(_ animated: Bool) {

         // if user already exists in keychain:
        
         if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("Zhenya: ID found in keychain")
         
            // If user has avatarUrl/username/gender in Firebase - FeedVC, if not - CreateUsernameVC
            
           avatarUrlRef = DataService.ds.REF_USER_CURRENT.child("avatarUrl")
            
           avatarUrlRef.observe(.value, with:{ (snapshot) in
                let snapshotValue = snapshot.value as? String
                
                if snapshotValue == nil || snapshotValue == "" {
                    self.performSegue(withIdentifier: "CreateUsernameVC", sender: nil)
                } else {
                    self.performSegue(withIdentifier: "FeedVC", sender: nil)
                }
            })
            
            usernameRef = DataService.ds.REF_USER_CURRENT.child("username")
            usernameRef.observe(.value, with:{ (snapshot) in
                let snapshotValue = snapshot.value as? String
                
                if snapshotValue == nil || snapshotValue == "" {
                    self.performSegue(withIdentifier: "CreateUsernameVC", sender: nil)
                } else {
                    self.performSegue(withIdentifier: "FeedVC", sender: nil)
                }
            })
            
            genderRef = DataService.ds.REF_USER_CURRENT.child("gender")
            genderRef.observe(.value, with:{ (snapshot) in
                let snapshotValue = snapshot.value as? String
                
                if snapshotValue == nil || snapshotValue == "" {
                    self.performSegue(withIdentifier: "CreateUsernameVC", sender: nil)
                } else {
                    self.performSegue(withIdentifier: "FeedVC", sender: nil)
                }
            })
         }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //creation underline for title field.
        let emailUnderline = CALayer()
        let emailWidth = CGFloat(1.0)
        emailUnderline.borderColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0).cgColor
        emailUnderline.frame = CGRect(x: 0, y: emailTextField.frame.size.height - emailWidth, width:  emailTextField.frame.size.width, height: emailTextField.frame.size.height)
        emailUnderline.borderWidth = emailWidth
        emailTextField.layer.addSublayer(emailUnderline)
        emailTextField.layer.masksToBounds = true
        
        //creation underline for category field
        let passUnderline = CALayer()
        let passWidth = CGFloat(1.0)
        passUnderline.borderColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1.0).cgColor
        passUnderline.frame = CGRect(x: 0, y: passTextField.frame.size.height - passWidth, width:  passTextField.frame.size.width, height: passTextField.frame.size.height)
        passUnderline.borderWidth = passWidth
        passTextField.layer.addSublayer(passUnderline)
        passTextField.layer.masksToBounds = true
        
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        if let email = emailTextField.text, let pwd = passTextField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("Zhenya: Email user authenticated with Firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd) { (user, error) in
                        if error != nil {
                            print("Zhenya: Unable to authenticate with Firbase using email")
                            print("Zhenya: \(error.debugDescription)")
                            
                        } else {
                            print("Zhenya: Successfully authenticated with Firbase")
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                        }
                    }
                 }
            })
        }
    }

    
    @IBAction func fbLoginBtn(_ sender: Any) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if error != nil {
                print("Zhenya: Цукерман не может залогиниться \(error)" )
            } else if result?.isCancelled == true {
                print("Zhenya: User canceled FB authentication")
            } else {
                print("Zhenya: Successfully athenticated with FB")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Zhenya: Unable to login with Firebase")
            } else {
                print("Zhenya: Successfully loged in eith Firebase")
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            }
        })
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Zhenya: Data saved to keychain \(keychainResult)")
        
        performSegue(withIdentifier: "CreateUsernameVC", sender: nil)
    }

}



