//
//  ApiClient.swift
//  Network Example
//
//  Created by Ajaaypranav R K on 07/10/22.
//

import Foundation
import Alamofire
import UIKit


class ApiClient {
    func postTransaction(url:String, parameter : [String:Any] ,success successBlock : @escaping([String:Any]?) -> Void) -> DataRequest {
        let header = HeaderRequestParameter()
        header.addParameter(key: HeaderRequestParameter.ContentType, value: "application/json")
        
        return ApiManager.requestApi(method: .post, urlString: url, parameters: parameter, headers: header.parameters, success: { response in
            successBlock(response)
        }, failure: { (error) -> Bool in
            return true
        })
    }
    
    func getTransaction(url:String,parameter : [String:Any] , sucess sucessBlock : @escaping([String:Any?]) -> Void ) -> DataRequest {
        let header = HeaderRequestParameter()
        header.addParameter(key: HeaderRequestParameter.ContentType, value: "application/json")
        
        return ApiManager.requestApi(method: .get, urlString: url, parameters: parameter, headers: header.parameters, success: { response in
            sucessBlock(response)
        }, failure:{ (error) -> Bool in
           return true
        })
    }
    
}




class HeaderRequestParameter {
    var parameters = [String : String]()
    
    static let authorization = "Authorization"
    static let ContentType = "Content-Type"
    static let accessToken = "access_token"
    static let refreshToken = "refresh_token"
    
    init() {
    }

    func addParameter(key: String, value: String) {
        parameters[key] = value
    }
}
