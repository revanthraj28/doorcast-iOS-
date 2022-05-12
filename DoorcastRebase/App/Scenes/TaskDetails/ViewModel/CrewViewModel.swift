//
//  CrewViewModel.swift
//  DoorcastRebase
//
//  Created by Codebele 06 on 11/05/22.
//

import Foundation

protocol CrewViewModelProtocol:BaseViewModelProtocol {
    func CrewSuccess(CrewResponse : CrewModel)
}

class CrewViewModel {
    var view: CrewViewModelProtocol!
    init(_ view: CrewViewModelProtocol) {
        self.view = view
    }
    func CrewApi(dictParam: [String: Any]){
        
        
        let paramsDict = NSDictionary(dictionary:dictParam)
        print("Parameters = \(paramsDict)")
        self.view?.showLoader()
        ServiceManager.postOrPutApiCall(endPoint: ApiEndpoints.getCrewListApi, parameters: paramsDict as NSDictionary, resultType: CrewModel.self) { sucess, result, errorMessage in
            DispatchQueue.main.async {
                self.view?.hideLoader()
                if sucess {
                    guard let response = result else {return}
                    self.view.CrewSuccess(CrewResponse: response)
                } else {
                    // Show alert
                    print("error = \(errorMessage ?? "")")
                }
            }
        }
    }
}
