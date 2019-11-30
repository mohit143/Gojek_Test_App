//
//  GKGradientView.swift
//  Go-jekContactsApp
//
//  Created by Mohit Mathur on 24/11/19.
//  Copyright © 2019 Mohit Mathur. All rights reserved.
//

import Foundation
import UIKit
class GKGradientView: UIView {
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //setting gradient color of the view
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [UIColor.init(named: "WhiteDarkModeColor")!.cgColor,UIColor.init(named: "ThemeColor")!.cgColor]
    }
}
