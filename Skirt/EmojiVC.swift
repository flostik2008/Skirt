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
import GeoFire

class EmojiVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var viewForImgAndEmoji: UIView!
    
    @IBOutlet weak var mainImg: UIImageView!
    
    @IBOutlet weak var viewForSnapshot: UIView!
    
    
    var imageData: Data!
    var imageItself: UIImage!
    var currentUserPostRef: FIRDatabaseReference!
    var emojiImage: UIImage!
    var geoFire: GeoFire!
    
    var arrayOfEmojis = [UIImage]()
    var arrayOfEmojiViews = [UIImageView]()
    
    var n:Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if imageData != nil {
            let img = UIImage(data: imageData)
            let fixedImg = img!.fixOrientation(img: img!)
            
            mainImg.image = fixedImg
        } else if imageItself != nil {
            mainImg.image = imageItself
        }

        // get imageViews
        
        if arrayOfEmojiViews.count != 0 {
            for emojiView1 in arrayOfEmojiViews {
                viewForImgAndEmoji.addSubview(emojiView1)
              //  view.addSubview(emojiView1)
            }
        }
        
        
        // get image out of array.
        
        if arrayOfEmojis.count != 0 {
            for emoji in arrayOfEmojis {

                let emojiView = UIImageView(image: emoji)
                emojiView.tag = n
                emojiView.frame = CGRect(x: 153, y: 299, width: 70, height: 70)
                emojiView.isUserInteractionEnabled = true
                
                let pan = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(recognizer:)))
                pan.delegate = self
                viewForImgAndEmoji.addGestureRecognizer(pan)
                
                let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.handlePinch(recognizer:)))
                pinch.delegate = self
                viewForImgAndEmoji.addGestureRecognizer(pinch)
                
                let rotate = UIRotationGestureRecognizer(target: self, action: #selector(self.handleRotate(recognizer:)))
                rotate.delegate = self
                viewForImgAndEmoji.addGestureRecognizer(rotate)
                
                if viewForImgAndEmoji.viewWithTag(n) == nil {
                
                    viewForImgAndEmoji.addSubview(emojiView)
                }
                n += 1

             }
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {

        imageData = nil
    }
    

    @IBAction func cancelPic(_ sender: Any) {
        dismiss(animated: false, completion: nil)
        
    }
    @IBAction func addEmoji(_ sender: Any) {
        
        let img = mainImg.image
        performSegue(withIdentifier: "EmojiCollectionVC", sender: img)
    }

    @IBAction func postPic(_ sender: Any) {
        
        //create image out of the view 
        
        UIGraphicsBeginImageContextWithOptions(viewForSnapshot.bounds.size, viewForSnapshot.isOpaque, 0.0)
        viewForSnapshot.drawHierarchy(in: viewForSnapshot.bounds, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
      //  let img = mainImg.image
        
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
       
        
        geoFire = GeoFire(firebaseRef: DataService.ds.REF_LOCATION)
        
        // create user's current location. Get posts key
        
        let location = CLLocation(latitude: Location.sharedInstance.currentLatitude, longitude: Location.sharedInstance.currentLongitude)
        
        let postLocation = geoFire.setLocation(location, forKey: postKey)
        
        
        // also create a "posts" subnode in users. (take example from likes)
        currentUserPostRef = DataService.ds.REF_USER_CURRENT.child("posts").child(postKey)
        currentUserPostRef.setValue(true)
        
        performSegue(withIdentifier: "FromEmojiVCtoFeedVC", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if arrayOfEmojis.count != 0 {
            for j in 1...n {
                
                if var view1 = self.view.viewWithTag(j) as? UIImageView {
                    arrayOfEmojiViews.append(view1)
                }
            }
            
            print("Zhenya: in the viewWillDisappear arrayOfEmojiViews - \(arrayOfEmojiViews)")
        }

        if segue.identifier == "EmojiCollectionVC" {
            if let emojiCollection = segue.destination as? EmojiCollectionVC{
                if let image = sender as? UIImage {
                emojiCollection.userImage = image
                    
                    if arrayOfEmojis.count != 0 {
                      //arrayToStoreEmojis
                       emojiCollection.arrayToStoreEmojis = arrayOfEmojis
                       emojiCollection.arrayToStoreEmojiViews = arrayOfEmojiViews
                }
            }
          }
        }
    }
    
    @IBAction func handlePan(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.viewForImgAndEmoji)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.viewForImgAndEmoji)
    }
    
    @IBAction func handlePinch(recognizer: UIPinchGestureRecognizer) {
        
        let pinchPoint = recognizer.location(in: viewForImgAndEmoji)
        let ourEmojiView = viewForImgAndEmoji.hitTest(pinchPoint, with: nil)
        
        ourEmojiView!.transform = ourEmojiView!.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
        recognizer.scale = 1

    }
    
    @IBAction func handleRotate(recognizer: UIRotationGestureRecognizer){
        
        let rotatePoint = recognizer.location(in: viewForImgAndEmoji)
        let ourEmojiView = viewForImgAndEmoji.hitTest(rotatePoint, with: nil)
        
        ourEmojiView!.transform = ourEmojiView!.transform.rotated(by: recognizer.rotation)
        recognizer.rotation = 0
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
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















