//
//  CreateUsernameVC.swift
//  Skirt
//
//  Created by Evgeny Vlasov on 2/28/17.
//  Copyright © 2017 Evgeny Vlasov. All rights reserved.
//

import UIKit

class CreateUsernameVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var genderPickerTextField: UITextField!
    
    var genderPicker = UIPickerView()
    let genders = ["female", "male", "gender fluid"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genderPicker.delegate = self
        genderPicker.dataSource = self
        genderPickerTextField.inputView = genderPicker
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //creation underline for title field.
        let usernameUnderline = CALayer()
        let usernameWidth = CGFloat(1.0)
        usernameUnderline.borderColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0).cgColor
        usernameUnderline.frame = CGRect(x: 0, y: usernameTextField.frame.size.height - usernameWidth, width:  usernameTextField.frame.size.width, height: usernameTextField.frame.size.height)
        usernameUnderline.borderWidth = usernameWidth
        usernameTextField.layer.addSublayer(usernameUnderline)
        usernameTextField.layer.masksToBounds = true
        
        //creation underline for category field
        let genderUnderline = CALayer()
        let genderWidth = CGFloat(1.0)
        genderUnderline.borderColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1.0).cgColor
        genderUnderline.frame = CGRect(x: 0, y: genderPickerTextField.frame.size.height - genderWidth, width:  genderPickerTextField.frame.size.width, height: genderPickerTextField.frame.size.height)
        genderUnderline.borderWidth = genderWidth
        genderPickerTextField.layer.addSublayer(genderUnderline)
        genderPickerTextField.layer.masksToBounds = true
        
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let title = genders[row]
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let gender = genders[genderPicker.selectedRow(inComponent: 0)]
        genderPickerTextField.text = gender
    }
    
    
    
    
    
    
    
}
