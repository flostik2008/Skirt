//
//  userLooksCell.swift
//  Skirt
//
//  Created by Evgeny Vlasov on 3/10/17.
//  Copyright © 2017 Evgeny Vlasov. All rights reserved.
//

import UIKit

class UserLooksCell: UICollectionViewCell {
    
    @IBOutlet weak var userLookImg: UIImageView!
    
    func configureCell(image: UIImage) {
    
        userLookImg.image = image
    }    
    
}
