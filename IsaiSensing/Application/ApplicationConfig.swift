//
//  ApplicationConfig.swift
//  IsaiSensing
//
//  Created by nishi kosei on 2020/01/18.
//  Copyright © 2020 nishi kosei. All rights reserved.
//

import Foundation
class ApplicationConfig {
    class API {
        static let baseUrlString = "https:// /api"
//        #if LOCAL
//           static let baseUrlString = ""
//        #elseif STAGING
//           static let baseUrlString = ""
//        #else
//        /// TODO: 本番用のURLが共有された時に変更
//           static let baseUrlString = ""
//        #endif
        static let responseSuccess = 200
        static let responseFailure = 500
    }
}
