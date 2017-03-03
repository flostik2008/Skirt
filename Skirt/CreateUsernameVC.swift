//
//  CreateUsernameVC.swift
//  Skirt
//
//  Created by Evgeny Vlasov on 2/28/17.
//  Copyright © 2017 Evgeny Vlasov. All rights reserved.
//

import UIKit
import Firebase

class CreateUsernameVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var genderPickerTextField: UITextField!
    @IBOutlet weak var userpicImg: UIImageView!
    
    var genderPicker = UIPickerView()
    let genders = ["female", "male", "gender fluid"]
    
    var imagePicker: UIImagePickerController!
    var usernameRef: FIRDatabaseReference!
    var genderRef: FIRDatabaseReference!
    var avatarRef: FIRDatabaseReference!
    var avatarUrl: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genderPicker.delegate = self
        genderPicker.dataSource = self
        genderPickerTextField.inputView = genderPicker
        
        let userpicImgBordeWidth: CGFloat = 1
        userpicImg.layer.cornerRadius = userpicImg.frame.size.width/2
        userpicImg.layer.borderColor = UIColor.darkGray.cgColor
        userpicImg.layer.borderWidth = userpicImgBordeWidth
        userpicImg.clipsToBounds = true
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        usernameRef = DataService.ds.REF_USER_CURRENT.child("username")
        usernameRef.observe(.value, with:{ (snapshot) in
            let snapshotValue = snapshot.value as? String
            
            
            if snapshotValue != nil || snapshotValue != "" {
                self.usernameTextField.text = snapshotValue
            }
        })
        
        genderRef = DataService.ds.REF_USER_CURRENT.child("gender")
        genderRef.observe(.value, with:{ (snapshot) in
            let snapshotValue = snapshot.value as? String
            
            if snapshotValue != nil || snapshotValue != "" {
                self.genderPickerTextField.text = snapshotValue
            }
        })

        avatarRef = DataService.ds.REF_USER_CURRENT.child("avatarUrl")
        avatarRef.observe(.value, with:{(snapshot) in
            
            let snapshotValue = snapshot.value as? String
            if snapshotValue != nil {
                FIRStorage.storage().reference(forURL: snapshotValue!).data(withMaxSize: 25*1024*1024, completion: {(data, error) -> Void
                    in
                    let image = UIImage(data: data!)
                    self.userpicImg.image = image!
                })
            }
        })
        
        
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
    
    
    @IBAction func chooseUserPicBtn(_ sender: Any) {
    
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
            userpicImg.image = image
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        
        //username:
        usernameRef = DataService.ds.REF_USER_CURRENT.child("username")
        
        if let userName = usernameTextField.text, userName != "" {
            
            print("Zhenya: Successfully saved username to FireBase")
            usernameRef.setValue(userName)
            
        } else {
            print("Zhenya: No caption was enetered")
            // show alert view "username/gender/userpic are required"

        }
        
        //gender
        genderRef = DataService.ds.REF_USER_CURRENT.child("gender")
        
        if let gender = genderPickerTextField.text, gender != "" {
        
            print("Zhenya: Successfully saved gender to Firebase")
            genderRef.setValue(gender)
        } else {
            print("Zhenya: no gender was chosen")
        }
        
        
        //userpic url:
        avatarRef = DataService.ds.REF_USER_CURRENT.child("avatarUrl")
        
        guard let img = userpicImg.image else {
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
        
        if usernameTextField.text != nil, genderPickerTextField != nil, userpicImg.image != nil {
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
}























