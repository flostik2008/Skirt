//
//  PostCell.swift
//  Skirt
//
//  Created by Evgeny Vlasov on 3/4/17.
//  Copyright © 2017 Evgeny Vlasov. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class PostCell: UITableViewCell {

    @IBOutlet weak var userAvatarImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var likeBtn: UIImageView!
    @IBOutlet weak var likesNumberLbl: UILabel!
    @IBOutlet weak var flagBtn: UIImageView!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var timeLbl: UILabel!
    
    var post: Post!
    var user: User!
    var currentUserLikesRef: FIRDatabaseReference!
    var currentFlagRef: FIRDatabaseReference!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        activityIndicator.startAnimating()
        
        let like = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        like.numberOfTapsRequired = 1
        likeBtn.addGestureRecognizer(like)
        likeBtn.isUserInteractionEnabled = true
        
        let flag = UITapGestureRecognizer(target: self, action: #selector(flagTapped))
        flag.numberOfTapsRequired = 1
        flagBtn.addGestureRecognizer(flag)
        flagBtn.isUserInteractionEnabled = true
        
    }
    
    func configureCell(user: User, post: Post, img:UIImage? = nil) {
    
        self.post = post
        self.likesNumberLbl.text = "\(post.likes)"
        
        if img != nil {
            self.postImg.image = img
        } else {
            let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
            ref.data(withMaxSize: 2*1024*1024, completion: { (data, error) in
                if error != nil {
                    print("Zhenya: Unable to download images from Firebase storage")
                } else {
                    print("Zhenya: Successfully downloaded images from Firebase storage")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postImg.image = img
                            MainFeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
        }
        
        // time calculation
        let serverUnixTime = TimeInterval(post.date)/1000
        let clientUnixTime = Date().timeIntervalSince1970
        let difference = clientUnixTime - serverUnixTime
        let result = Int(difference)
        let finalResult = result/60/60
        timeLbl.text = String("(\(finalResult)hrs)")
        
        currentUserLikesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)

        currentFlagRef = DataService.ds.REF_POSTS.child(post.postKey).child("flag")
        
        currentUserLikesRef.observeSingleEvent(of: .value, with:  { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeBtn.image = UIImage(named: "empty-heart")
            } else {
                self.likeBtn.image = UIImage(named: "filled-heart")
            }
        })

        self.user = user
        self.userNameLbl.text = user.userName
        let ref = FIRStorage.storage().reference(forURL: user.avatarUrl)
        ref.data(withMaxSize: 2*1024*1024, completion: { (data, error) in
            if error != nil {
                print("Zhenya: Unable to download user avatar from FireB storage")
                
            } else {
                print("Zhenya: Successfully downloaded user avater from FireB storage")
                
                if let imgData = data {
                    if let img = UIImage(data: imgData) {
                        self.userAvatarImg.image = img
                    }
                }
            }
        })    
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        
        currentUserLikesRef.observeSingleEvent(of: .value, with:  { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeBtn.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: true)
                self.currentUserLikesRef.setValue(true)
            } else {
                self.likeBtn.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.currentUserLikesRef.removeValue()
            }
        })
    }
    
    func flagTapped(sender: UITapGestureRecognizer) {
        
        let alertController = UIAlertController(title: "Flag", message: "Flag this post as \"not an outfit\" or as \"inappropriate\".", preferredStyle: UIAlertControllerStyle.alert)
      
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            (result : UIAlertAction) -> Void in
        }
        
        let flaggingAction = UIAlertAction(title: "Flag", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in

            self.currentFlagRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let _ = snapshot.value as? NSNull {
                    
                    //take userkey here, save it to the branch. 
                    let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
                    self.currentFlagRef.child(uid!).setValue(true)
                    
                    // this will always be true, because our 'currentFlagRef' goes to the child with key of current value. and it is nil. 
                    // instead, we need to have currentFlagRef one level up. so
                    
                } else {
    
                    let uid = KeychainWrapper.standard.string(forKey: KEY_UID)

                    print("Zhenya: snapshot.key is \(snapshot.key)")
                    print("Zhenya: snapshot.value is \(snapshot.value)")

                    // right now, we quering FB to posts/postID/flag and snapshot returns a single dict. not a value. How to get to the snapshots only child and get name of the key? we had similar problem in viewDidAppear when rebuilding posts.
                    if let flagDict = snapshot.value as? Dictionary<String, AnyObject> {
                        let firstKey = Array(flagDict.keys)[0]
                        if firstKey == uid{
                            //show a window "we are working on reviewing this post"
                            
                            let alertController = UIAlertController(title: "Got It", message: "Working on reviewing this post", preferredStyle: UIAlertControllerStyle.alert)
                            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel,     handler: nil)
                            alertController.addAction(cancelAction)
                            
                            let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                            alertWindow.rootViewController = UIViewController()
                            alertWindow.windowLevel = UIWindowLevelAlert + 1;
                            alertWindow.makeKeyAndVisible()
                            alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
                        } else {
                            print("Zhenya: If I see this, then snapshot.key != uid (new user leaving flag, should be deleted)")
                            
                            DataService.ds.REF_POSTS.child(self.post.postKey).removeValue()
                        }
                    }
                }
            })
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(flaggingAction)
         
         let alertWindow = UIWindow(frame: UIScreen.main.bounds)
         alertWindow.rootViewController = UIViewController()
         alertWindow.windowLevel = UIWindowLevelAlert + 1;
         alertWindow.makeKeyAndVisible()
         alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
        
    }
}

















