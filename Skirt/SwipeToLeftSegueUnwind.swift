//
//  SwipeToLeftSegueUnwind.swift
//  Skirt
//
//  Created by Evgeny Vlasov on 3/7/17.
//  Copyright © 2017 Evgeny Vlasov. All rights reserved.
//

import UIKit

class SwipeToLeftSegueUnwind: UIStoryboardSegue {
    
    override func perform() {
        
        var postPicVCView = self.source.view as UIView!
        var feedVCView = self.destination.view as UIView!
        
        let screenWidth = UIScreen.main.bounds.size.width
        
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(feedVCView!, aboveSubview: postPicVCView!)
        
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            //feedVCView.frame = CGRectOffset(firstVCView.frame, 0.0, screenHeight)
            
            feedVCView!.frame = feedVCView!.frame.offsetBy(dx: screenWidth, dy: 0.0)
            
            //postPicVCView.frame = CGRectOffset(secondVCView.frame, 0.0, screenHeight)
            
            postPicVCView!.frame = postPicVCView!.frame.offsetBy(dx: screenWidth, dy: 0.0)
            
            
        }) { (Finished) -> Void in
            
            self.source.dismiss(animated: false, completion: nil)
        }
        
        
    }
}
