//
//  UpdateTaskStatus.swift
//  DoorcastRebase
//
//  Created by Codebele 07 on 24/05/2022.
//

import Foundation

struct UpdateTaskStatusModel : Codable {
    let status : Bool?
    let message : String?
//    let data : nil
//    let data : JSONNull?
}

//class JSONNull: Codable, Hashable {
//
//    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
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
//            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
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
