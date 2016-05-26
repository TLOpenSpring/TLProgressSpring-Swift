//
//  ViewController.swift
//  TLProgressSpring-Swift
//
//  Created by Andrew on 05/23/2016.
//  Copyright (c) 2016 Andrew. All rights reserved.
//

import UIKit

let ScreenWIDTH = UIScreen.mainScreen().bounds.size.width
let ScreenHEIGH = UIScreen.mainScreen().bounds.size.height

let NAVIGATIONHEIGH:CGFloat = 64.0

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableview:UITableView?
    var arrayData:Array<String>{
        return ["普通转轮",
                "导航栏进度条",
                "圆环进度条",
                "带有遮罩层-默认",
                "带有遮罩层-圆环"];
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.whiteColor()
        self.title="各种进度条"
        self.initTableView()
    }
    
    func initTableView() {
        self.tableview=UITableView(frame: CGRectMake(0, NAVIGATIONHEIGH, ScreenWIDTH, ScreenHEIGH-NAVIGATIONHEIGH))
        self.tableview?.delegate=self
        self.tableview?.dataSource=self
        self.view.addSubview(self.tableview!)
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID:String="cellId"
        var cell = tableview?.dequeueReusableCellWithIdentifier(cellID)
        if(cell == nil){
         cell = UITableViewCell(style: .Default, reuseIdentifier: cellID)
        }
        cell?.textLabel?.text=self.arrayData[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var vc=UIViewController();
        
        switch indexPath.row {
        case 0:
            vc = TLActivityIndicatorController()
            break;
        case 1:
            vc=TLNavProgressController()
            break;
        case 2:
            vc=TLCircleController()
            break
        case 3:
            vc = TLOverlayProgressController()
            (vc as! TLOverlayProgressController).mode = .ActivityIndeterminate
            
        case 4:
            vc = TLOverlayProgressController()
            (vc as! TLOverlayProgressController).mode = .DeterminateCircular
        default:
            break;
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }


}
















