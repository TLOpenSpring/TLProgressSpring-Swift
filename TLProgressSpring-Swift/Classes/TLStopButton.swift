//
//  TLStopButton.swift
//  Pods
//
//  Created by Andrew on 16/5/23.
//
//

import UIKit

//声明一个闭包
public typealias CompletionHandler = ((finished:Bool)->())

public class TLStopButton: UIButton {

     /// 按钮在父亲View的比例，介于(0-1)之间
    public var sizeRadio:Float?
    
     /// 点击中间shapelayer按钮的放大比例，(0-1)之间，值越大，放大的比例越大
     var scaleRatio:Float?
    
    let TLStopButtonSize:Float = 44;
    
    var shapeLayer:CAShapeLayer?
     /// 声明一个处理完成的回调函数
    public var compleationBlock:CompletionHandler?
    
    /**
     构造函数
     
     - parameter compleationHandler: 完成的回调
     
     - returns:
     */
   public convenience init(compleationHandler:CompletionHandler){
        self.init(frame: CGRectZero)
       self.compleationBlock = compleationHandler
    }
    
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initView() -> Void {
        self.sizeRadio = 0.3;
        self.scaleRatio = 0.3;
        
        let shapeShaye:CAShapeLayer = CAShapeLayer()
        self.layer.addSublayer(shapeShaye)
        self.shapeLayer = shapeShaye
        
        self.addTarget(self, action: #selector(didTouchDown(_:)), forControlEvents: .TouchDown)
        
        self.addTarget(self, action: #selector(didTouchUpInside(_:)), forControlEvents: .TouchUpInside)
        
    }
    
    func didTouchDown(sender:AnyObject) -> Void {
        UIView.animateWithDuration(0.1) { 
            self.layoutSubviews()
        };
    }
    
    func didTouchUpInside(sender:AnyObject) -> Void {
        UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .CurveEaseOut, animations: {
            self.layoutSubviews()
            
            if let callBack = self.compleationBlock{
                callBack(finished: true);
            }
           
            }, completion: nil);
    }
    
    
    //MARK: - 构建frame
    public func frameThatFits(parentSize:CGRect) -> CGRect{
        let sizeValue = min(parentSize.size.width, parentSize.size.height)
        let viewSize = CGSizeMake(sizeValue, sizeValue)
        let insetSizeRatio = (1-self.sizeRadio!) / 2;
        
        let originX = parentSize.origin.x + (parentSize.size.width - viewSize.width)/2
        let originY = parentSize.origin.y + (parentSize.size.height-viewSize.height)/2;
        
        
        let rect = CGRectMake(originX, originY, viewSize.width, viewSize.height)
        
        
        let dx:CGFloat=sizeValue * CGFloat(insetSizeRatio);
        let dy:CGFloat=sizeValue * CGFloat(insetSizeRatio);
        
        return CGRectInset(rect, dx, dy);
    }
    
    //MARK: - 重新布局
    public override func layoutSubviews() {
        super.layoutSubviews();
        
        var frame = self.bounds
        
        if(self.tracking && self.touchInside){
            let insetSizeRatio:Float = self.scaleRatio!;
            /**
             *  以第一个参数为中心，进行放大后者缩小
             如果是正数，就是进行缩小
             如果是负数，就是进行扩大
             *
             *  @param frame 以这个坐标为中心
             *  @param -10   在X轴扩大
             *  @param -10   在Y周扩大
             *
             *  @return 一个扩大或者缩小的frame
             */
            
            let dx:CGFloat=CGFloat(insetSizeRatio)*(-frame.size.width);
            let dy:CGFloat=CGFloat(insetSizeRatio)*(-frame.size.height);
            
            frame = CGRectInset(frame,
                                dx,
                                dy)
        }
        
        self.shapeLayer?.frame=frame;
    }
    

    public override func tintColorDidChange() {
        super.tintColorDidChange();
        self.shapeLayer?.backgroundColor = self.tintColor.CGColor
    }
    
    
}



