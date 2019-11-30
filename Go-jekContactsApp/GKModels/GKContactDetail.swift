//
//  GKContactDetail.swift
//  Go-jekContactsApp
//
//  Created by Mohit Mathur on 24/11/19.
//  Copyright © 2019 Mohit Mathur. All rights reserved.
//


import Foundation
import Alamofire

// MARK: - GKContactDetail
class GKContactDetail: Codable {
    var id: Int?
    var firstName, lastName, email, phoneNumber: String?
    let profilePic: String?
    var favorite: Bool?
    let createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case phoneNumber = "phone_number"
        case profilePic = "profile_pic"
        case favorite
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(id: Int?, firstName: String?, lastName: String?, email: String?, phoneNumber: String?, profilePic: String?, favorite: Bool?, createdAt: String?, updatedAt: String?) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
        self.profilePic = profilePic
        self.favorite = favorite
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        self.id = dictionary["access_token"] as? Int
        self.firstName = dictionary["first_name"] as? String
        self.lastName = dictionary["last_name"] as? String
        self.email = dictionary["email"] as? String
        self.phoneNumber = dictionary["phoneNumber"] as? String
        self.profilePic = dictionary["profilePic"] as? String
        self.favorite = dictionary["favorite"] as? Bool
        self.createdAt = dictionary["last_name"] as? String
        self.updatedAt = dictionary["updatedAt"] as? String
    }
}

