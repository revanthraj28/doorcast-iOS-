//
//  CrewPropertyViewModel.swift
//  DoorcastRebase
//
//  Created by Codebele 09 on 05/05/22.
//

import Foundation
import Network
import UIKit

protocol CrewPropertyModelProtocol {
    func CrewPropertyDetails(response : CrewPropertyModel)
}

class CrewProperties {
    var view: CrewPropertyModelProtocol!
    init(_ view: CrewPropertyModelProtocol) {
        self.view = view
    }
    
    
    func CrewPropertiesApi(dictParam: [String: Any]){
        
        
        print("crewproperties  apii.....")
        let paramsDict = NSDictionary(dictionary:dictParam)
        print("Parameters = \(paramsDict)")
        
        //https://staging.doorcast.tech/api/get_organizations
    
        ServiceManager.postOrPutApiCall(endPoint: ApiEndpoints.crewpropertyApi, parameters : paramsDict as NSDictionary, resultType: CrewPropertyModel.self) { sucess, result, errorMessage in
            DispatchQueue.main.async {
//                self.view?.hideLoader()
                if sucess {
                    guard let resultValue = result else {return}
                    self.view?.CrewPropertyDetails(response: resultValue)
                } else {
                    debugPrint(errorMessage ?? "")
                }
            }
        }
    }
}




