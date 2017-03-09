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
        var sourceVCView = self.source.view as UIView!
        var destinationVCView = self.destination.view as UIView!
        
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        destinationVCView?.frame = CGRect(x: screenWidth, y: 0.0, width: screenWidth, height: screenHeight)
        
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(destinationVCView!, aboveSubview: sourceVCView!)
        
        
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            sourceVCView!.frame = sourceVCView!.frame.offsetBy(dx: -screenWidth, dy: 0.0)
            destinationVCView!.frame = destinationVCView!.frame.offsetBy(dx: -screenWidth, dy: 0.0)
            
        }) { (Finished) -> Void in
            self.source.present(self.destination as UIViewController,
                                                            animated: false,
                                                            completion: nil)
        }
        
    }
    
}
