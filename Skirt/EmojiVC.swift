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
    
    var imageData: Data!
    var imageItself: UIImage!
    var currentUserPostRef: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // create image out of Data, set mainImg. 
        if imageData != nil {
            let img = UIImage(data: imageData)
            mainImg.image = img
        } else if imageItself != nil {
            mainImg.image = imageItself
        }
    }

    @IBAction func cancelPic(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func addEmoji(_ sender: Any) {
        
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
        // need to tableView.reloadData() somewhere after this. 
        
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
}














