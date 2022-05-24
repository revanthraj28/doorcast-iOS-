//
//  ReassignModel.swift
//  DoorcastRebase
//
//  Created by Codebele 07 on 19/05/2022.
//

import Foundation

struct ReassignModel : Codable {
    let status : Bool?
    let message : String?
    let data : [ReassignModelData]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([ReassignModelData].self, forKey: .data)
    }

}


struct ReassignModelData : Codable {
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


struct ExstreamTaskLocationModel : Codable {
    
    let status : Bool?
    let message : String?
    var data1: [String]?
    let timedata : Timedata?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data1 = "data"
        case timedata = "time"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data1 = try values.decodeIfPresent([String].self, forKey: .data1)
        timedata = try values.decodeIfPresent(Timedata.self, forKey: .timedata)
    }

}



struct Timedata : Codable {
    let working_time : String?
    let individual_working_time : String?
    let ideal_time : String?
    let day_status : Bool?
    let task_status : String?

    enum CodingKeys: String, CodingKey {

        case working_time = "working_time"
        case individual_working_time = "individual_working_time"
        case ideal_time = "ideal_time"
        case day_status = "day_status"
        case task_status = "task_status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        working_time = try values.decodeIfPresent(String.self, forKey: .working_time)
        individual_working_time = try values.decodeIfPresent(String.self, forKey: .individual_working_time)
        ideal_time = try values.decodeIfPresent(String.self, forKey: .ideal_time)
        day_status = try values.decodeIfPresent(Bool.self, forKey: .day_status)
        task_status = try values.decodeIfPresent(String.self, forKey: .task_status)
    }

}
