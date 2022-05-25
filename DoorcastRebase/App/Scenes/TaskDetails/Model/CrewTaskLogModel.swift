//
//  CrewTaskLogModel.swift
//  DoorcastRebase
//
//  Created by Codebele 09 on 25/05/22.
//

import Foundation

struct crewTaskLogModel : Codable {
    let status : Bool?
    let message : String?
    let data : crewTaskLogData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(crewTaskLogData.self, forKey: .data)
    }

}

struct crewTaskLogData : Codable {
    let working_time : String?
    let individual_taskworking_time : String?
    let ideal_time : String?

    enum CodingKeys: String, CodingKey {

        case working_time = "working_time"
        case individual_taskworking_time = "individual_taskworking_time"
        case ideal_time = "ideal_time"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        working_time = try values.decodeIfPresent(String.self, forKey: .working_time)
        individual_taskworking_time = try values.decodeIfPresent(String.self, forKey: .individual_taskworking_time)
        ideal_time = try values.decodeIfPresent(String.self, forKey: .ideal_time)
    }

}
