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
            performBlock(2) {
                self.overlayProgress.hideAnimated(true)
            }
            break;
        case .DeterminateCircular:
            overlayProgress.showAnimated(true)
            simulateProgress(overlayProgress);
          
            break;
        default:
            break;
        }
        
       
        
    }
    
    func initView() -> Void {
        
        switch mode {
            
        case .ActivityIndeterminate:
            overlayProgress = TLOverlayProgressView(parentView: self.view, animated: true, title: "loading");
             overlayProgress.showAnimated(true)
            break
        case .DeterminateCircular:
            showDeterminateCircular()
            performBlock(2) {
                self.overlayProgress.hideAnimated(true)
                self.overlayProgress.setProgress(0, animated: true)
            }
            break;
            
        default:
            break;
            
        }
        
        
       
        
       
        
      
     
    }
    
    func performBlock(delay:NSTimeInterval,completionHander:()->()) -> Void {
        
        let popTime = dispatch_time(DISPATCH_TIME_NOW,
                                    Int64(delay * Double(NSEC_PER_SEC))) // 1
        
        
        dispatch_after(popTime, dispatch_get_main_queue(), completionHander);
    }
    
    
    
    func showIndicator() -> Void {
        
    }
    
    
    func showDeterminateCircular() -> Void {
        overlayProgress = TLOverlayProgressView(parentView: self.view, title: "loading", modeValue: .DeterminateCircular, animated: true, stopBlock: { (progressView) in
            self.overlayProgress.hideAnimated(true)
        });
        overlayProgress.showAnimated(true)
        
         self.overlayProgress.setProgress(1, animated: true)
    }
    
    func simulateProgress(progressView:TLOverlayProgressView) -> Void {
        progressView.showAnimated(true)
       
        self.performBlock(1.4) {
            progressView.setProgress(0.2, animated: true)
            self.performBlock(0.5, completionHander: {
                 progressView.setProgress(0.4, animated: true)
                self.performBlock(0.5, completionHander: {
                    progressView.setProgress(0.6, animated: true)
                    self.performBlock(0.5, completionHander: {
                        progressView.setProgress(0.7, animated: true)
                        self.performBlock(0.5, completionHander: {
                            progressView.setProgress(0.9, animated: true)
                            self.performBlock(0.5, completionHander: {
                                progressView.setProgress(1.0, animated: true)
                                progressView.progress=0;
                                self.performBlock(0.5, completionHander: {
                                    progressView.hideAnimated(true)
                                })
                            })
                        })
                    })
                })
            })
        }
        
    }
    
}






