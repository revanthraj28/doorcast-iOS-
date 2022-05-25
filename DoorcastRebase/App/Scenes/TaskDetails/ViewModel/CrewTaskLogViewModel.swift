//
//  CrewTaskLogViewModel.swift
//  DoorcastRebase
//
//  Created by Codebele 09 on 25/05/22.
//

import Foundation


protocol CrewTaskLogModelProtocol:BaseViewModelProtocol {
    func CrewTaskLogSuccess(CrewTaskLog : crewTaskLogModel)
}

class CrewTaskLogViewModel {
    var view: CrewTaskLogModelProtocol!
    init(_ view: CrewTaskLogModelProtocol) {
        self.view = view
    }
    func CrewTaskLogApi(dictParam: [String: Any]){
        
        
        let paramsDict = NSDictionary(dictionary:dictParam)
        print("Parameters = \(paramsDict)")
        self.view?.showLoader()
        ServiceManager.postOrPutApiCall(endPoint: ApiEndpoints.exstreamCrewTaskLog, parameters: paramsDict as NSDictionary, resultType: crewTaskLogModel.self) { sucess, result, errorMessage in
            
            self.view?.hideLoader()
            DispatchQueue.main.async {
                
                if sucess {
                    guard let response = result else {return}
                    self.view.CrewTaskLogSuccess(CrewTaskLog: response)
                } else {
                    // Show alert
                    print("error = \(errorMessage ?? "")")
                }
            }
        }
    }
}
