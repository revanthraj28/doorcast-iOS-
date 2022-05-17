//
//  LoginModel.swift
//  DoorcastRebase
//
//  Created by U Dinesh Kumar Reddy on 04/05/22.
//

import Foundation

struct LoginModel : Codable {
    let status_code : Int?
    let message : String?
    var data : LoginModelData?

    enum CodingKeys: String, CodingKey {

        case status_code = "status_code"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(LoginModelData.self, forKey: .data)
    }

}

struct LoginModelData : Codable {
    let login_id : String?
    let accesstoken : String?
    var fullname : String?
    let email : String?
    let mobile : String?
    let doj : String?
    let role : String?

    enum CodingKeys: String, CodingKey {

        case login_id = "login_id"
        case accesstoken = "accesstoken"
        case fullname = "fullname"
        case email = "email"
        case mobile = "mobile"
        case doj = "doj"
        case role = "role"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        login_id = try values.decodeIfPresent(String.self, forKey: .login_id)
        accesstoken = try values.decodeIfPresent(String.self, forKey: .accesstoken)
        fullname = try values.decodeIfPresent(String.self, forKey: .fullname)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        mobile = try values.decodeIfPresent(String.self, forKey: .mobile)
        doj = try values.decodeIfPresent(String.self, forKey: .doj)
        role = try values.decodeIfPresent(String.self, forKey: .role)
    }

}
