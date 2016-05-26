//
//  TLStringUtil.swift
//  Pods
//
//  Created by Andrew on 16/5/23.
//
//

import UIKit

public class TLStringUtil: NSObject {

    public class func isEmpty(string:String?)->Bool {
        if(string == nil){
          return true
        }
        if(string is NSNull){
          return true
        }
        //去空格
        if((string?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) == nil){
            return true
        }
        
        if(string == "<null>"){
          return true
        }
        if(string!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)==0){
          return true
        }
        
        return false
    }
  
    
}
