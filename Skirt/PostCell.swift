//
//  PostCell.swift
//  Skirt
//
//  Created by Evgeny Vlasov on 3/4/17.
//  Copyright © 2017 Evgeny Vlasov. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet weak var userAvatarImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var likeBtn: UIImageView!
    @IBOutlet weak var likesNumberLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var post: Post!
    var user: User!
    var likesRef: FIRDatabaseReference!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        activityIndicator.startAnimating()
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
                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
        }
        
        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        
        likesRef.observeSingleEvent(of: .value, with:  { (snapshot) in
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


    
    
    
    

}