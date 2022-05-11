////
////  SubTaskModel.swift
////  DoorcastRebase
////
////  Created by Codebele 09 on 09/05/22.
////
//



import Foundation
struct TaskDataModel : Codable {
    let subtask : [Subtask]?
    let taskdetails : Taskdetails?

    enum CodingKeys: String, CodingKey {

        case subtask = "subtask"
        case taskdetails = "taskdetails"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        subtask = try values.decodeIfPresent([Subtask].self, forKey: .subtask)
        taskdetails = try values.decodeIfPresent(Taskdetails.self, forKey: .taskdetails)
    }

}

struct SubtaskDetailModel : Codable {
    let status : Bool?
    let message : String?
    let data : TaskDataModel?
    let image_captured : String?
    let latitude : String?
    let longitude : String?
    let time : Time?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
        case image_captured = "image_captured"
        case latitude = "latitude"
        case longitude = "longitude"
        case time = "time"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(TaskDataModel.self, forKey: .data)
        image_captured = try values.decodeIfPresent(String.self, forKey: .image_captured)
        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
        time = try values.decodeIfPresent(Time.self, forKey: .time)
    }

}

struct Subtask : Codable {
    let sub_task_name : String?
    let sub_task_id : String?
    let sub_task_cipher : String?
    let sub_task_description : String?
    let sub_task_add_date : String?
    let sub_task_start_date : String?
    let sub_task_close_date : String?
    let sub_task_photo_required : String?
    let sub_task_close_summary : String?
    let completed_status : String?
    let sub_task_assined_to_this_crew : Bool?
    let subTaskAssined : Bool?

    enum CodingKeys: String, CodingKey {

        case sub_task_name = "sub_task_name"
        case sub_task_id = "sub_task_id"
        case sub_task_cipher = "sub_task_cipher"
        case sub_task_description = "sub_task_description"
        case sub_task_add_date = "sub_task_add_date"
        case sub_task_start_date = "sub_task_start_date"
        case sub_task_close_date = "sub_task_close_date"
        case sub_task_photo_required = "sub_task_photo_required"
        case sub_task_close_summary = "sub_task_close_summary"
        case completed_status = "completed_status"
        case sub_task_assined_to_this_crew = "sub_task_assined_to_this_crew"
        case subTaskAssined = "subTaskAssined"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        sub_task_name = try values.decodeIfPresent(String.self, forKey: .sub_task_name)
        sub_task_id = try values.decodeIfPresent(String.self, forKey: .sub_task_id)
        sub_task_cipher = try values.decodeIfPresent(String.self, forKey: .sub_task_cipher)
        sub_task_description = try values.decodeIfPresent(String.self, forKey: .sub_task_description)
        sub_task_add_date = try values.decodeIfPresent(String.self, forKey: .sub_task_add_date)
        sub_task_start_date = try values.decodeIfPresent(String.self, forKey: .sub_task_start_date)
        sub_task_close_date = try values.decodeIfPresent(String.self, forKey: .sub_task_close_date)
        sub_task_photo_required = try values.decodeIfPresent(String.self, forKey: .sub_task_photo_required)
        sub_task_close_summary = try values.decodeIfPresent(String.self, forKey: .sub_task_close_summary)
        completed_status = try values.decodeIfPresent(String.self, forKey: .completed_status)
        sub_task_assined_to_this_crew = try values.decodeIfPresent(Bool.self, forKey: .sub_task_assined_to_this_crew)
        subTaskAssined = try values.decodeIfPresent(Bool.self, forKey: .subTaskAssined)
    }

}


struct Taskdetails : Codable {
    let org_id : String?
    let taskname : String?
    let task_id : String?
    let task_id_cipher : String?
    let task_description : String?
    let task_add_date : String?
    let task_start_date : String?
    let task_close_date : String?
    let photo_required : String?
    let close_summary : String?
    let propertyname : String?
    let propertyid : String?
    let address : String?
    let proporty_onboard_date : String?

    enum CodingKeys: String, CodingKey {

        case org_id = "org_id"
        case taskname = "taskname"
        case task_id = "task_id"
        case task_id_cipher = "task_id_cipher"
        case task_description = "task_description"
        case task_add_date = "task_add_date"
        case task_start_date = "task_start_date"
        case task_close_date = "task_close_date"
        case photo_required = "photo_required"
        case close_summary = "close_summary"
        case propertyname = "propertyname"
        case propertyid = "propertyid"
        case address = "address"
        case proporty_onboard_date = "proporty_onboard_date"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        org_id = try values.decodeIfPresent(String.self, forKey: .org_id)
        taskname = try values.decodeIfPresent(String.self, forKey: .taskname)
        task_id = try values.decodeIfPresent(String.self, forKey: .task_id)
        task_id_cipher = try values.decodeIfPresent(String.self, forKey: .task_id_cipher)
        task_description = try values.decodeIfPresent(String.self, forKey: .task_description)
        task_add_date = try values.decodeIfPresent(String.self, forKey: .task_add_date)
        task_start_date = try values.decodeIfPresent(String.self, forKey: .task_start_date)
        task_close_date = try values.decodeIfPresent(String.self, forKey: .task_close_date)
        photo_required = try values.decodeIfPresent(String.self, forKey: .photo_required)
        close_summary = try values.decodeIfPresent(String.self, forKey: .close_summary)
        propertyname = try values.decodeIfPresent(String.self, forKey: .propertyname)
        propertyid = try values.decodeIfPresent(String.self, forKey: .propertyid)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        proporty_onboard_date = try values.decodeIfPresent(String.self, forKey: .proporty_onboard_date)
    }

}

struct Time : Codable {
    let working_time : String?
    let ideal_time : String?
    let individual_working_time : String?
    let day_status : Bool?
    let task_status : String?

    enum CodingKeys: String, CodingKey {

        case working_time = "working_time"
        case ideal_time = "ideal_time"
        case individual_working_time = "individual_working_time"
        case day_status = "day_status"
        case task_status = "task_status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        working_time = try values.decodeIfPresent(String.self, forKey: .working_time)
        ideal_time = try values.decodeIfPresent(String.self, forKey: .ideal_time)
        individual_working_time = try values.decodeIfPresent(String.self, forKey: .individual_working_time)
        day_status = try values.decodeIfPresent(Bool.self, forKey: .day_status)
        task_status = try values.decodeIfPresent(String.self, forKey: .task_status)
    }

}
