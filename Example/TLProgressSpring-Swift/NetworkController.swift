//
//  NetworkController.swift
//  TLProgressSpring-Swift
//
//  Created by Andrew on 16/7/22.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import TLProgressSpring_Swift

class NetworkController: UIViewController {
    var progress:Float=0
    
    var navProgrss:TLNavProgressView!;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        self.view.backgroundColor = UIColor.whiteColor()
        
    }

    func initView() -> Void
    {
        navProgrss = TLNavProgressView.progressViewforNavigationController(self.navigationController!);
        navProgrss.progressTintColor=UIColor.redColor()
        navProgrss.setProgress(0.5, animated: true)
    }
  

}
