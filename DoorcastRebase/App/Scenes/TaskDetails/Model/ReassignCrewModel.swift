//
//  ReassignCrewModel.swift
//  DoorcastRebase
//
//  Created by Codebele 06 on 10/05/22.
//

import Foundation

struct reassignCrewModel : Codable {
    let status : Bool?
    let message : String?
    let data : [reassignCrewData]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([reassignCrewData].self, forKey: .data)
    }

}

struct reassignCrewData : Codable {

    let crew_id : String?
    let crew_name : String?
    let task_id : String?
    let group_id : String?
    let user_type : String?
    let property_id : String?
    let sub_task_assined_to_this_crew : Bool?
    let task_id_cipher : String?

    enum CodingKeys: String, CodingKey {

        case crew_id = "crew_id"
        case crew_name = "crew_name"
        case task_id = "task_id"
        case group_id = "group_id"
        case user_type = "user_type"
        case property_id = "property_id"
        case sub_task_assined_to_this_crew = "sub_task_assined_to_this_crew"
        case task_id_cipher = "task_id_cipher"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        crew_id = try values.decodeIfPresent(String.self, forKey: .crew_id)
        crew_name = try values.decodeIfPresent(String.self, forKey: .crew_name)
        task_id = try values.decodeIfPresent(String.self, forKey: .task_id)
        group_id = try values.decodeIfPresent(String.self, forKey: .group_id)
        user_type = try values.decodeIfPresent(String.self, forKey: .user_type)
        property_id = try values.decodeIfPresent(String.self, forKey: .property_id)
        sub_task_assined_to_this_crew = try values.decodeIfPresent(Bool.self, forKey: .sub_task_assined_to_this_crew)
        task_id_cipher = try values.decodeIfPresent(String.self, forKey: .task_id_cipher)
    }
}

