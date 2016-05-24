//
//  ColorUtil.swift
//  TLProgressSpring-Swift
//
//  Created by Andrew on 16/5/24.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit

class ColorUtil: NSObject {

}

extension UIColor{

    public func randomColor() -> UIColor{
      
        let r:CGFloat = CGFloat(arc4random() % 255);
        let g:CGFloat = CGFloat(arc4random() % 255);
        let b:CGFloat = CGFloat(arc4random() % 255);
        
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
    }
}
