//
//  TLNavProgressController.swift
//  TLProgressSpring-Swift
//
//  Created by Andrew on 16/5/24.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import TLProgressSpring_Swift


class TLNavProgressController: UIViewController {
    
    var progress:Float=0
    
    var navProgrss:TLNavProgressView!;

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.whiteColor()
         initView()
    }
    
    func initView() -> Void {
        navProgrss = TLNavProgressView.progressViewforNavigationController(self.navigationController!);
        navProgrss.progressTintColor=UIColor.redColor()
        navProgrss.setProgressAnimator(0, animated: true)
        var rect = CGRectMake(30, 100, ScreenWIDTH-30*2, 40)
        var button:UIButton=UIButton(frame: rect)
        button.setTitle("点击增加进度", forState: .Normal)
        button.backgroundColor=UIColor.groupTableViewBackgroundColor()
        button.setTitleColor(UIColor.redColor(), forState: .Normal)
        button.addTarget(self, action: #selector(btnClick(_:)), forControlEvents:.TouchUpInside)
        self.view.addSubview(button)
        
        
        rect = CGRectMake(30, CGRectGetMaxY(button.frame)+10, ScreenWIDTH-30*2, 40)
        button=UIButton(frame: rect)
        button.setTitle("改变进度条颜色", forState: .Normal)
        button.backgroundColor=UIColor.groupTableViewBackgroundColor()
        button.setTitleColor(UIColor.redColor(), forState: .Normal)
        button.addTarget(self, action: #selector(chanageClick(_:)), forControlEvents:.TouchUpInside)
        self.view.addSubview(button)
    }
    
    
    func btnClick(sender:AnyObject) -> Void {
        progress+=0.2;
        if(progress>=1.2){
            progress=0;
        }
        
        navProgrss.setProgressAnimator(progress, animated: true)
    }
    func chanageClick(sender:AnyObject) -> Void {
        navProgrss.progressTintColor = UIColor().randomColor()
    }
}
