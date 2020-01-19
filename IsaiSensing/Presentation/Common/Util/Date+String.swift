//
//  Date+String.swift
//  IsaiSensing
//
//  Created by nishi kosei on 2020/01/19.
//  Copyright © 2020 nishi kosei. All rights reserved.
//

import Foundation
public extension Date {
    
    /// 日付→文字列に変換する 引数でフォーマット指定
    func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
