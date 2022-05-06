//
//  CrewPropertiesModel.swift
//  DoorcastRebase
//
//  Created by Codebele 09 on 05/05/22.
//

import Foundation

// MARK: - Welcome
struct CrewPropertyModel : Codable {
    let status: Bool
    let message: String
    let data: [CrewPropertiesData]
}

struct CrewPropertiesData: Codable {
    let clientID : String
    let clientName: String
    let propertyData: [PropertyDatum]

    enum CodingKeys: String, CodingKey {
        case clientID = "client_id"
        case clientName = "client_name"
        case propertyData = "propertyData"
    }
}

// MARK: - PropertyDatum
struct PropertyDatum: Codable {
    let propertyID : String
    let propertyName: String

    enum CodingKeys: String, CodingKey {
        case propertyID = "property_id"
        case propertyName = "property_name"
    }
}
