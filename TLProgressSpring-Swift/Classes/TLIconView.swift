//
//  TLIconView.swift
//  Pods
//  创建图标 成功或者失败的标志
//  Created by Andrew on 16/6/1.
//
//

import UIKit

public class TLIconView: UIView {
    
    var borderWidth:CGFloat{
        get {
          return self.layer.borderWidth
        }
        
        set {
          self.layer.borderWidth = newValue
        }
    }
    var lineWidth:CGFloat{
        get{
            if(self.shapeLayer().lineWidth == 0){
             self.shapeLayer().lineWidth = 2.0
            }
          return self.shapeLayer().lineWidth
        }
        
        set{
          self.shapeLayer().lineWidth = newValue
        }
    }
    
    

    /**
     返回一个贝塞尔曲线
     
     - returns: 贝塞尔曲线
     */
    func path() -> UIBezierPath {
        return UIBezierPath()
    }
    
    func shapeLayer() -> CAShapeLayer {
        return self.layer as! CAShapeLayer
    }
    
    public override class func layerClass() -> AnyClass {
        return CAShapeLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() -> Void {
//        self.borderWidth = 2;
        self.lineWidth = 2
        self.shapeLayer().fillColor = UIColor.clearColor().CGColor
        self.tintColorDidChange()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.shapeLayer().path = self.path().CGPath
    }
    
    public override func tintColorDidChange() {
        super.tintColorDidChange()
        let tintColor = self.tintColor
        self.layer.borderColor = tintColor.CGColor
        self.shapeLayer().strokeColor = tintColor.CGColor
    }
    
}
//MARK: -  成功对勾
public class TLCheckMarkIconView:TLIconView{
    override func initView() {
        super.initView()
    }
    
    override func path() -> UIBezierPath {
        let bezierpath = UIBezierPath()
        let bounds = self.bounds
        bezierpath.moveToPoint(CGPointMake(bounds.size.width*0.2, bounds.size.height*0.55))
        
        bezierpath.addLineToPoint(CGPointMake(bounds.size.width*0.325, bounds.size.height*0.7))
        
        bezierpath.addLineToPoint(CGPointMake(bounds.size.width*0.75, bounds.size.height*0.3))
        
        return bezierpath
    }
}

//MARK: - 失败交叉子
public class TLCrossIconView:TLIconView{
    override func initView() {
        super.initView()
    }
    
    override func path() -> UIBezierPath {
        let bezierPath = UIBezierPath()
        let padding:CGFloat = 0.25
        
        let size = self.bounds.size
        let min = padding
        let max = 1-padding
        
        
        bezierPath.moveToPoint(CGPointMake(size.width*min, size.height*min))
        bezierPath.addLineToPoint(CGPointMake(size.width*max, size.height*max))
        
        bezierPath.moveToPoint(CGPointMake(size.width*min, size.height*max))
        bezierPath.addLineToPoint(CGPointMake(size.width*max, size.height*min))
        return bezierPath
        
        
    }
}
