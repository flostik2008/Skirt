//
//  EmojiCollectionVC.swift
//  Skirt
//
//  Created by Evgeny Vlasov on 3/16/17.
//  Copyright © 2017 Evgeny Vlasov. All rights reserved.
//

import UIKit

class EmojiCollectionVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var emojiCollection: UICollectionView!
    
    var userImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImage.image = userImage
        
        emojiCollection.delegate = self
        emojiCollection.dataSource = self
        emojiCollection.backgroundColor = UIColor.clear
        emojiCollection.backgroundView = UIView(frame: CGRect.zero)
        
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backgroundImage.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundImage.addSubview(blurEffectView)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: width / 5 - 2 , height: width / 5 - 2)
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        emojiCollection!.collectionViewLayout = layout
        
        emojiCollection.reloadData()
    }

    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: false, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as! EmojiCollectionCell
        let img = UIImage(named: "\(indexPath.row + 1)")
        cell.configureCell(image: img!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 144
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! EmojiCollectionCell
        let chosenEmoji = cell.emojiView.image as UIImage!
        performSegue(withIdentifier: "backToEmojiVC", sender: chosenEmoji)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToEmojiVC"{

            if let destinationVC = segue.destination as? EmojiVC {
                if let emoji = sender as? UIImage {
                
                  //  destinationVC.emojiImage = emoji
                    destinationVC.arrayOfEmojis.append(emoji)
                    let data = UIImagePNGRepresentation(userImage)
                    destinationVC.imageData = data
            }
        }
    }
    }
}















