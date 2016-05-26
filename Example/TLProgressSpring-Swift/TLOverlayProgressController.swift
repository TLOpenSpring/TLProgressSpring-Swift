//
//  TLOverlayProgressController.swift
//  TLProgressSpring-Swift
//
//  Created by Andrew on 16/5/26.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import TLProgressSpring_Swift


class TLOverlayProgressController: UIViewController {
    
    var overlayProgress:TLOverlayProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.whiteColor()
        initView()
        
        
        let showItem = UIBarButtonItem(title: "显示", style: .Plain, target: self, action: #selector(show));
        
        self.navigationItem.rightBarButtonItem=showItem
        
    }
    
    
    func show() {
        self.overlayProgress.showAnimated(true)
        performBlock(2) {
            self.overlayProgress.hideAnimated(true)
        }
    }
    
    func initView() -> Void {
        overlayProgress = TLOverlayProgressView(parentView: self.view, animated: true)
      
        
        performBlock(2) { 
            self.overlayProgress.hideAnimated(true)
        }
    }
    
    func performBlock(delay:NSTimeInterval,completionHander:()->()) -> Void {
        let time:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delay) * Int64(NSEC_PER_SEC));
        dispatch_after(time, dispatch_get_main_queue(), completionHander);
    }
    
}






