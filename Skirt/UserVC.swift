//
//  UserVC.swift
//  Skirt
//
//  Created by Evgeny Vlasov on 3/10/17.
//  Copyright © 2017 Evgeny Vlasov. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class UserVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var userPicImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var looksCountLbl: UILabel!
    @IBOutlet weak var followingCountLbl: UILabel!
    @IBOutlet weak var followersCountLbl: UILabel!
    
    var userPosts = [Post]()
    var userLooks = [UIImage] ()
    var usersPosts = [String] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        // getting user info from FB
        
        
        // getting users looks from FB (new way)
        DataService.ds.REF_USER_CURRENT.child("posts").observe(.value, with: { (snapshot) in
            if let arrayOfUsersPosts = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for dictionaryOfOnePost in arrayOfUsersPosts {
                    let key = dictionaryOfOnePost.key
                    self.usersPosts.append(key)
                    }
                
                //using posts keys from 'usersPosts' download posts from FB
                
                for postKey in self.usersPosts{
                    DataService.ds.REF_POSTS.child(postKey).observe(.value, with: { (snapshot) in
                        
                        var imageUrl: String!
                        if let postDict = snapshot.value as? Dictionary<String, AnyObject> {
                            imageUrl = postDict["imageUrl"] as! String
                            print("Zhenya: image url is \(imageUrl)")
                        }
                        let ref = FIRStorage.storage().reference(forURL: imageUrl)
                        
                        ref.data(withMaxSize: 2*1024*1024, completion: { (data, error) in
                            if error != nil {
                                print("Zhenya: Unable to download images from Firebase storage")
                            } else {
                                print("Zhenya: Successfully downloaded images from Firebase storage")
                                if let imgData = data {
                                    if let img = UIImage(data: imgData) {
                                        
                                        self.userLooks.append(img)
                                    }
                                }
                            }
                            self.collectionView.reloadData()

                        })
                    })
                }
                }
            }
        )
        
        
        // getting user looks from FB (old way)
        /*
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            self.userPosts = []
         
            if let arrayOfAllPosts = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for dictionaryOfOnePost in arrayOfAllPosts {
         
                    if let postDict = dictionaryOfOnePost.value as? Dictionary<String, AnyObject> {
                        let key = dictionaryOfOnePost.key
                        let post = Post(postKey: key, postData: postDict)
                        
                        // get current userUid. compare it to post's one. If yes, get the image.
                        let currentUserUid = KeychainWrapper.standard.string(forKey: KEY_UID)
                        if post.userKey == currentUserUid {
                            let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
                            
                            ref.data(withMaxSize: 2*1024*1024, completion: { (data, error) in
                                if error != nil {
                                    print("Zhenya: Unable to download images from Firebase storage")
                                } else {
                                    print("Zhenya: Successfully downloaded images from Firebase storage")
                                    if let imgData = data {
                                        if let img = UIImage(data: imgData) {
                                            
                                            self.userLooks.append(img)
                                            print("Zhnya: nevertheless \(img)")
                                        }
                                    }
                                }
                                self.collectionView.reloadData()

                            })
                        }
                    }
                }
            }
            self.userPosts.reverse()
        })
        */
        
        
         let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
         let width = UIScreen.main.bounds.width
         layout.itemSize = CGSize(width: width / 3 - 2 , height: width / 3 - 2)
         layout.minimumInteritemSpacing = 3
         layout.minimumLineSpacing = 3
         collectionView!.collectionViewLayout = layout
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         let singleLook = userLooks[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! UserLooksCell
        cell.configureCell(image: singleLook)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

      return userLooks.count
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    @IBAction func showFollowingBtn(_ sender: Any) {
    
    }
    
    
    @IBAction func showFollowersBtn(_ sender: Any) {
    
    }
    
    @IBAction func editUserBtn(_ sender: Any) {
    
    }
}










