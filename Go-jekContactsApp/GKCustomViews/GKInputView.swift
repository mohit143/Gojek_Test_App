//
//  GKInputView.swift
//  Go-jekContactsApp
//
//  Created by Mohit Mathur on 25/11/19.
//  Copyright © 2019 Mohit Mathur. All rights reserved.
//

import UIKit

@IBDesignable
open class GKInputView: UITextField {
    var inputLabel : UILabel?
    
    @IBInspectable open var labelText : String? {
        didSet{
            inputLabel?.text = labelText
        }
    }

    func setup() {
        //creating padding view for textfield
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 162 * K.appCONSTANT.kScreenSizeRatioWidth, height: self.frame.size.height))
         inputLabel = UILabel(frame: CGRect(x: 0, y: 0, width: paddingView.frame.width - 32, height: paddingView.frame.height))
        inputLabel!.textAlignment = .right
        inputLabel?.font = UIFont.systemFont(ofSize: 15 * K.appCONSTANT.kScreenSizeRatioWidth)
        inputLabel?.textColor = UIColor.colorWithHexString(hexStr: K.GK_ColorTheme.inputHeadingBlack, reqAlpha: 0.5)
        paddingView.addSubview(inputLabel!)
        self.leftView = paddingView
        self.leftViewMode = .always
        }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override open func awakeFromNib() {
        super.awakeFromNib()
    }
}
