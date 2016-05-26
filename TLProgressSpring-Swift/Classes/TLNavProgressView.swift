//
//  TLNavProgressView.swift
//  Pods
//  导航栏底部的进度条
//  Created by Andrew on 16/5/23.
//
//

import UIKit

var GETProgroressKey = "progressKey"

let TL_UINavigationControllerDidShowViewControllerNotification:String="UINavigationControllerDidShowViewControllerNotification"
let TL_UINavigationControllerLastVisibleViewController:String="UINavigationControllerLastVisibleViewController"

//MARK: - 对UINavigationController的扩展
extension UINavigationController{
    var progressView:TLNavProgressView?{
        get{
            return objc_getAssociatedObject(self, &GETProgroressKey) as? TLNavProgressView;
        }
        set{
           objc_setAssociatedObject(self, &GETProgroressKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
}

//MARK: - TLNavProgressView类
public class TLNavProgressView: TLProgressView {
 
    /// 设置进度条的颜色
   public var progressTintColor:UIColor{
        get{
          return (self.tlProgressView?.tintColor)!
        }
        set{
         self.tlProgressView?.backgroundColor=newValue
        }
    }
    
    
     var progress:Float = 0{
        didSet{
          progressDidChange()
        }
     }
    
    
    var tlProgressView:UIView?
    var viewController:UIViewController?
    var barView:UIView?
    {
        didSet{
          layoutSubviews()
        }
    }
    /// 数字百分比的格式
    var progressNumberForMatter:NSNumberFormatter{
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .PercentStyle
        formatter.locale = NSLocale.currentLocale()
        return formatter
    }

   public override init(frame: CGRect) {
      super.init(frame: frame);
      self.initView()
    }
    
    
    //MARK: - 类方法
   public class func progressViewforNavigationController(navigationController: UINavigationController)->TLNavProgressView {

    //  从传入的导航控制器中去尝试得到一个已经存在的TLNavBarProgressView
    var progressView:TLNavProgressView? = navigationController.progressView;
    
    if(progressView != nil){
        return progressView!
    }
    
    //创建一个新的progressView
    let navigationBar = navigationController.navigationBar;
    progressView = TLNavProgressView()
    progressView?.barView=navigationBar
    
    let tintColor:UIColor = (navigationBar.tintColor != nil) ? navigationBar.tintColor:UIApplication.sharedApplication().delegate?.window!!.tintColor
    progressView?.progressTintColor = tintColor
    
    navigationController.progressView = progressView
    navigationController.navigationBar.addSubview(progressView!)
    
    //开始监听
    progressView?.viewController = navigationController.topViewController
    progressView?.registerObserverForNavigationController(navigationController)
    return progressView!
 }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    

    
    func registerObserverForNavigationController(nav:UINavigationController) -> Void {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(navigationControllerDisShowViewController(_:)), name: TL_UINavigationControllerDidShowViewControllerNotification, object: nav)
    }
    
    func unregisterObserverForNavigationController(nav:UINavigationController) -> Void {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func navigationControllerDisShowViewController(notification:NSNotification) -> Void {
        
        let navigationController:UINavigationController = notification.object as! UINavigationController;
        
        let lastVisibleVC:UIViewController = notification.userInfo![TL_UINavigationControllerLastVisibleViewController] as! UIViewController;
        
        //检查我们的控制器是不是TopViewController或者是被poped
        if(lastVisibleVC == self.viewController!){
          //注销监听
            self.unregisterObserverForNavigationController(navigationController )
           // navigationController.progressView? =
            navigationController.progressView = nil
            self .removeFromSuperview()
            
        }
    }
    
    /**
     初始化页面的方法
     */
    func initView() -> Void {
        self.autoresizingMask = .FlexibleWidth
        self.opaque = false
        
        
        let progressView = UIView(frame: CGRectMake(0, 0, 0, self.bounds.size.height))
        progressView.autoresizingMask = .FlexibleWidth;
        progressView.backgroundColor = self.tintColor
        
        self.addSubview(progressView)
        self.tlProgressView = progressView
        
        self.progress = 0
        self.tintColorDidChange()
        
    }
    
    //MARK: - 自动布局
    public override func layoutSubviews() {
        super.layoutSubviews()

        let barFrame:CGRect = self.barView!.frame
        let progressBarHeight:CGFloat = 2
        var frame:CGRect = CGRectMake(barFrame.origin.x, 0, barFrame.size.width,CGFloat( progressBarHeight));
        
        if(self.barView is UINavigationBar){
            let barBorderHeight:CGFloat = 0.5
            frame.origin.y = barFrame.size.height - progressBarHeight+barBorderHeight
        }
        
        if(!CGRectEqualToRect(self.frame, frame)){
          self.frame=frame
        }
        
        self.layoutProgressView()
        
    }
    
    func layoutProgressView() -> Void {
        self.tlProgressView?.frame = CGRectMake(0, 0, self.frame.size.width * CGFloat(self.progress), self.frame.size.height)
    }
    
    //MARK: - 进度条改变触发的方法
    func progressDidChange() -> Void {
        self.tlProgressView?.alpha = self.progress >= 1 ? 0 : 1;
        
        self.layoutProgressView()
        
    }
    
    //MARK: - 进度条设置+动画
    public override func setProgress(prgressValue: Float, animated: Bool) {
        if(animated){
            if(progress>0 && progress<1 && self.tlProgressView?.alpha < 0){
             self.tlProgressView?.alpha=1
            }
            
           // ((finished:Bool)->())
            func completion(finished:Bool){
                UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: {
                    self.tlProgressView?.alpha=self.progress>=1 ? 0:1;
                    }, completion: nil)
            }
            
            
            if(progress>self.progress || self.progress>=1){
             UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: {
                self.progress = prgressValue
                }, completion: completion)
            }else{
             UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .CurveLinear, animations: {
                 self.progress=prgressValue
                }, completion: completion)
            }
            
        }else{
          self.progress = prgressValue
        }
    }
}











