//
//  SwipeToLeftSegue.swift
//  Skirt
//
//  Created by Evgeny Vlasov on 3/7/17.
//  Copyright © 2017 Evgeny Vlasov. All rights reserved.
//

import UIKit

class SwipeToLeftSegue: UIStoryboardSegue {

    override func perform() {
        var feedVCView = self.source.view as UIView!
        var postPicVCView = self.destination.view as UIView!
        
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        postPicVCView?.frame = CGRect(x: screenWidth, y: 0.0, width: screenWidth, height: screenHeight)
        
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(postPicVCView!, aboveSubview: feedVCView!)
        
        
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            feedVCView!.frame = feedVCView!.frame.offsetBy(dx: -screenWidth, dy: 0.0)
            postPicVCView!.frame = postPicVCView!.frame.offsetBy(dx: -screenWidth, dy: 0.0)
            
        }) { (Finished) -> Void in
            self.source.present(self.destination as UIViewController,
                                                            animated: false,
                                                            completion: nil)
        }
        
    }
    
}
