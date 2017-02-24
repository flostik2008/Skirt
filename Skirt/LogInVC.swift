//
//  LogInVC.swift
//  Skirt
//
//  Created by Evgeny Vlasov on 2/24/17.
//  Copyright © 2017 Evgeny Vlasov. All rights reserved.
//

import UIKit

class LogInVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
}



