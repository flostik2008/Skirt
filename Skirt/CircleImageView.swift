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
        
        print("Zhenya: width is \(self.frame.width), hight is \(self.frame.height) ")
        
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = picImgBordeWidth
        clipsToBounds = true
    }

}
