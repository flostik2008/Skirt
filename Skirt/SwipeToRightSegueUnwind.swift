//
//  SwipeToRightSegueUnwind.swift
//  Skirt
//
//  Created by Evgeny Vlasov on 3/14/17.
//  Copyright © 2017 Evgeny Vlasov. All rights reserved.
//

import UIKit

class SwipeToRightSegueUnwind: UIStoryboardSegue {
    
    override func perform() {
        
        var userVCView = self.source.view as UIView!
        var feedVCView = self.destination.view as UIView!
        
        let screenWidth = UIScreen.main.bounds.size.width
        
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(feedVCView!, aboveSubview: userVCView!)
        
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            
            feedVCView!.frame = feedVCView!.frame.offsetBy(dx: -screenWidth, dy: 0.0)
            userVCView!.frame = userVCView!.frame.offsetBy(dx: -screenWidth, dy: 0.0)
            
        }) { (Finished) -> Void in
            
            self.source.dismiss(animated: false, completion: nil)
        }
        
        
    }


}
