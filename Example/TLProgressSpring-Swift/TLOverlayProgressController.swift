//
//  TLOverlayProgressController.swift
//  TLProgressSpring-Swift
//
//  Created by Andrew on 16/5/26.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import TLProgressSpring_Swift


public class TLOverlayProgressController: UIViewController {
    
    var overlayProgress:TLOverlayProgressView!
    
   public var mode:TLMode = .ActivityIndeterminate
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.whiteColor()
        initView()
        
        
        let showItem = UIBarButtonItem(title: "显示", style: .Plain, target: self, action: #selector(show));
        
        self.navigationItem.rightBarButtonItem=showItem
        
    }
    
    
    func show() {
        switch mode {
        case .ActivityIndeterminate:
            overlayProgress.showAnimated(true)
        case .DeterminateCircular:
            overlayProgress.showAnimated(true)
        default:
            break;
        }
        
        performBlock(2) {
            self.overlayProgress.hideAnimated(true)
        }
        
    }
    
    func initView() -> Void {
        
        switch mode {
            
        case .ActivityIndeterminate:
            overlayProgress = TLOverlayProgressView(parentView: self.view, animated: true, title: "loading");
             overlayProgress.showAnimated(true)
            break
        case .DeterminateCircular:
            overlayProgress = TLOverlayProgressView(parentView: self.view, title: "loading", modeValue: .DeterminateCircular, animated: true, stopBlock: { (progressView) in
                
                self.overlayProgress.hideAnimated(true)
            });
            
            overlayProgress.setProgress(1, animated: true)
            break;
            
        default:
            break;
            
        }
        
        
       
        
        performBlock(2) { 
           self.overlayProgress.hideAnimated(true)
        }
        
      
     
    }
    
    func performBlock(delay:NSTimeInterval,completionHander:()->()) -> Void {
        let time:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delay) * Int64(NSEC_PER_SEC));
        dispatch_after(time, dispatch_get_main_queue(), completionHander);
    }
    
    
    
    func showIndicator() -> Void {
        
    }
    
}






