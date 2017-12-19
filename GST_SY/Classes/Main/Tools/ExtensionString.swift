//
//  ExtensionString.swift
//  GST_SY
//
//  Created by mac on 17/7/25.
//  Copyright © 2017年 hrscy. All rights reserved.
//

import Foundation
//MARK:获得string内容高度

extension String{
    
    //MARK:获得string内容高度
    
    func stringHeightWith(_ fontSize:CGFloat,width:CGFloat)->CGFloat{
        
        let font = UIFont.systemFont(ofSize: fontSize)
        
        let size = CGSize(width: width,height: CGFloat.greatestFiniteMagnitude)
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineBreakMode = .byWordWrapping;
        
        let attributes = [NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy()]
        
        let text = self as NSString
        
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: attributes, context:nil)
        
        return rect.size.height
        
    }//funcstringHeightWith
    
}//extension end
