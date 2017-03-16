//
//  EmojiCollectionCell.swift
//  Skirt
//
//  Created by Evgeny Vlasov on 3/16/17.
//  Copyright © 2017 Evgeny Vlasov. All rights reserved.
//

import UIKit

class EmojiCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var emojiView: UIImageView!
    
    func configureCell(image: UIImage) {
        emojiView.image = image
    }
}
