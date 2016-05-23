//
//  TLActivityIndicatorController.swift
//  TLProgressSpring-Swift
//
//  Created by Andrew on 16/5/23.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import TLProgressSpring_Swift

class TLActivityIndicatorController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.whiteColor()
        self.initView()
    }
    
    func initView() {
        
        let activity=TLActivityIndicatorView(frame: CGRectMake(100, 100, 100, 100))
        activity.animatorDuration=1
        self.view.addSubview(activity)
        activity.center=self.view.center
        
        activity.startAnimating()
        
    }
}
