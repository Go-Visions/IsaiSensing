//
//  AppError.swift
//  IsaiSensing
//
//  Created by nishi kosei on 2020/01/18.
//  Copyright © 2020 nishi kosei. All rights reserved.
//

import Foundation

/// アプリ内エラー
enum AppError: Error {
    /// 未認証エラー
    case unauthorized
    /// 通信結果が正しくないエラー
    case networkResponse

    /// 通信失敗エラー
    case connection(Error)

    /// 汎用エラー。ユーザに指定文言を表示する。(localizedDescriptionとして取得できる)
    case common(String)

}
extension AppError: LocalizedError {
    /// エラー理由
    /// https://qiita.com/takehilo/items/cf384e5a3ab2c22163d7
    var errorDescription: String? {
        switch self {
        case .unauthorized:
            return ApplicationUIString.Error.unauthorized
        case .networkResponse:
            return ApplicationUIString.Error.invalidNetworkResponse
        case .connection:
            return ApplicationUIString.Error.networkConnection
        case .common(let message):
            return message
        }
    }
}
