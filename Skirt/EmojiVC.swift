//
//  EmojiVC.swift
//  Skirt
//
//  Created by Evgeny Vlasov on 3/7/17.
//  Copyright © 2017 Evgeny Vlasov. All rights reserved.
//

import UIKit

class EmojiVC: UIViewController {

    @IBOutlet weak var mainImg: UIImageView!
    
    var imageData: Data! 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // create image out of Data, set mainImg. 
        let img = UIImage(data: imageData)
        mainImg.image = img 
    }

    @IBAction func cancelPic(_ sender: Any) {
    }
    @IBAction func addEmoji(_ sender: Any) {
        
    }
    @IBAction func postPic(_ sender: Any) {
    }
}
