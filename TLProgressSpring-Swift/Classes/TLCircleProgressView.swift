//
//  TLCircleProgressView.swift
//  Pods
//
//  Created by Andrew on 16/5/23.
//
//

import UIKit
import TLProgressSpring_Swift


let TLCircularProgressViewProgressAnimationKey:String="TLCircularProgressViewProgressAnimationKey"

public class TLCircleProgressView: TLProgressView,TLSTOPProtocol {
     /**
     *  控制动画是否可以停止
     */
    public var mayStop:Bool{
        get{
            return self.stopButton.hidden
        }
        set(newValue){
            self.stopButton.hidden = !newValue
            self.valuelb?.hidden = newValue
        }
    }
    
    public var stopButton:UIButton!
    /**
     *  显示百分比的label
     */
    var valuelb:UILabel?
    
    var progress:CGFloat = 0
    

    /// 动画时间
   public var animationDuration:CFTimeInterval = 0.3

    /// 外部圆环的边框
    var borderWidth:CGFloat {
        get{
          return self.shapeLayer.borderWidth
        }
        set{
          self.shapeLayer.borderWidth = newValue
        }
    }
    /// 里面的圆环显示百分比的线条
    var lineWidth:CGFloat {
        get{
          return self.shapeLayer.lineWidth
        }
        set{
          self.shapeLayer.lineWidth=newValue
        }
    }
    
    var numberFormatter:NSNumberFormatter!
    var updateTimer:NSTimer?
    var shapeLayer:CAShapeLayer!
    var valueLabelProgressPercentDifference:Int?
    
    
    
   public override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() -> Void {
        numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .PercentStyle
        numberFormatter.locale = NSLocale.currentLocale()
        
       
        shapeLayer = CAShapeLayer()
        shapeLayer.fillColor=UIColor.clearColor().CGColor
        self.layer.addSublayer(shapeLayer)
        
        self.borderWidth = 2;
        self.lineWidth = 2
        
        valuelb = UILabel()
        valuelb?.textColor = UIColor.blackColor()
        valuelb?.textAlignment = .Center
        self.addSubview(valuelb!);
        
        //创建停止按钮
        self.stopButton = TLStopButton(compleationHandler: { (finished) in
            self.stopAniation()
        })
        self.addSubview(stopButton)
        self.mayStop=false
        tintColorDidChange()
    }
    
    //MARK: - tintColorDidChange
    public override func tintColorDidChange() {
        super.tintColorDidChange()
        self.shapeLayer.strokeColor = self.tintColor.CGColor
        self.layer.borderColor = self.tintColor.CGColor
        self.valuelb?.textColor=self.tintColor
        stopButton.tintColor = self.tintColor
    }
    
    
    //MARK: - 动画
    func stopAniation() -> Void {
        self.shapeLayer.removeAnimationForKey(TLCircularProgressViewProgressAnimationKey)
        self.updateTimer?.invalidate()
        self.updateTimer = nil
    }
    
    func animatedToPress(progress:Float) -> Void {
        self.stopAniation()
       
        let animation:CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = self.animationDuration
        animation.fromValue = Float(self.progress)
        animation.toValue = progress
        animation.delegate=self;
        animation.removedOnCompletion=false
        animation.fillMode = kCAFillModeForwards
        self.shapeLayer.addAnimation(animation, forKey: TLCircularProgressViewProgressAnimationKey)
        
        
        self.updateValueLb(progress)
    
        self.progress = CGFloat(progress)
     }

    
    //MARK: - 更新进度条
    public func setCurrentProgress(progress:Float) -> Void {
        self.progress = CGFloat(progress)
        stopAniation()
        updateProgress()
    }
    
    public override func setProgress(prgressValue: Float, animated: Bool){
        if(animated){
            if((abs(self.progress-CGFloat(progress)) < 0)){
                return;
            }
            self.animatedToPress(prgressValue);
        }else{
            setCurrentProgress(prgressValue);
        }
        

    }
    
    
    
    func updateProgress() -> Void {
        updatePath()
        updateValueLb(Float(self.progress))
    }
    
    func updatePath() -> Void {

        self.shapeLayer.strokeStart = 0;
        self.shapeLayer.strokeEnd = self.progress
        print("self.shapeLayer.strokeStart:\(self.shapeLayer.strokeStart);self.shapeLayer.strokeEnd:\(self.shapeLayer.strokeEnd);")
        
    }
    
    func updateValueLb(progress:Float) -> Void {
        self.valuelb?.text = self.numberFormatter.stringFromNumber((progress))
        
    }
    
    //MARK: - 自动布局
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let offset:CGFloat = 4
        var valuelbRect=self.bounds
        valuelbRect.origin.x += offset
        valuelbRect.size.width -= 2*offset
        
        self.valuelb?.frame=valuelbRect
        
        self.layer.cornerRadius = self.frame.size.width/2
        
        self.shapeLayer.path=layoutPath().CGPath
    
        
        self.stopButton.frame = (self.stopButton as! TLStopButton).frameThatFits(self.bounds)
    }
    
    func layoutPath() -> UIBezierPath {
        let TWO_PI = 2*M_PI
        let startAngle = 0.75*TWO_PI
        let endAngle = startAngle + TWO_PI
        
        let width = self.frame.size.width
        
        let radius = (width-self.lineWidth-borderWidth)/2
        
        return UIBezierPath(arcCenter: CGPointMake(width/2, width/2),
                            radius: radius,
                            startAngle:CGFloat(startAngle),
                            endAngle: CGFloat(endAngle),
                            clockwise: true)
    }
    
}
















