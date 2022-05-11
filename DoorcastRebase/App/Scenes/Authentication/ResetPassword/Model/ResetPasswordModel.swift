//
//  ResetPasswordModel.swift
//  DoorcastRebase
//
//  Created by Codebele 07 on 05/05/2022.
//

import Foundation

struct ResetPasswordModel : Codable {
    let status : Bool?
    let message : String?
    let data : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(String.self, forKey: .data)
    }

}
