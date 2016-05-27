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
        
        
        var rect = CGRectMake(100, 65, ScreenWIDTH-100,20)
        let lb:UILabel=UILabel(frame: rect)
        lb.text="每次点击进度增加20%"
        self.view.addSubview(lb)
        
        
        rect = CGRectMake(100, 100, 100, 100)
        
        circleProgress = TLCircleProgressView(frame: rect)
        self.view.addSubview(circleProgress)
        circleProgress.animationDuration=1
        circleProgress.setCurrentProgress(0)
        
        rect = CGRectMake(30, CGRectGetMaxY(circleProgress.frame)+20, ScreenWIDTH-30*2, 40)
        var button:UIButton=UIButton(frame: rect)
        button.setTitle("带有动画效果", forState: .Normal)
        button.backgroundColor=UIColor.groupTableViewBackgroundColor()
        button.setTitleColor(UIColor.redColor(), forState: .Normal)
        button.addTarget(self, action: #selector(changeValue(_:)), forControlEvents:.TouchUpInside)
        self.view.addSubview(button)
        
        
        rect=CGRectMake(30, CGRectGetMaxY(button.frame)+10, button.frame.size.width, 40)
        button=UIButton(frame: rect)
        button.setTitle("没有动画效果", forState: .Normal)
        button.backgroundColor=UIColor.groupTableViewBackgroundColor()
        button.setTitleColor(UIColor.redColor(), forState: .Normal)
        button.addTarget(self, action: #selector(changeValueNoAnimator(_:)), forControlEvents:.TouchUpInside)
        self.view.addSubview(button)
        
        rect=CGRectMake(30, CGRectGetMaxY(button.frame)+10, button.frame.size.width, 40)
        button=UIButton(frame: rect)
        button.setTitle("点击一次自动增加", forState: .Normal)
        button.backgroundColor=UIColor.groupTableViewBackgroundColor()
        button.setTitleColor(UIColor.redColor(), forState: .Normal)
        button.addTarget(self, action: #selector(autoChanage), forControlEvents:.TouchUpInside)
        self.view.addSubview(button)
        
    }
    
    
    func changeValue(sender:AnyObject) -> Void {
        progress+=0.2;
        if(progress>=1){
            progress=0;
        }
        circleProgress.setProgress(progress, animated: true)

    }
    func changeValueNoAnimator(sender:AnyObject) -> Void {
        progress+=0.2;
        if(progress>=1){
            progress=0;
        }
      circleProgress.setCurrentProgress(progress);
    }
    func autoChanage() -> Void {
        self.circleProgress.setCurrentProgress(0)
        simulateValue()
    }
    
    
    func simulateValue() -> Void {
        performBlock(0.5) {
            self.circleProgress.setProgress(0.4, animated: true)
            self.performBlock(0.8, completionHander: {
                self.circleProgress.setProgress(0.6, animated: true)
                self.performBlock(1.5, completionHander: {
                    self.circleProgress.setProgress(0.8, animated: true)
                    self.performBlock(1, completionHander: {
                        self.circleProgress.setProgress(1, animated: true)
                    })
                })
            })
        }
    }
    
    func performBlock(delay:NSTimeInterval,completionHander:()->()) -> Void {
        
        let popTime = dispatch_time(DISPATCH_TIME_NOW,
                                    Int64(delay * Double(NSEC_PER_SEC))) // 1
        
       
        dispatch_after(popTime, dispatch_get_main_queue(), completionHander);
    }
}



