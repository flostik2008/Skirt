//
//  CircleView.swift
//  Skirt
//
//  Created by Evgeny Vlasov on 3/7/17.
//  Copyright © 2017 Evgeny Vlasov. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let picImgBordeWidth: CGFloat = 1
        layer.cornerRadius = self.frame.width/2
                
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = picImgBordeWidth
        clipsToBounds = true
    }

}
