//
//  HomeModel.swift
//  DoorcastRebase
//
//  Created by U Dinesh Kumar Reddy on 04/05/22.
//

import Foundation
struct HomeModel : Codable {
    let status : Bool?
    let message : String?
    let data : [HomeModelData]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([HomeModelData].self, forKey: .data)
    }

}
struct HomeModelData : Codable {
    let organization_id : String?
    let userorg_role : String?
    let organization_name : String?

    enum CodingKeys: String, CodingKey {

        case organization_id = "organization_id"
        case userorg_role = "userorg_role"
        case organization_name = "organization_name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        organization_id = try values.decodeIfPresent(String.self, forKey: .organization_id)
        userorg_role = try values.decodeIfPresent(String.self, forKey: .userorg_role)
        organization_name = try values.decodeIfPresent(String.self, forKey: .organization_name)
    }

}
