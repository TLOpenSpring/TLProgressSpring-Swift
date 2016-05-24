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

    
    var activity:TLActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.whiteColor()
        self.initView()
    }
    
    func initView() {
        
        activity=TLActivityIndicatorView(frame: CGRectMake(100, 100, 100, 100))
        activity.animatorDuration=1
        self.view.addSubview(activity)
        activity.center=self.view.center
        
        activity.startAnimating()
        
        
        var rect = CGRectMake(0, 70, ScreenWIDTH, 40);
        var btn:UIButton = UIButton (frame: rect)
        btn.setTitleColor(UIColor.redColor(), forState: .Normal)
        btn.setTitle("显示出来", forState: .Normal)
        btn.backgroundColor=UIColor.groupTableViewBackgroundColor()
        btn.addTarget(self, action: #selector(show(_:)), forControlEvents: .TouchUpInside)
        btn.showsTouchWhenHighlighted=true
        self.view.addSubview(btn)
        
        rect = CGRectMake(0, CGRectGetMaxY(btn.frame)+10, ScreenWIDTH, 40);
        btn = UIButton (frame: rect)
        btn.setTitleColor(UIColor.redColor(), forState: .Normal)
        btn.setTitle("改变颜色", forState: .Normal)
        btn.backgroundColor=UIColor.groupTableViewBackgroundColor()
        btn.addTarget(self, action: #selector(changeColor(_:)), forControlEvents: .TouchUpInside)
        btn.showsTouchWhenHighlighted=true
        self.view.addSubview(btn)
    }
    
    
    
    
    func show(sender:AnyObject) -> Void {
     activity.startAnimating()
    }
    func changeColor(sender:AnyObject) -> Void {
        activity.tintColor=UIColor().randomColor()
    }
}













