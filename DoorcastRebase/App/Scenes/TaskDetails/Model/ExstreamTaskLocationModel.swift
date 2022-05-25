//
//  ExstreamTaskLocationModel.swift
//  DoorcastRebase
//
//  Created by Codebele 07 on 25/05/2022.
//

import Foundation


struct ExstreamTaskLocationModel : Codable {
    let status : Bool?
    let message : String?
//    let data : [String]?
    let time : Timedata?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
//        case data = "data"
        case time = "time"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
//        data = try values.decodeIfPresent([String].self, forKey: .data)
        time = try values.decodeIfPresent(Timedata.self, forKey: .time)
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
