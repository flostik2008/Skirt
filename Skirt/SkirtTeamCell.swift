//
//  SkirtTeamCell.swift
//  Skirt
//
//  Created by Evgeny Vlasov on 4/18/17.
//  Copyright © 2017 Evgeny Vlasov. All rights reserved.
//

import UIKit

class SkirtTeamCell: UITableViewCell {
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let x = Int(arc4random_uniform(6)+1)

    
    func configureCell(_ temp: Int, rainChance: Int){
        
        // configure pic based on returned temperature.
        // remove last character from temperature.
        
       // let currentTempJustDigits = temp.substring(to: temp.index(before: temp.endIndex))
       // let currentTempAsDouble = Int(currentTempJustDigits)
        
        print("Zhenya: temperature is \(temp)")

        if temp >= 74 {
            if rainChance >= 55 {
                self.postImage.image = UIImage(named:"17w")
            }
            else {
                self.postImage.image = UIImage(named:"1\(x)w")
            }
        } else if temp < 74 && temp >= 62{
            
            if rainChance >= 55{
                self.postImage.image = UIImage(named:"27w")
            }
            else {
                self.postImage.image = UIImage(named: "2\(x)w")
            }
            
        } else if temp < 62 && temp >= 53{
            
            if rainChance >= 55 {
                self.postImage.image = UIImage(named:"37w")
            }
            else {
                self.postImage.image = UIImage(named:"3\(x)w")
            }
            
        } else if temp < 53 && temp >= 41{
            
            if rainChance >= 55{
                self.postImage.image = UIImage(named:"47w")
            }
            else {
                self.postImage.image = UIImage(named:"4\(x)w")
            }
            
        } else if temp < 41 && temp >= 32{
            
            if rainChance >= 55{
                self.postImage.image = UIImage(named:"57w")
            }
            else {
                self.postImage.image = UIImage(named:"5\(x)w")
            }
        } else if temp < 32 && temp >= 19{
            self.postImage.image = UIImage(named:"6\(x)w")
        } else if temp < 19 && temp >= 5{
            self.postImage.image = UIImage(named:"7\(x)w")
        } else if temp < 5  && temp > -50 {
            self.postImage.image = UIImage(named:"8w")
        } else if temp == -50 {
            return
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        activityIndicator.startAnimating()
        
    }
    
    override func prepareForReuse() {
        
        // set the image to a preset, generic one.
        postImage.image = UIImage(named: "preimage.jpg")
        
    }
    
}



