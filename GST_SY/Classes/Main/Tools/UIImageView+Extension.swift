//
//  UIImageView+Extension.swift
//  GST_SY
//
//  Created by mac on 17/9/25.
//  Copyright © 2017年 hrscy. All rights reserved.
//

import Foundation
extension UIImage {
    //改变图片颜色
    func getImageWithColor(_ color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
        let context = UIGraphicsGetCurrentContext();
        context?.translateBy(x: 0, y: self.size.height);
        context?.scaleBy(x: 1.0, y: -1.0);
        context?.setBlendMode(.normal)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height);
        context?.clip(to: rect, mask: self.cgImage!);
        color.setFill()
        context?.fill(rect);
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage!;
    }
}
