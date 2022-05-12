//
//  CrewModel.swift
//  DoorcastRebase
//
//  Created by Codebele 06 on 11/05/22.
//

import Foundation

struct CrewModel : Codable {
    let status : Bool?
    let message : String?
    let data : [CrewList]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([CrewList].self, forKey: .data)
    }

}


struct CrewList : Codable {
    let propertyUser_id : String?
    let propertyUser_name : String?
    let employee_id : String?
    let taskAssignedStatus : String?

    enum CodingKeys: String, CodingKey {

        case propertyUser_id = "propertyUser_id"
        case propertyUser_name = "propertyUser_name"
        case employee_id = "employee_id"
        case taskAssignedStatus = "taskAssignedStatus"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        propertyUser_id = try values.decodeIfPresent(String.self, forKey: .propertyUser_id)
        propertyUser_name = try values.decodeIfPresent(String.self, forKey: .propertyUser_name)
        employee_id = try values.decodeIfPresent(String.self, forKey: .employee_id)
        taskAssignedStatus = try values.decodeIfPresent(String.self, forKey: .taskAssignedStatus)
    }

}
