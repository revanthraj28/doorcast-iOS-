//
//  ForceFinishModel.swift
//  DoorcastRebase
//
//  Created by Codebele 06 on 11/05/22.
//

import Foundation


import Foundation
struct ForceFinishModel : Codable {
    let status : Bool?
    let message : String?
    let data : [ForceFinishData]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([ForceFinishData].self, forKey: .data)
    }

}

struct ForceFinishData : Codable {
    let crew_id : String?
    let crew_name : String?
    let task_id : String?
    let group_id : String?

    enum CodingKeys: String, CodingKey {

        case crew_id = "crew_id"
        case crew_name = "crew_name"
        case task_id = "task_id"
        case group_id = "group_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        crew_id = try values.decodeIfPresent(String.self, forKey: .crew_id)
        crew_name = try values.decodeIfPresent(String.self, forKey: .crew_name)
        task_id = try values.decodeIfPresent(String.self, forKey: .task_id)
        group_id = try values.decodeIfPresent(String.self, forKey: .group_id)
    }

}
