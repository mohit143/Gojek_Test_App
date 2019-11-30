//
//  GKNetworkManager.swift
//  Go-jekContactsApp
//
//  
//

import Foundation
import UIKit
import Alamofire

public enum HTTPMethod : String {
    case GET
    case POST
    case PUT
    case DELETE
}

class GKNetworkManager: NSObject {
    
    typealias CompletionHandler = (_ response: DataResponse<Any>) -> Void
    
    static let sharedInstance = GKNetworkManager()
    
    fileprivate override init() {} //This prevents others from using the default '()' initializer for this class.
    
    // Header
    func performRequestWithURL(_ URLString: URLConvertible, method: HTTPMethod, headers: [String : String]?, parameters: [String: Any]?, completionHandler: @escaping CompletionHandler) {
        if GKUtility.getInternetStatus() == false{
            return
        }
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = nil
        if method == .POST
        {
            Alamofire.request(URLString, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON
                { response in
                    completionHandler(response)
            }
        }
        else if method == .GET
        {
            Alamofire.request(URLString, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON
                { response in
                    completionHandler(response)
            }
        }
    }
    func performRequestWithRequest(_ apiRequest: URLRequestConvertible, completionHandler: @escaping CompletionHandler) {
        
        
        let alamoRequest = Alamofire.request(apiRequest as URLRequestConvertible)
        alamoRequest.responseJSON { response in
            
            switch response.result {
            case .success:
                // print(response)
                completionHandler(response )
                break
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(response )
                break
                
            }
        }
        
    }
    func performRequestWithImage(_ URLString: URL, method: HTTPMethod, headers: [String : String]?,imageData: Data, imageName: String, completionHandler: @escaping CompletionHandler) {
        if GKUtility.getInternetStatus() == false{
            return
        }
        let url = try! URLRequest(url: URLString, method: .post, headers: headers)
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                multipartFormData.append(imageData, withName: imageName, fileName: "file.png", mimeType: "image/png")
        },
            with: url,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        completionHandler(response)
                    }
                case .failure( _):
                    break
                }
        }
        )
    }
    
    func performRequestWithImageWithData(_ URLString: URLConvertible,method: HTTPMethod, headers: [String : String]?, parameters: [String : String]  , imageData: Data,image: String, completionHandler: @escaping CompletionHandler)
    {
        if GKUtility.getInternetStatus() == false{
            return
        }
        let url = try! URLRequest(url: URLString, method: .post, headers: headers)
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                
                for (key, value) in parameters {
                    multipartFormData.append((value ).data(using: String.Encoding.utf8)!, withName: key )
                }
                
                multipartFormData.append(imageData, withName: image, fileName: "file.png", mimeType: "image/png")
        },
            with: url,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        completionHandler(response)
                    }
                case .failure( _):
                    break
                }
        }
        )
    }
    
}
