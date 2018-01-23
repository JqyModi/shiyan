//
//  UIDevice+Extension.swift
//  GST_SY
//
//  Created by mac on 2018/1/23.
//  Copyright © 2018年 hrscy. All rights reserved.
//

extension UIDevice {
    public func isX() -> Bool {
        if UIScreen.main.bounds.height == 812 {
            return true
        }
        
        return false
    }
}
