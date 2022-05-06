//
//  LogoutModel.swift
//  DoorcastRebase
//
//  Created by Codebele 09 on 05/05/22.
//

import Foundation



// MARK: - Welcome
struct LogoutModel : Codable {
    let status: Bool?
    let message: String?
    let data: [LogoutModelData]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([LogoutModelData].self, forKey: .data)
    }

}

struct LogoutModelData : Codable {
   

}



