//
//  TLStopProtocal.swift
//  Pods
//
//  Created by Andrew on 16/5/23.
//
//

import Foundation
import UIKit

public protocol TLSTOPProtocol : AnyObject{
    /**
     *  控制动画是否可以停止
     */
    var mayStop:Bool{get set}
    /**
     设置mayStop YES,则显示停止按钮
     设置mayStop NO, 则显示隐藏按钮
     */
    var stopButton:UIButton{get set}
    
    
}
