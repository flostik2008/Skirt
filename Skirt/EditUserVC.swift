//
//  EditUserVC.swift
//  Skirt
//
//  Created by Evgeny Vlasov on 3/13/17.
//  Copyright © 2017 Evgeny Vlasov. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class EditUserVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var userPicImg: UIImageView!
    
    var usernameRef: FIRDatabaseReference!
    var genderRef: FIRDatabaseReference!
    var avatarRef: FIRDatabaseReference!

    var genderPicker = UIPickerView()
    let genders = ["female", "male", "gender fluid"]
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genderPicker.delegate = self
        genderPicker.dataSource = self
        genderTextField.inputView = genderPicker
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let userpicImgBordeWidth: CGFloat = 1
        userPicImg.layer.cornerRadius = userPicImg.frame.size.width/2
        userPicImg.layer.borderColor = UIColor.darkGray.cgColor
        userPicImg.layer.borderWidth = userpicImgBordeWidth
        userPicImg.clipsToBounds = true
        
        DataService.ds.REF_USER_CURRENT.observe(.value, with: { (snapshot) in
            if let userInfoDict = snapshot.value as? Dictionary<String, AnyObject> {
                let avatarUrl = userInfoDict["avatarUrl"] as! String
                let storageRef = FIRStorage.storage().reference(forURL: avatarUrl)
                storageRef.data(withMaxSize: 2*1024*1024, completion: { (data, error) in
                    if error != nil {
                        print("Zhenya: Couldn't download user's profile pic.")
                    } else {
                        if let imgData = data {
                            if let img = UIImage(data: imgData) {
                                self.userPicImg.image = img
                            }
                        }
                    }
                })
                
                let userName = userInfoDict["username"] as! String
                self.userNameTextField.text = userName
                
                let gender = userInfoDict["gender"] as! String
                self.genderTextField.text = gender
            }
        })

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //creation underline for title field.
        let usernameUnderline = CALayer()
        let usernameWidth = CGFloat(1.0)
        usernameUnderline.borderColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0).cgColor
        usernameUnderline.frame = CGRect(x: 0, y: userNameTextField.frame.size.height - usernameWidth, width:  userNameTextField.frame.size.width, height: userNameTextField.frame.size.height)
        usernameUnderline.borderWidth = usernameWidth
        userNameTextField.layer.addSublayer(usernameUnderline)
        userNameTextField.layer.masksToBounds = true
        
        //creation underline for category field
        let genderUnderline = CALayer()
        let genderWidth = CGFloat(1.0)
        genderUnderline.borderColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1.0).cgColor
        genderUnderline.frame = CGRect(x: 0, y: genderTextField.frame.size.height - genderWidth, width:  genderTextField.frame.size.width, height: genderTextField.frame.size.height)
        genderUnderline.borderWidth = genderWidth
        genderTextField.layer.addSublayer(genderUnderline)
        genderTextField.layer.masksToBounds = true
        
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
        genderTextField.text = gender
    }
    

    @IBAction func changeUserPicBtn(_ sender: Any) {
        let alertController = UIAlertController(title: "Choose source of image:", message: nil, preferredStyle: .actionSheet)
        
        let takePicAction = UIAlertAction(title: "Take Photo", style: .default) { (action) in
            let picker = UIImagePickerController()
            if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
                picker.sourceType = UIImagePickerControllerSourceType.camera
                picker.delegate = self
                picker.allowsEditing = false
                
                self.present(picker, animated: true, completion: nil)
            }
            else {
                print("Coudn't open the camera")
            }
        }
        alertController.addAction(takePicAction)
        
        let choosePicAction = UIAlertAction(title: "Choose from Library", style: .default) { (action) in
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        alertController.addAction(choosePicAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            userPicImg.image = image
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }

    @IBAction func backBtn(_ sender: Any) {
        performSegue(withIdentifier: "UserVC", sender: nil)
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        //username:
        usernameRef = DataService.ds.REF_USER_CURRENT.child("username")
        
        if let userName = userNameTextField.text, userName != "" {
            
            print("Zhenya: Successfully saved username to FireBase")
            usernameRef.setValue(userName)
            
        } else {
            print("Zhenya: No caption was enetered")
            // show alert view "username/gender/userpic are required"
            
        }
        
        //gender
        genderRef = DataService.ds.REF_USER_CURRENT.child("gender")
        
        if let gender = genderTextField.text, gender != "" {
            
            print("Zhenya: Successfully saved gender to Firebase")
            genderRef.setValue(gender)
        } else {
            print("Zhenya: no gender was chosen")
        }
        
        
        //userpic url:
        avatarRef = DataService.ds.REF_USER_CURRENT.child("avatarUrl")
        
        guard let img = userPicImg.image else {
            print("Zhenya: No image was selected")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            let imgUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            // here we take avatar (imgData) and save it to Fireabase (we did the same in "postBtnPressed"):
            
            print("Zhenya: here is my avatar: \(imgData)")
            
            DataService.ds.REF_USER_AVATARS.child(imgUid).put(imgData, metadata: metadata) {(metadata, error) in
                
                if error != nil {
                    print("Zhenya: UserAvatar didn't upload to Firebase: \(error.debugDescription)" )
                    return
                    
                } else {
                    print("Zhenya: UserAvatar successfully uploaded to Firebase")
                    
                    //getting the url to saved imageData to save it
                    let downloadUrl = metadata?.downloadURL()?.absoluteString
                    
                    if let url = downloadUrl {
                        self.avatarRef.setValue(downloadUrl)
                    }
                }
            }
        }
        
        view.endEditing(true)
        
        if userNameTextField.text != nil, genderTextField != nil, userPicImg.image != nil {
            performSegue(withIdentifier: "FeedVC", sender: nil)
        } else {
            let alertController = UIAlertController(title: "Please fill all fields", message: "don't forget about userpic", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                alertController.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
            
        }

    }
    
    @IBAction func signOutBtn(_ sender: Any) {
        
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("Zhenya: ID removed from keychain \(keychainResult)")
        
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
        
    }
    
}









