//
//  DataRequest.swift
//  Go-jekContactsApp
//


import Foundation
import Alamofire

// MARK: - Alamofire response handlers

extension DataRequest {
    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else {
                
                Show(error!.localizedDescription, view: appDelegate.window?.rootViewController)
                return .failure(error!)
                
            }
            
            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            let json = String(data: data, encoding: .utf8)!
            print(json)
            
            return Result { try newJSONDecoder().decode(T.self, from: data) }
        }
    }
    
    @discardableResult
    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseGKContactList(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<[GKContactList]>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    @discardableResult
    func responseGKContactDetail(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<GKContactDetail>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
