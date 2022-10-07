//
//  ApiManager.swift
//  Network Example
//
//  Created by Ajaaypranav R K on 07/10/22.
//

import Foundation
import Alamofire

class ApiManager {
    public static let apiSessionManager: Session = {
        let configuration = URLSessionConfiguration.default
        //configuration.httpAdditionalHeaders = Session.defaultHTTPHeaders
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        configuration.timeoutIntervalForRequest = 200
        configuration.timeoutIntervalForResource = 200
        
        
        return Session(configuration: configuration)
    }()
    
    
    
    class func requestApi(method: Alamofire.HTTPMethod, urlString: String, parameters: [String: Any]? = nil, headers: [String: String]? = nil, success successBlock:@escaping (([String: Any]) -> Void), failure failureBlock:((NSError) -> Bool)?) -> DataRequest
    {
            
        var finalParameters = [String: Any]()
        if(parameters != nil)
        {
            finalParameters = parameters!
        }
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = method.rawValue
        
        request.headers = HTTPHeaders.init(headers!)
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        
        if !finalParameters.isEmpty
        {
            request.httpBody = try! JSONSerialization.data(withJSONObject: finalParameters)
        }
        return apiSessionManager.request(request).responseString { response in
               print( "Response String: \(String(describing: response.value))")

        }.responseJSON{ response in

                if(response.error == nil) {
                    let responseObject = response.value as? [NSObject: Any] ?? [NSObject: Any]()
                    let response = responseObject as! [String : Any]
                    let resp = ResponseDataModel(responseObj: response)
                    
                    successBlock(response)
                } else {
                    if failureBlock != nil {
                        if failureBlock!(response.error as NSError? ?? NSError()) {
                            if let statusCode = response.response?.statusCode{
                                ApiManager.handleAlamofireHttpFailureError(statusCode: statusCode)
                                successBlock([String: Any]())
                            }
                        }
                    }
                }
        }
    }
    
    
    class func handleAlamofireHttpFailureError(statusCode: Int) {
        switch statusCode {
        case NSURLErrorUnknown:
            
            //Utility.showMessageAlert(title: "Error", andMessage: "Ooops!! Something went wrong, please try after some time!", withOkButtonTitle: "OK")
            break
            
        case NSURLErrorCancelled:
            
            break
        case NSURLErrorTimedOut:
            
            //Utility.showMessageAlert(title: "Error", andMessage: "The request timed out, please verify your internet connection and try again.", withOkButtonTitle: "OK")
            break
            
        case NSURLErrorNetworkConnectionLost:
            //displayAlert("Error", andMessage: NSLocalizedString("network_lost", comment: ""))
            break
            
        case NSURLErrorNotConnectedToInternet:
            //displayAlert("Error", andMessage: NSLocalizedString("internet_appears_offline", comment: ""))
            break
            
        default:
            
            //Utility.showMessageAlert(title: "Error", andMessage: "Ooops!! Something went wrong, please try after some time!", withOkButtonTitle: "OK")
            break
            
        }
    }
}

class ResponseDataModel {
    
    var success = false
    var message = ""
    var upToDate = ""
    var message_code = 0
    
    init() {}
    
    init(responseObj: [String : Any]) {
        let obj = responseObj["dataStatus"] as? [String : Any] ?? [String : Any]()
        success = obj["isSuccess"] as? Bool ?? Bool()
        message = obj["message"] as? String ?? ""
        upToDate = obj["upToDate"] as? String ?? ""
        message_code = obj["status"] as? Int ?? 0
    }
}
