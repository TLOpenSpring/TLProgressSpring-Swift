//
//  TLOverlayProgressView.swift
//  Pods
//  带有遮罩效果的进度条
//  Created by Andrew on 16/5/23.
//
//

import UIKit
import TLProgressSpring_Swift

let TLScreenWIDTH = UIScreen.mainScreen().bounds.size.width
let TLScreenHEIGH = UIScreen.mainScreen().bounds.size.height

/// 创建一个闭包->可以点击停止的回调函数
public typealias TLStopBlock = ((progressView:TLOverlayProgressView)->())

let HorizontalBarHeight:CGFloat = 45
let TLSmallIndicatorHeight:CGFloat = 35
let TLTitleLbHeight:CGFloat = 20
let TLTextTipHeight:CGFloat =  60

public enum TLMode:Int {
    /**
     *  默认显示TLAcitivityIndicator,转轮
     */
    case ActivityIndeterminate
    /**
     *  显示一个饼状的转轮，(TlCircleProgressView)
     */
    case DeterminateCircular
    /**
     *  显示一个水平方向的进度条(UIProgressView)
     */
    case HorizontalBar
    /**
     *  显示一个小尺寸的TLAcitivityIndicator
     */
    case IndeterminateSmall
    /**
     *  显示一个小尺寸的TLAcitivityIndicator并且带有文字
     */
    case IndeterminateSmallAndText
    /**
     *  显示苹果系统自带的UIActivityIndicator
     */
    case SystemUIActivity
    /**
     *  显示一个对勾（正确）
     */
    case CheckmarkIcon
    /// 显示一个错误的交叉（error）
    case CrossIcon
    /// 显示提示文字
    case TipText
    /// 显示自定义的控件
    case Custom
    
}

//MARK: - 带有遮罩的进度条
public class TLOverlayProgressView: UIView {

    let TLProgressOverlayViewCornerRadius:CGFloat = 7;
    let TLProgressOverlayViewMotionEffectExtent = 10;
    let TLProgressOverlayViewObservationContext:String = "TLProgressOverlayViewObservationContext";
    var mode:TLMode! {
    
        didSet{
            //这里的代码执行不了，不知道为什么，难道枚举的观察器不好使
        }
    }
    /// 弹出的对话框
    var dialogView:UIView!
    /// 模糊视图,附着在dialogView上
    var blurView:UIView!
    var blurMaskView:UIView?
    /// 进度条的值
    var progress:CGFloat = 0
    /// 进度条的标题
    var titleLb:UILabel?
    var isShowPercent:Bool=false
    
    var modeView:UIView!{
        didSet{
         dialogView.addSubview(modeView)
        }
    }
    
    var stopBlock:TLStopBlock?
    
    var numberFormatter:NSNumberFormatter{
        var formatter = NSNumberFormatter()
        formatter.numberStyle = .PercentStyle
        formatter.locale = NSLocale.currentLocale()
        return formatter
    }
    
    //MARK: - 构造方法
    /**
     构造方法
     
     - parameter AddToView: 指定父亲视图
     - parameter title:     显示的标题
     - parameter mode:      进度条模式
     - parameter animated:  是否支持动画
     - parameter stopBlock: 点击停止的闭包
     
     - returns: 进度条视图
     */
   public convenience init(parentView: UIView,title:String?,modeValue:TLMode?,animated:Bool?,stopBlock:TLStopBlock?) {
    
     self.init(frame: CGRectZero);
    
    
    self.mode=modeValue!
    self.createModeView()
    self.titleLb?.text=title
    self.stopBlock = stopBlock
    parentView.addSubview(self)
    
    self.showAnimated(animated!)
    manualLayoutSubviews()
    
    }
    
    public convenience init(parentView: UIView,animated:Bool) {
        self.init(parentView:parentView,title:"",modeValue:TLMode.ActivityIndeterminate,animated: animated,stopBlock: nil);
    }
    
    public convenience init(parentView: UIView,animated:Bool,title:String) {
        self.init(parentView:parentView,title:title,modeValue:TLMode.ActivityIndeterminate,animated: animated,stopBlock: nil);
    }
    public convenience init(parentView: UIView,animated:Bool,title:String,mode:TLMode) {
        self.init(parentView:parentView,title:title,modeValue:mode,animated: animated,stopBlock: nil);
    }
    

    
   override init(frame: CGRect) {
    self.mode = .ActivityIndeterminate
        super.init(frame: frame)
       initView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    func initView() -> Void {
        //创建一个模糊视图
        self.blurView = self.createBlurView()
        self.autoresizingMask = .FlexibleWidth
        
        //创建一个容器
        dialogView = UIView()
        self.addSubview(dialogView)
        //设置Dialogview
        dialogView.backgroundColor=UIColor.whiteColor()
        dialogView.layer.cornerRadius = TLProgressOverlayViewCornerRadius
        dialogView.layer.shadowRadius = TLProgressOverlayViewCornerRadius + 5
        dialogView.layer.shadowOpacity = 0.1
        dialogView.layer.shadowOffset = CGSizeMake(-(TLProgressOverlayViewCornerRadius+5)/2.0, -(TLProgressOverlayViewCornerRadius+5)/2.0);
        
        //创建titleL
        titleLb = UILabel()
        titleLb?.text="Loading...";
        titleLb?.textAlignment = .Center
        titleLb?.numberOfLines = 0
        titleLb?.lineBreakMode = .ByCharWrapping
        dialogView.addSubview(titleLb!)
        
        
        tintColorDidChange()
        
    }
    
    //MARK: - 创建子视图
    
    func createBlurView() -> UIView
    {
        var view=UIView()
        view.backgroundColor=UIColor.blueColor()
        
        return view
    }
    
    func createModeView() -> UIView {
        self.modeView = createViewForMode(self.mode)
        modeView.tintColor = self.tintColor
    
        //创建停止按钮的响应链
        let isResponseSelector = modeView.respondsToSelector(#selector(stopButton));
        let isConformsToProtocol = modeView.conformsToProtocol(TLSTOPProtocol);
        
        if(isConformsToProtocol && isConformsToProtocol){
            
            if let stopBtn = (modeView as! TLSTOPProtocol).stopButton{
              stopBtn!.addTarget(self, action:#selector(modeViewStopButtonClick(_:)), forControlEvents: .TouchUpInside);
            }
            
        }
        
        return modeView
    }
    
    
    func stopButton() -> Void {
        
    }
    /**
     点击停止按钮
     
     - parameter btn:
     */
    func modeViewStopButtonClick(btn:UIButton) -> Void {
        if let stopHandler = stopBlock{
            stopHandler(progressView:self);
        }
    
    }
   public func setMode(mode:TLMode) -> Void {
        self.mode=mode
    //=======每当改变Mode枚举时，执行下面的改变=============
    self.createModeView()
    hideModeView(modeView)
    showModeView(modeView)
    if(!self.hidden){
        //重新布局
        manualLayoutSubviews()
    }
    //=====================
    }
    
    func createViewForMode(mode:TLMode) -> UIView {
        var progress:UIView?
        
        switch mode {
        case .ActivityIndeterminate:
            progress=TLActivityIndicatorView()
        case .IndeterminateSmall:
            progress=TLActivityIndicatorView()
        case .DeterminateCircular:
            progress = TLCircleProgressView()
        case .HorizontalBar:
            progress = createHorizontalProgressView()
        case .SystemUIActivity:
            progress = createSmallDefaultActivityIndicatorView()
        case .Custom:
            progress = createCustom()
        case .TipText:
            progress = createTextStyle()
        case .CrossIcon:
            progress = createIconStyle(TLMode.CrossIcon)
        case .CheckmarkIcon:
            progress = createIconStyle(.CheckmarkIcon)
        default:
             progress=TLActivityIndicatorView()
        }
        
        return progress!
    }
    
    //MARK: - 创建ModeView的工厂方法
    func createSmallDefaultActivityIndicatorView() -> UIActivityIndicatorView {
        let activityView = UIActivityIndicatorView()
        activityView.hidesWhenStopped = true
        activityView.activityIndicatorViewStyle = .Gray
        return activityView
    }
    
    func createTextStyle() -> UIView {
        return UIView()
    }
    
    func createIconStyle(mode:TLMode) -> TLIconView{
        var iconView:TLIconView?
        if(mode == .CheckmarkIcon){
         iconView=TLCheckMarkIconView()
        }else if(mode == .CrossIcon){
         iconView = TLCrossIconView()
        }
        return iconView!
    }
    
    func createHorizontalProgressView() -> UIProgressView {
        let progress = UIProgressView()
        return progress
    }
    
    func createCustom() -> UIView {
        return UIView()
    }
    
    //MARK: - 设置进度条的模式
    func showModeView(view:UIView) -> Void {
        view.hidden = false
        
        
        let anyobject:AnyObject = view as AnyObject
        
        if(view.respondsToSelector(#selector(startAnimating))){
            view.performSelector(#selector(startAnimating));
        }
    }
    
    func hideModeView(view:UIView) -> Void {
        view.hidden=true
        if(view.respondsToSelector(#selector(stopAnimating))){
            view.performSelector(#selector(stopAnimating));
        }
    }
    /**
     虚拟方法，会调用集成TLprogressView子类的方法
     */
    func startAnimating() -> Void {
        
    }
    
    func stopAnimating() -> Void {
        
    }
    

    //MARK: - 设置progress
 
    public func setProgress(prgressValue: Float, animated: Bool){
        self.progress = CGFloat(prgressValue)
        if(isShowPercent){
            titleLb?.text = self.numberFormatter.stringFromNumber((prgressValue))
        }
        if(prgressValue == 1)
        {
            titleLb?.text = ""
        }
        //支持动画效果
        applyProgressAnimated(animated)
    }
    
    func applyProgressAnimated(animated:Bool) -> Void {
    
        if(self.modeView.respondsToSelector(#selector(setProgress(_:animated:)))){
            (self.modeView as AnyObject).setProgress(Float(self.progress), animated: animated);
        }
        
    }
    
    //MARK: - Transitions
    
    func setSubviewTransform(transform:CGAffineTransform,alpha:CGFloat) -> Void {
        blurView.transform = transform
        dialogView.transform = transform
        self.alpha = alpha
    }
    public func showAnimated(animated:Bool) -> Void {
        showModeView(modeView!);
        manualLayoutSubviews()
        if(animated){
            setSubviewTransform(CGAffineTransformMakeScale(1.3, 1.3), alpha: 0.5)
            self.backgroundColor = UIColor.clearColor()
        }
        self.hidden = false
        
        
        func animationBlock(){
            setSubviewTransform(CGAffineTransformIdentity, alpha: 1)
            self.backgroundColor = UIColor(white: 0, alpha: 0.4)
        }
        
        if(animated){
            UIView.animateWithDuration(0.2, animations: animationBlock )
        }else{
            animationBlock();
        }
        
    }
    
    public func dismiss(animated:Bool) -> Void {
      dismiss(animated, completion: nil)
    }
    
    public func dismiss(animated:Bool,completion:(()->())?) -> Void {
        hideAnimated(animated, compleationHander: completion)
    }
    
    public func hideAnimated(animated:Bool){
      hideAnimated(animated, compleationHander: nil)
    }
    
    public func hideAnimated(animated:Bool,compleationHander:(()->())?){
        setSubviewTransform(CGAffineTransformIdentity, alpha: 1)
        
        func animationBlock(){
            setSubviewTransform(CGAffineTransformMakeScale(0.6, 0.6), alpha: 0)
            self.backgroundColor = UIColor.clearColor()
        }
        
        func animationCompletionHandler(finished:Bool){
           self.hidden = true
            hideModeView(modeView)
            
            setSubviewTransform(CGAffineTransformIdentity, alpha: 0)
            if let handler = compleationHander {
                handler();
            }
        }
        
        if(animated){
            UIView.animateWithDuration(0.2,
                                       delay: 0,
                                       options: .CurveEaseInOut,
                                       animations: animationBlock,
                                       completion: animationCompletionHandler);
        }else{
            animationBlock()
            animationCompletionHandler(true)
        }
    }
    
    
    
    //MARK: - 手动重新布局
    /**
     *  不要覆盖layoutSubviews，因为会引起动画效果的问题 在隐藏的时候
     */
    func manualLayoutSubviews() -> Void {
        var bounds:CGRect! = self.superview?.bounds
        var insets = UIEdgeInsetsZero
        
        if(self.superview is UIScrollView){
          insets = (self.superview as! UIScrollView).contentInset
        }
        //定位中心点
        self.center = CGPointMake((bounds.size.width - insets.left - insets.right) / 2.0,
                                 (bounds.size.height - insets.top - insets.bottom) / 2.0);
        
        //创建self.bounds 不然没有尺寸
        if((self.superview is UIWindow) && UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation)){
            //调转了方向
            self.bounds  = CGRectMake(0, 0, bounds.size.height, bounds.size.width)

        }else{
            self.bounds = CGRectMake(0, 0, bounds.size.width, bounds.size.height)
        }
        
        var paddingModel = TLPaddingModel()
        if(self.mode == TLMode.ActivityIndeterminate){
          laytoutActivityIndeterminate(paddingModel)
        }else if(self.mode == TLMode.DeterminateCircular){
            layoutDeterminateCircular(paddingModel);
        }else if(self.mode == TLMode.CheckmarkIcon || self.mode == TLMode.CrossIcon){
           layoutIcon(paddingModel)
        }else if(mode == TLMode.HorizontalBar){
            layoutHorizontalBar(paddingModel);
        }else if(mode == TLMode.IndeterminateSmall||mode == TLMode.IndeterminateSmallAndText){
          layoutIndeterminateSmall(paddingModel)
        }else if(mode == TLMode.SystemUIActivity){
           layoutSystemUIActivity(paddingModel)
        }else if(mode == TLMode.TipText){
          layoutTipText(paddingModel)
        }
        
        if(!CGRectEqualToRect(blurView.frame, dialogView.frame)){
            blurView.frame = dialogView.frame
            blurMaskView?.frame = dialogView.frame
            blurView.maskView = blurMaskView
        }
        
    }
    /**
     对默认的进度条进行布局
     
     - parameter model: 布局对象
     */
    func laytoutActivityIndeterminate(paddingModel:TLPaddingModel) -> Void {
        //1.设置dialogView
        var innerRect:CGRect!
        var innserSize = CGSizeMake(150, 150)
        innerRect = TLCenterCGSizeInCGRect(innserSize, outerRect: self.bounds)
        dialogView.frame=innerRect
        
        //2.设置ModeView
        let innerViewWidth:CGFloat = paddingModel.dialogMinWidth - 2*paddingModel.modePadding
        let y = dialogView.frame.size.height/2 - innerViewWidth/2
        self.modeView.frame = CGRectMake(paddingModel.modePadding, y, innerViewWidth, innerViewWidth)
        //3.设置标题
        if(!TLStringUtil.isEmpty(titleLb?.text)){
            self.modeView.frame = CGRectOffset(self.modeView.frame, 0, 10);
            self.titleLb!.frame=CGRectMake(0, 10, self.dialogView.frame.size.width, 20);
        }
        
    }
    
    func layoutDeterminateCircular(paddingModel:TLPaddingModel) -> Void {
        laytoutActivityIndeterminate(paddingModel);
    }
    
    func layoutIcon(paddingModel:TLPaddingModel) -> Void {
        laytoutActivityIndeterminate(paddingModel)
    }
    
    func layoutHorizontalBar(paddingModel:TLPaddingModel) -> Void {
        //1.设置dialogView
        var width:CGFloat = TLScreenWIDTH-50*2
        var innerRect:CGRect!
        var innserSize = CGSizeMake(width, HorizontalBarHeight)
        innerRect = TLCenterCGSizeInCGRect(innserSize, outerRect: self.bounds)
        dialogView.frame=innerRect
         //2.设置ModeView
        width = dialogView.frame.width - 10*2;
        let originY = dialogView.frame.height/2;
        self.modeView.frame=CGRectMake(10, originY, width, 30)
        self.modeView.backgroundColor=UIColor.redColor()
        
        //3.设置标题
        if(!TLStringUtil.isEmpty(titleLb?.text)){
            self.modeView.frame = CGRectOffset(self.modeView.frame, 0, 10);
            self.titleLb!.frame=CGRectMake(0, 5, self.dialogView.frame.size.width, 20);
        }
    }
    
    func layoutIndeterminateSmall(paddingModel:TLPaddingModel) -> Void {
        let height = (TLSmallIndicatorHeight-7*2);
        let  y = TLSmallIndicatorHeight/2-height/2;
        
        //1.设置dialogView
        let innerSize:CGSize = CGSizeMake(paddingModel.dialogMinWidth, TLSmallIndicatorHeight);
        let innerRect=TLCenterCGSizeInCGRect(innerSize, outerRect: self.bounds);
        self.dialogView.frame = innerRect;
        
        //2.设置modeView
        self.modeView.frame=CGRectMake(15, y, height, height);
        
        //3.设置标题
        if(!TLStringUtil.isEmpty(titleLb?.text)){
            let originY=self.dialogView.frame.size.height/2 - TLTitleLbHeight/2;
            self.titleLb!.frame = CGRectMake(CGRectGetMaxX(self.modeView.frame), originY,self.dialogView.frame.size.width-height-modeView.frame.origin.x, TLTitleLbHeight);
        }else{
            //如果没有标题，则重新布局，让dialogView尺寸变小，让modeView尺寸变小
            //重置dialogView尺寸
            var smallFrame=self.dialogView.frame;
            smallFrame.size=CGSizeMake(TLSmallIndicatorHeight, TLSmallIndicatorHeight);
            var originX=self.superview!.frame.size.width/2 - smallFrame.size.width/2;
            smallFrame.origin.x=originX;
            self.dialogView.frame=smallFrame;
            
            //重置modeView尺寸
            smallFrame=self.modeView.frame;
            originX=self.dialogView.frame.size.width/2 - smallFrame.size.width/2;
            smallFrame.origin.x=originX;
            self.modeView.frame=smallFrame;
        }
    }
    
    func layoutSystemUIActivity(paddingModel:TLPaddingModel) -> Void {
        layoutIndeterminateSmall(paddingModel)
    }
    
   
    
    func layoutTipText(paddingModel:TLPaddingModel) -> Void {
        //1.设置dialogView
      
        let innerSize:CGSize = CGSizeMake(paddingModel.dialogMinWidth,TLTextTipHeight);
        var  innerRect=TLCenterCGSizeInCGRect(innerSize, outerRect: self.bounds);
        self.dialogView.frame = innerRect;
        
        //2.设置modeView
        self.modeView.frame=self.dialogView.bounds;
        
        //3.设置标题
        if(!TLStringUtil.isEmpty(self.titleLb!.text)){
            let gap:CGFloat=10;
            var originY:CGFloat=0;
            
            self.titleLb!.frame=CGRectMake(gap, gap, innerRect.size.width-gap*2, innerRect.size.height-gap*2);
           self.titleLb?.sizeToFit()
            
            originY=self.superview!.frame.size.height/2 - (self.titleLb!.frame.size.height+gap*2)/2;
            self.dialogView.frame=CGRectMake(self.dialogView.frame.origin.x, originY, self.titleLb!.frame.size.width+gap*2, self.titleLb!.frame.size.height+gap*2);
            self.modeView.frame=self.dialogView.bounds;
        }
    }
    
   
}

internal func TLCenterCGSizeInCGRect(innerRectSize:CGSize,outerRect:CGRect)->CGRect{
    
    var innerRect:CGRect=CGRectZero;
    innerRect.size = innerRectSize;
    innerRect.origin.x = outerRect.origin.x + (outerRect.size.width  - innerRectSize.width)  / 2.0;
    innerRect.origin.y = outerRect.origin.y + (outerRect.size.height - innerRectSize.height) / 2.0;
    return innerRect;
 
}



















