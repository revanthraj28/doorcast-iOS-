//
//  IncompleteTaskListModel.swift
//  DoorcastRebase
//
//  Created by U Dinesh Kumar Reddy on 04/05/22.
//

import Foundation
struct IncompleteTaskListModel : Codable {
    let status : Bool?
    let message : String?
    let data : [IncompleteTaskListModelData]?
    let time : IncompleteTaskListModelTime?
    let login_id : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
        case time = "time"
        case login_id = "login_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([IncompleteTaskListModelData].self, forKey: .data)
        time = try values.decodeIfPresent(IncompleteTaskListModelTime.self, forKey: .time)
        login_id = try values.decodeIfPresent(String.self, forKey: .login_id)
    }

}
struct IncompleteTaskListModelData : Codable {
    let taskname : String?
    let task_id : String?
    let group_id : String?
    let task_id_cipher : String?
    let task_description : String?
    let task_add_date : String?
    let task_start_date : String?
//    let task_close_date : String?
    let photo_required : String?
//    let close_summary : String?
    let propertyname : String?
    let propertyid : String?
    let address : String?
    let proporty_onboard_date : String?
//    let completed_status : String?
    let latitude : String?
    let longitude : String?
    let role_id : String?
    let role_name : String?
    let unit : String?
    let crew_id : String?

    enum CodingKeys: String, CodingKey {

        case taskname = "taskname"
        case task_id = "task_id"
        case group_id = "group_id"
        case task_id_cipher = "task_id_cipher"
        case task_description = "task_description"
        case task_add_date = "task_add_date"
        case task_start_date = "task_start_date"
//        case task_close_date = "task_close_date"
        case photo_required = "photo_required"
//        case close_summary = "close_summary"
        case propertyname = "propertyname"
        case propertyid = "propertyid"
        case address = "address"
        case proporty_onboard_date = "proporty_onboard_date"
//        case completed_status = "completed_status"
        case latitude = "latitude"
        case longitude = "longitude"
        case role_id = "role_id"
        case role_name = "role_name"
        case unit = "unit"
        case crew_id = "crew_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        taskname = try values.decodeIfPresent(String.self, forKey: .taskname)
        task_id = try values.decodeIfPresent(String.self, forKey: .task_id)
        group_id = try values.decodeIfPresent(String.self, forKey: .group_id)
        task_id_cipher = try values.decodeIfPresent(String.self, forKey: .task_id_cipher)
        task_description = try values.decodeIfPresent(String.self, forKey: .task_description)
        task_add_date = try values.decodeIfPresent(String.self, forKey: .task_add_date)
        task_start_date = try values.decodeIfPresent(String.self, forKey: .task_start_date)
//        task_close_date = try values.decodeIfPresent(String.self, forKey: .task_close_date)
        photo_required = try values.decodeIfPresent(String.self, forKey: .photo_required)
//        close_summary = try values.decodeIfPresent(String.self, forKey: .close_summary)
        propertyname = try values.decodeIfPresent(String.self, forKey: .propertyname)
        propertyid = try values.decodeIfPresent(String.self, forKey: .propertyid)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        proporty_onboard_date = try values.decodeIfPresent(String.self, forKey: .proporty_onboard_date)
//        completed_status = try values.decodeIfPresent(String.self, forKey: .completed_status)
        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
        role_id = try values.decodeIfPresent(String.self, forKey: .role_id)
        role_name = try values.decodeIfPresent(String.self, forKey: .role_name)
        unit = try values.decodeIfPresent(String.self, forKey: .unit)
        crew_id = try values.decodeIfPresent(String.self, forKey: .crew_id)
    }

}

struct IncompleteTaskListModelTime : Codable {
    let working_time : String?
    let ideal_time : String?
    let day_status : Bool?

    enum CodingKeys: String, CodingKey {

        case working_time = "working_time"
        case ideal_time = "ideal_time"
        case day_status = "day_status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        working_time = try values.decodeIfPresent(String.self, forKey: .working_time)
        ideal_time = try values.decodeIfPresent(String.self, forKey: .ideal_time)
        day_status = try values.decodeIfPresent(Bool.self, forKey: .day_status)
    }

}
