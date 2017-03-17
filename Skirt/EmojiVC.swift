//
//  EmojiVC.swift
//  Skirt
//
//  Created by Evgeny Vlasov on 3/7/17.
//  Copyright © 2017 Evgeny Vlasov. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class EmojiVC: UIViewController {

    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var emojiImageView: UIImageView!
    
    var imageData: Data!
    var imageItself: UIImage!
    var currentUserPostRef: FIRDatabaseReference!
    var emojiImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if imageData != nil {
            let img = UIImage(data: imageData)
            print("Zhenya:5 - here is background image \(img)")
            
            let fixedImg = img!.fixOrientation(img: img!)
            
            mainImg.image = fixedImg
        } else if imageItself != nil {
            mainImg.image = imageItself
        }
        
        if emojiImage != nil {
            emojiImageView.image = emojiImage
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        imageData = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
//        if imageData != nil {
//            let img = UIImage(data: imageData)
//            print("Zhenya:5 - here is background image \(img)")
//            
//            let fixedImg = img!.fixOrientation(img: img!)
//            
//            mainImg.image = fixedImg
//        } else if imageItself != nil {
//            mainImg.image = imageItself
//        }
//        
//        if emojiImage != nil {
//            emojiImageView.image = emojiImage
//        }
    }

    @IBAction func cancelPic(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func addEmoji(_ sender: Any) {
        
        // create code to pass user image as sender: 
        let img = mainImg.image
        performSegue(withIdentifier: "EmojiCollectionVC", sender: img)
        
    }
    @IBAction func postPic(_ sender: Any) {
        
        let img = mainImg.image
        if let imageToData = UIImageJPEGRepresentation(img!, 0.2) {
            
            let imgUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataService.ds.REF_POST_IMAGES.child(imgUid).put(imageToData, metadata: metadata) {(metadata, error) in
                if error != nil {
                    print("Zhenya: Image didn't upload to Firebase")
                } else {
                    print("Zhenya: Image successfully uploaded to Firebase")
                    let downloadUrl = metadata?.downloadURL()?.absoluteString
                    
                    if let url = downloadUrl {
                        
                        self.postToFirebase(imgUrl: url)
                    }
                }
            }
        }
    }
    
    func postToFirebase(imgUrl: String) {

        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        
        let post: Dictionary<String, Any> = [
            "imageUrl": imgUrl,
            "likes": 0,
            "userKey": uid!,
            ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        // get posts autoID that was just generated.
        let postKey = firebasePost.key
        
        // also create a "posts" subnode in users. (take example from likes)
        currentUserPostRef = DataService.ds.REF_USER_CURRENT.child("posts").child(postKey)
        currentUserPostRef.setValue(true)
        
        performSegue(withIdentifier: "FromEmojiVCtoFeedVC", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "EmojiCollectionVC" {
        if let emojiCollection = segue.destination as? EmojiCollectionVC{
            if let image = sender as? UIImage {
                emojiCollection.userImage = image
            }
          }
        }
    }
}

extension UIImage {
    func normalizedImage() -> UIImage {
        
        if (self.imageOrientation == UIImageOrientation.up) {
            return self;
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        self.draw(in: rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return normalizedImage;
    }
    
    func fixOrientation(img:UIImage) -> UIImage {
        
        if (img.imageOrientation == UIImageOrientation.up) {
            return img;
        }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale);
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return normalizedImage;
    }
}















