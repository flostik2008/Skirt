
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
    
    var userPosts = [Post]()
    var userLooks = [UIImage] ()
    var usersPosts = [String] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        // getting user info from FB
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
                self.userNameLbl.text = userName
            }
        })
        
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
        
         let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
         let width = UIScreen.main.bounds.width
         layout.itemSize = CGSize(width: width / 3 - 2 , height: width / 3 - 2)
         layout.minimumInteritemSpacing = 3
         layout.minimumLineSpacing = 3
         collectionView!.collectionViewLayout = layout
        
        let leftSwipeGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(UserVC.showFeedVC))
        leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(leftSwipeGestureRecognizer)
        
        addGradient(color: UIColor.clear, view: gradientView)
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
    
    @IBAction func editUserBtn(_ sender: Any) {
        
        self.performSegue(withIdentifier: "EditUserVC", sender: nil)
    }
    
    func showFeedVC() {
        performSegue(withIdentifier: "customSegueToUserVCUnwind", sender: self)
    }
    
    func addGradient(color: UIColor, view: UIView) {
        let gradient = CAGradientLayer()
        
        let gradientOrigin = view.bounds.origin
        let huy = UIScreen.main.bounds.width
        let gradientSize = CGSize(width: huy, height: CGFloat(79))
        gradient.frame = CGRect(origin: gradientOrigin, size: gradientSize)
        
        let bottomColor = UIColor(red:0.07, green:0.07, blue:0.07, alpha:0.9)
        gradient.colors = [color.cgColor, bottomColor.cgColor]
        
        view.layer.insertSublayer(gradient, at: 0)
    }
}










