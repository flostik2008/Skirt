//
//  SwipeToRightSegue.swift
//  Skirt
//
//  Created by Evgeny Vlasov on 3/14/17.
//  Copyright © 2017 Evgeny Vlasov. All rights reserved.
//

import UIKit

class SwipeToRightSegue: UIStoryboardSegue {

    override func perform() {
        var feedVCView = self.source.view as UIView!
        var userVCView = self.destination.view as UIView!
        
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        userVCView?.frame = CGRect(x: -screenWidth, y: 0.0, width: screenWidth, height: screenHeight)
        
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(userVCView!, aboveSubview: feedVCView!)
        
        
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            feedVCView!.frame = feedVCView!.frame.offsetBy(dx: screenWidth, dy: 0.0)
            userVCView!.frame = userVCView!.frame.offsetBy(dx: screenWidth, dy: 0.0)
            
        }) { (Finished) -> Void in
            self.source.present(self.destination as UIViewController,
                                animated: false,
                                completion: nil)
        }
        
    }

}
