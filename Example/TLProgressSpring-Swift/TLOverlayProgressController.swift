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
         overlayProgress.showAnimated(true)
        
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
        case .HorizontalBar:
            simulateProgress(overlayProgress)
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
            showIndicator()
            break
        case .DeterminateCircular:
            showDeterminateCircular()
        case .CheckmarkIcon:
            showCheckmarkIcon()
        case .CrossIcon:
            showCrossIcon()
        case .SystemUIActivity:
            showSystemUIActivity()
        case .HorizontalBar:
            showHorizontalBar()
        case .IndeterminateSmall:
            showIndeterminateSmall("")
        case .IndeterminateSmallAndText:
            showIndeterminateSmall("Loading......")
        case .TipText:
            showTipText()
        default:
            break;
        }
        
        performBlock(2) {
            self.overlayProgress.hideAnimated(true)
        }
        
    
     
    }
    
    func performBlock(delay:NSTimeInterval,completionHander:()->()) -> Void {
        
        let popTime = dispatch_time(DISPATCH_TIME_NOW,
                                    Int64(delay * Double(NSEC_PER_SEC))) // 1
        dispatch_after(popTime, dispatch_get_main_queue(), completionHander);
    }
    
    
    
    func showIndicator() -> Void {
        overlayProgress = TLOverlayProgressView(parentView: self.view, title: "loadin...", modeValue: .ActivityIndeterminate, animated: true
            , stopBlock: { (progressView) in
                progressView.hideAnimated(true)
        })
        overlayProgress.showAnimated(true)
    }
    
    func showSystemUIActivity() -> Void {
        overlayProgress = TLOverlayProgressView(parentView: self.view, title: "loading", modeValue: TLMode.SystemUIActivity, animated: true, stopBlock: { (progressView) in
            self.overlayProgress.hideAnimated(true)
        });
        overlayProgress.showAnimated(true)
    }
    
    func showCrossIcon() -> Void {
        overlayProgress = TLOverlayProgressView(parentView: self.view, title: "", modeValue: TLMode.CrossIcon, animated: true, stopBlock: { (progressView) in
            self.overlayProgress.hideAnimated(true)
        });
        overlayProgress.showAnimated(true)
    }
    
    func showCheckmarkIcon() -> Void {
        overlayProgress = TLOverlayProgressView(parentView: self.view, title: "成功", modeValue: TLMode.CheckmarkIcon, animated: true, stopBlock: { (progressView) in
            self.overlayProgress.hideAnimated(true)
        });
        overlayProgress.showAnimated(true)
    }
    
    func showHorizontalBar() -> Void {
        overlayProgress = TLOverlayProgressView(parentView: self.view, title: "Loading...", modeValue: TLMode.HorizontalBar, animated: true, stopBlock: { (progressView) in
            self.overlayProgress.hideAnimated(true)
        });
        overlayProgress.showAnimated(true)
        
        simulateProgress(overlayProgress)
    }
    
    func showIndeterminateSmall(text:String) -> Void {
        overlayProgress = TLOverlayProgressView(parentView: self.view, title:text, modeValue: TLMode.IndeterminateSmall, animated: true, stopBlock: { (progressView) in
            self.overlayProgress.hideAnimated(true)
        });
        overlayProgress.showAnimated(true)
    }
    
    func showTipText() -> Void {
        overlayProgress = TLOverlayProgressView(parentView: self.view, title:"全国领先的短租平台", modeValue: TLMode.TipText, animated: true, stopBlock: { (progressView) in
            self.overlayProgress.hideAnimated(true)
        });
        overlayProgress.showAnimated(true)
    }
    
    
    func showDeterminateCircular() -> Void {
        overlayProgress = TLOverlayProgressView(parentView: self.view, title: "Loading...", modeValue: .DeterminateCircular, animated: true, stopBlock: { (progressView) in
            self.overlayProgress.hideAnimated(true)
        });
        overlayProgress.showAnimated(true)
        
        self.overlayProgress.setProgress(1, animated: true)
        
        performBlock(2) {
            self.overlayProgress.hideAnimated(true)
            self.overlayProgress.setProgress(0, animated: true)
        }
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
                             
                                self.performBlock(0.5, completionHander: {
                                    progressView.hideAnimated(true)
                                       progressView.setProgress(0, animated: false)
                                })
                            })
                        })
                    })
                })
            })
        }
        
    }
    
}






