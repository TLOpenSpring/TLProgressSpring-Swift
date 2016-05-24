//
//  TLCircleController.swift
//  TLProgressSpring-Swift
//
//  Created by Andrew on 16/5/24.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import TLProgressSpring_Swift

class TLCircleController: UIViewController {
    
    var circleProgress:TLCircleProgressView!
    
    var progress:Float=0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.whiteColor()
        initView()
    }
    
    func initView() -> Void {
        
        var rect = CGRectMake(100, 100, 100, 100)
        
        circleProgress = TLCircleProgressView(frame: rect)
        self.view.addSubview(circleProgress)
        circleProgress.animationDuration = 1
        circleProgress.setProgressAnimator(0.9, animated: true)
        
        
        rect = CGRectMake(30, CGRectGetMaxY(circleProgress.frame)+20, ScreenWIDTH-30*2, 40)
        var button:UIButton=UIButton(frame: rect)
        button.setTitle("change", forState: .Normal)
        button.backgroundColor=UIColor.groupTableViewBackgroundColor()
        button.setTitleColor(UIColor.redColor(), forState: .Normal)
        button.addTarget(self, action: #selector(changeValue(_:)), forControlEvents:.TouchUpInside)
        self.view.addSubview(button)
        
        
    }
    
    
    func changeValue(sender:AnyObject) -> Void {
        if(progress==1){
            progress=0
        }else{
            progress=1;
        }
        
        circleProgress.setProgressAnimator(progress, animated: true)
    }
}
