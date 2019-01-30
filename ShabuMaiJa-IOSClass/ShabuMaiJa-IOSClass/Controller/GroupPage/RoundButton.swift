//
//  RoundButton.swift
//  ShabuMaiJa-IOSClass
//
//  Created by Kanon Limprapaipong on 2/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit
@IBDesignable class RoundButton: UIButton{
    @IBInspectable var cornerRadius: CGFloat = 15 {
        didSet {
            refreshCorners(value: cornerRadius)
        }
    }
    override init(frame: CGRect){
        super.init(frame: frame)
        sharedInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    func sharedInit(){
        refreshCorners(value: cornerRadius)
    }
    func refreshCorners(value: CGFloat){
        layer.cornerRadius = value
    }
}
