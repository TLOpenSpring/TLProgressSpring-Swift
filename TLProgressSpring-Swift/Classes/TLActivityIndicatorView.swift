//
//  TLActivityIndicatorView.swift
//  Pods
//  自定义的进度条
//  Created by Andrew on 16/5/23.
//
//

import UIKit

 let TLActivityIndicatorViewSpinAnimationKey:String="TLActivityIndicatorViewSpinAnimationKey"

public class TLActivityIndicatorView: UIView,TLSTOPProtocol {
    /**
     *  控制动画是否可以停止
     */
    public var mayStop:Bool{
        get{
          return self.stopButton.hidden
        }
        set(newValue){
          self.stopButton.hidden = !newValue
        }
    }
    /**
     设置mayStop YES,则显示停止按钮
     设置mayStop NO, 则显示隐藏按钮
     */
    public var stopButton:UIButton!
    
    var lineWidth:CGFloat=2
    /**
     *  转子的时间设置，时间越短，速度越快
     */
   public var animatorDuration:NSTimeInterval=1
    
    var shapeLayer:CAShapeLayer?
        /// 是否正在进行动画
    var isAnimating:Bool=false
    
    //MARK: - 构造方法
    public override init(frame: CGRect) {
        super.init(frame: frame);
        self.initView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() -> Void {
        let shapeLayer = CAShapeLayer()
        shapeLayer.borderColor = self.tintColor.CGColor
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.lineWidth = self.lineWidth;
        self.layer.addSublayer(shapeLayer)
        self.shapeLayer = shapeLayer
        
        
        //创建停止按钮,为了避免循环引用，加上weak关键字，一旦循环则强制断开连接
        self.stopButton = TLStopButton(compleationHandler: {[weak self] (finished)in
            self!.stopAnimating()
        })
        
        print("self.stopButton.frame:\(self.stopButton)")
        self.addSubview(self.stopButton)
        
        self.mayStop=true
        
        self.tintColorDidChange()
    }
    
    
    //MARK: - tintColorDidChanage
    public override func tintColorDidChange() {
        super.tintColorDidChange()
        self.shapeLayer?.strokeColor = self.tintColor.CGColor
        self.stopButton.tintColor=self.tintColor
    }
    
    //MARK: - Notifactions
    func registerForNotification() -> Void {
        let center:NSNotificationCenter = NSNotificationCenter.defaultCenter()
        //当程序进入后台的时候
        center.addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name: UIApplicationDidEnterBackgroundNotification, object: nil)
        
        center.addObserver(self, selector: #selector(applicationWillEnterForeground(_:)), name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    func unregisterForNotification() -> Void {
        let center:NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.removeObserver(self)
    }
    
    func applicationDidEnterBackground(noti:NSNotification) -> Void {
        self .removeAnimation()
    }
    
    func applicationWillEnterForeground(noti:NSNotification) -> Void {
        if(self.isAnimating){
          self.addAnimation()
        }
    }
    
    //MARK: - 动画
    /**
     开始动画
     */
    public func startAnimating(){
        //如果正在进行动画，则不执行
        if(self.isAnimating){
            return;
        }
        self.isAnimating=true
        
        //注册通知
        self.registerForNotification()
        
        self.addAnimation()
        
        self.hidden=false
    }
    
    /**
     停止动画
     */
    public func stopAnimating(){
        if(self.isAnimating == false){
            return;
        }
        self.isAnimating = false
        self.unregisterForNotification()
        self.removeAnimation()
        
        self.hidden=true
    }
    
    func addAnimation() -> Void {
        let spinAnimation = CABasicAnimation(keyPath: "transform.rotation")

        //目标是360度，正好转一圈
        spinAnimation.toValue =  2*M_PI
        //设置转速，速度
        spinAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear);//匀速
        spinAnimation.duration = self.animatorDuration
        //无穷次
        spinAnimation.repeatCount = Float.infinity
        self.shapeLayer?.addAnimation(spinAnimation, forKey: TLActivityIndicatorViewSpinAnimationKey)
    }
    
    func removeAnimation() -> Void {
        self.shapeLayer?.removeAnimationForKey(TLActivityIndicatorViewSpinAnimationKey)
    }
    
    //MARK: - 重新布局
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        var frame = self.bounds
        if(abs(frame.size.width - frame.size.height) < 0){
            let s = min(frame.size.width, frame.size.height)
            frame.size.width=s;
            frame.size.height=s;
        }
        
        self.shapeLayer?.frame = frame
        self.shapeLayer?.path = self.layoutPath().CGPath
        
        //设置停止按钮的坐标
        self.stopButton.frame=(self.stopButton as! TLStopButton).frameThatFits(self.bounds)
        
    }
    
    func layoutPath() -> UIBezierPath {
        let TWO_PI = 2 * M_PI
        let startAngle:CGFloat = CGFloat(TWO_PI) * 0.1
        let endAngle:CGFloat = startAngle + CGFloat(TWO_PI)*0.92
        
        
        let width = self.bounds.size.width
        
        let path:UIBezierPath = UIBezierPath(arcCenter: CGPointMake(width/2, width/2),
                                             radius: width/2,
                                             startAngle:startAngle,
                                             endAngle:endAngle,
                                             clockwise: true)
        return path
    }
    /**
     系统初始化的时候调用的方法
     */
    public override func finalize() {
        
    }
   
    
    
    
}
