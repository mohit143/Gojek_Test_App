//
//  GKContactManager.swift
//  FirstMateServices


import UIKit
import Foundation
import Alamofire

class GKContactManager: NSObject {
    typealias CompletionHandler = (_ response: Bool, _ object: AnyObject) -> Void
    
    class var sharedInstance : GKContactManager {
        struct Static {
            static let instance : GKContactManager = GKContactManager()
        }
        return Static.instance
    }
    
    
    // MARK: - Contact List
    func requestContactList(completion: @escaping ([GKContactList]?, Error?) -> ())
    {
        ShowHUD()
        let newURL = K.appUrl.contactListUrl
        let url = URL(string: newURL)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        Alamofire.request(urlRequest).responseGKContactList { (response) in
            print(response)
            if let error = response.error {
                completion(nil, error)
                RemoveHUD()
                return
            }
            if let contactList = response.result.value {
                completion(contactList, nil)
                return
            }
        }
    }
    // MARK: - Contact Detail / Delete Contact
    func requestContactDetail(contactId:String,isDelete:Bool? = false,completion: @escaping (GKContactDetail?, Error?) -> ())
    {
//        ShowHUD()
        let newURL = K.appUrl.contactDetailUrl.replacingOccurrences(of: "cid", with: contactId)
        let url = URL(string: newURL)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        if isDelete == true{
            urlRequest.httpMethod = "DELETE"
        }
        Alamofire.request(urlRequest).responseGKContactDetail { (response) in
            print(response)
            if let error = response.error {
                completion(nil, error)
                RemoveHUD()
                return
            }
            if let contactDetail = response.result.value {
                completion(contactDetail, nil)
                RemoveHUD()
                return
            }
        }
    }
    
    // MARK: - Delete contact
    func deleteContact(contactId:String,completion: @escaping (GKContactDetail?, Error?) -> ())
    {
        ShowHUD()
        let newURL = K.appUrl.contactDetailUrl.replacingOccurrences(of: "cid", with: contactId)
        let url = URL(string: newURL)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        Alamofire.request(urlRequest).responseGKContactDetail { (response) in
            print(response)
            if let error = response.error {
                completion(nil, error)
                RemoveHUD()
                return
            }
            if let contactDetail = response.result.value {
                completion(contactDetail, nil)
                RemoveHUD()
                return
            }
        }
    }
    // MARK: - Save Contact Detail
    func saveContactDetail(params:[String:Any],imageData : Data? = nil,completion: @escaping (GKContactDetail?, Error?) -> ())
    {
        ShowHUD()
        var replaceString = ""
        var dictParam = params
        var method = "POST"
        if (params["id"] as! String) != "-1"{
            replaceString = "/" + (params["id"] as! String)
            method = "PUT"
        }
        //else{
            dictParam.removeValue(forKey: "id")
        //}
        let newURL = K.appUrl.contactDetailUrl.replacingOccurrences(of: "/cid", with: replaceString)

        // prepare json data
       
        var json: [String: Any] = dictParam
        if imageData != nil {
            let strBase64 = imageData!.base64EncodedString(options: .lineLength64Characters)
            print(strBase64)
            json["profile_pic"] = strBase64
        }
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: newURL)!
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = jsonData
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // insert json data to the request
       
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            if (error != nil) {
                print(error!)
                completion(nil, error)
                return
            } else {
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                    let model:GKContactDetail = GKContactDetail(fromDictionary: responseJSON)
                    completion(model,error)
                }
                
            }
            RemoveHUD()
        }
        
        task.resume()

    }
}
extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
