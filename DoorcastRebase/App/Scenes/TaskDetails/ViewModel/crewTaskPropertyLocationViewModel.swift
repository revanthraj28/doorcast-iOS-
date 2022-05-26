//
//  crewTaskPropertyLocationViewModel.swift
//  DoorcastRebase
//
//  Created by Codebele 09 on 25/05/22.
//

import Foundation


protocol crewTaskPropertyLocationViewModelProtocol:BaseViewModelProtocol {
    func crewTaskPropertyLocationSuccess(CrewTaskpropertyLocation : crewpropertyLocationModel)
}

class CrewTaskPropertyLocationModel {
    var view: crewTaskPropertyLocationViewModelProtocol!
    init(_ view: crewTaskPropertyLocationViewModelProtocol) {
        self.view = view
    }
    func CrewTaskPropertyLocationApi(dictParam: [String: Any]){
        
        
        let paramsDict = NSDictionary(dictionary:dictParam)
        print("Parameters = \(paramsDict)")
        self.view?.showLoader()
        ServiceManager.postOrPutApiCall(endPoint: ApiEndpoints.exstreamTaskPropertyLocation, parameters: paramsDict as NSDictionary, resultType: crewpropertyLocationModel.self) { sucess, result, errorMessage in
            
            self.view?.hideLoader()
            DispatchQueue.main.async {
                
                if sucess {
                    guard let response = result else {return}
                    self.view.crewTaskPropertyLocationSuccess(CrewTaskpropertyLocation: response)
                } else {
                    // Show alert
                    print("error = \(errorMessage ?? "")")
                }
            }
        }
    }
}
