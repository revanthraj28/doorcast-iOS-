//
//  UpdateTaskStatusCompleteModel.swift
//  DoorcastRebase
//
//  Created by Codebele 07 on 24/05/2022.
//

import Foundation


struct UpdateTaskStatusCompleteModel : Decodable {
    let status : Bool?
    let message : String?
//    let data : nil?
}

//class JSONNull1: Codable, Hashable {
//
//    public static func == (lhs: JSONNull1, rhs: JSONNull1) -> Bool {
//        return true
//    }
//
//    public var hashValue: Int {
//        return 0
//    }
//
//    public init() {}
//
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if !container.decodeNil() {
//            throw DecodingError.typeMismatch(JSONNull1.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encodeNil()
//    }
//}



//{
//    "status": true,
//    "message": "Updated successfully",
//    "data": null
//}

