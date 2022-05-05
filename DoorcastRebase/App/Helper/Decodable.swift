//
//  Decodable.swift
//  DoorcastRebase
//
//  Created by U Dinesh Kumar Reddy on 04/05/22.
//

import Foundation
extension Decodable {
    static func fromJSON<T: Decodable>(jsonFile: String, fileExtension: String = "json", bundle: Bundle = .main) -> T? {
        guard let url = Bundle.main.url(forResource: jsonFile, withExtension: fileExtension),
              let data = try? Data(contentsOf: url),
              let output = try? JSONDecoder().decode(T.self, from: data)
            else {
                return nil
        }
        return output
      }
}
