//
//  CrewPropertyTaskLocationModel.swift
//  DoorcastRebase
//
//  Created by Codebele 09 on 25/05/22.
//

import Foundation
import UIKit

struct crewpropertyLocationModel : Codable {
    let data : String?
    let message : String?
    let status : Bool?

    enum CodingKeys: String, CodingKey {

        case data = "data"
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(String.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
    }

}
