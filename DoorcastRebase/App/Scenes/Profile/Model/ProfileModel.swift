//
//  ProfileModel.swift
//  DoorcastRebase
//
//  Created by Codebele 06 on 06/05/22.
//

import Foundation

struct ProfileModel : Codable {
    let status : Bool?
    let message : String?
    let data : ProfileModelData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(ProfileModelData.self, forKey: .data)
    }

}



struct ProfileModelData : Codable {
    
    let email : String?
    let mobile : String?
    let full_name : String?
    let employee_id : String?
    

    enum CodingKeys: String, CodingKey {

        case full_name = "full_name"
        case email = "email"
        case mobile = "mobile"
        case employee_id = "employee_id"
        
        
    }

    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        full_name = try values.decodeIfPresent(String.self, forKey: .full_name)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        mobile = try values.decodeIfPresent(String.self, forKey: .mobile)
        employee_id = try values.decodeIfPresent(String.self, forKey: .employee_id)
       
    }

}
