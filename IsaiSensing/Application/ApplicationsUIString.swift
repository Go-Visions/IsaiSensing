//
//  ApplicationsUIString.swift
//  IsaiSensing
//
//  Created by nishi kosei on 2020/01/18.
//  Copyright © 2020 nishi kosei. All rights reserved.
//

import Foundation
struct ApplicationUIString {
    private init() {}

    struct Error {
        private init() {}
        static let unauthorized = "認証されていません。"
        static let invalidNetworkResponse = "通信結果が正しくありません。"
        static let networkConnection = "通信に失敗しました。"
        static let unknown = "不明なエラーです。"
    }
}
