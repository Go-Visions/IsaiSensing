//
//  IsaiSenseingAPI.swift
//  IsaiSensing
//
//  Created by nishi kosei on 2020/01/18.
//  Copyright © 2020 nishi kosei. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class IsaiSensingAPI {
    //共通部
    enum ResultCode: Int {
        /// 通信エラー
        case connectionError = -1
        /// 認証エラー
        case unauthorized = -2
        /// その他エラー
        case otherClientError = -99
        
        /// エラーコード
        var code: Int { return rawValue }
        static func fromError(_ error: Error) -> ResultCode {
            guard let error = error as? AppError else {
                return .otherClientError
            }

            switch error {
            case .connection:
                return .connectionError
            case .unauthorized:
                return .unauthorized
            case .networkResponse,
                 .common:
                return .otherClientError
            }
        }
    }
    
    /// シングルトンインスタンス
    static var instance = IsaiSensingAPI()
    private let baseUrl: String
    
    init() {
        baseUrl = ApplicationConfig.API.baseUrlString
    }
    
    /// HTTPヘッダを作る
    private func httpHeaders() -> HTTPHeaders {
        var headers: HTTPHeaders = [:]
        return headers
    }

    /// エンドポイントからURL文字列を作る
    private func createUrl(endpoint: String) -> String {
        return baseUrl + endpoint
    }
    
    /// 共通Request処理
    /// parametersはget時に必須にするとサーバー側でエラーとなるため、optionalとする
    func request(
        endPoint: String,
        method: HTTPMethod = .post, // デフォルトは POST
        parameters: Parameters?,
        completionHandler: @escaping (Alamofire.Result<JSON>, DataResponse<Any>) -> Void) {

        let request = Alamofire
            .request(createUrl(endpoint: endPoint), method: method, parameters: parameters, encoding: JSONEncoding.default, headers: IsaiSensingAPI.instance.httpHeaders())
            .validate() // HTTP 2xx 以外をfailureに流す

        #if STAGING || LOCAL
        debugPrint(request)
        #endif
        request.responseJSON { response in
            #if STAGING || LOCAL
            debugPrint(response)
            #endif
            completionHandler(self.parseJSON(response), response)
        }
    }

    /// エラーがあればエラーを返す。なければnil
    private func parseJSON(_ response: DataResponse<Any>) -> Alamofire.Result<JSON> {
        switch response.result {
        case .success(let value):
            // HTTP 2xx: 成功処理
            return .success(JSON(value))
        case .failure(let error):
            guard let statusCode = response.response?.statusCode else {
                // HTTPステータスコードが取れないということは通信エラー。
                // 細かく判別するならerror型などで見ればOK。
                return .failure(AppError.connection(error))
            }
            // 2xx以外のステータスコードエラー処理
            switch statusCode {
            case 401: return .failure(AppError.unauthorized)
            // 400, 5xx 含め通信書式エラーとしておく
            default: return .failure(AppError.networkResponse)
            }
        }
    }
}

// APIエンドポイント実装
extension IsaiSensingAPI {
    /// MindWave Mobile2 データをサーバにpost
    /// delta, theta, alpha(low,hight)それぞれをpost
    class PostMWMData {
        func request(eegPowerDelta: EegPowerDelta, completionHandler: @escaping (Response) -> Void) {
            let parameters: Parameters = [
                "delta": eegPowerDelta.delta,
                "theta": eegPowerDelta.theta,
                "lowAlpha": eegPowerDelta.lowAlpha,
                "highAlpha": eegPowerDelta.highAlpha
            ]
            IsaiSensingAPI.instance.request(
                endPoint: "/eegpowerdelta",
                parameters: parameters) { response, _ in
                    let json: JSON
                    switch response {
                    case .success(let value): json = value
                    case .failure(let error):
                        completionHandler(Response(
                            resultCode: IsaiSensingAPI.ResultCode.fromError(error).code,
                            errorMessage: error.localizedDescription,
                            json: JSON()))

                        return
                    }
                    let resultCode = json["resultCode"].int
                    let errorMessage = json["errorMessage"].string
                    completionHandler(Response(
                        resultCode: resultCode,
                        errorMessage: errorMessage,
                        json: json
                    ))
            }
        }

        struct Response {
            let resultCode: Int?
            let errorMessage: String?
            let json: JSON
        }
    }
    
}
