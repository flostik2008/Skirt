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

class LogInVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    @IBOutlet weak var fbBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fbBtn.layer.borderWidth = 0.0;

        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 75

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
    
    @IBAction func fbLogIn(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("Zhenya: unable to login with fb")
            } else if result?.isCancelled == true {
                print("Zhenya: user canceled login")
            }  else {
                print("Zhenya: successfully loged in with fb")
                //smth related to firebase
                 let credentials = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credentials)
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Zhenya: Unable to login with Firebase")
            } else {
                print("Zhenya: Successfully loged in eith Firebase")
            }
        })
    }
    
    // this is not a sign Up button, this is for the log in, button.
    
    @IBAction func signUpBtn(_ sender: Any) {
        if let email = emailTextField.text, let pass = passTextField.text {
            
            FIRAuth.auth()?.signIn(withEmail: email, password: pass, completion: { (user, error) in
                if error == nil {
                    print("Zhenya: User loged in with email and pass through Firebase")
                } else {
                    // there wasn't a user with such email/pass, create a new one.
                    FIRAuth.auth()?.createUser(withEmail: email, password: pass, completion: { (user, error) in
                        if error != nil {
                            print("Zhenya: unable to create user with this email with Firebase")
                        } else {
                            print("Zhenya: successfully created user with this email/pass with Firebase")
                        }
                    })
                }
            })
        }
    }
}



