//
//  String+Extension.swift
//  LongLian369

import Foundation

public extension String {
    
 
    static func isValidmobile(_ string: String) -> Bool {
   
        let patternString = "^1[3|4|5|7|8][0-9]\\d{8}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", patternString)
        return predicate.evaluate(with: string)
    }
    

    static func isValidPasswod(_ string: String) -> Bool {
      
        let patternString = "^[0-9A-Za-z]{6,16}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", patternString)
        return predicate.evaluate(with: string)
    }
}
