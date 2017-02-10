//
//  ViewController.swift
//  Skirt
//
//  Created by Evgeny Vlasov on 2/7/17.
//  Copyright © 2017 Evgeny Vlasov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var gradientView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        gradientForDitailsVC(color: UIColor.clear, view: gradientView)
    }
    
    func gradientForDitailsVC(color: UIColor, view: UIView) {
        let gradient = CAGradientLayer()
        
        let gradientOrigin = view.bounds.origin
//        let gradientWidth = UIScreen.main.bounds.width
        let gradientWidth = view.bounds.width
        let gradientHeight = view.bounds.height
        let gradientSize = CGSize(width: gradientWidth, height: gradientHeight)
        gradient.frame = CGRect(origin: gradientOrigin, size: gradientSize)
        
        let bottomColor = UIColor(red:0.07, green:0.07, blue:0.07, alpha:0.5)
        gradient.colors = [color.cgColor, bottomColor.cgColor]
        
        view.layer.insertSublayer(gradient, at: 0)
    }
}
