//
//  ReassignCrewViewModel.swift
//  DoorcastRebase
//
//  Created by Codebele 06 on 10/05/22.
//


import Foundation

protocol ReassignCrewModelProtocol : BaseViewModelProtocol {
    func ReassignCrewSuccess(ReassignCrewResponse : reassignCrewModel)
}

class ReassignCrewViewModel {
    var view: ReassignCrewModelProtocol!
    init(_ view: ReassignCrewModelProtocol) {
        self.view = view
    }
    func ReassignCrewApi(dictParam: [String: Any]){
        let paramsDict = NSDictionary(dictionary:dictParam)
        print("Parameters.... = \(paramsDict)")
        self.view?.showLoader()
        ServiceManager.postOrPutApiCall(endPoint: ApiEndpoints.ReassignCrewApi, parameters: paramsDict as NSDictionary, resultType: reassignCrewModel.self) { sucess, result, errorMessage in
            DispatchQueue.main.async {
                self.view?.hideLoader()
                if sucess {
                    guard let response = result else {return}
                    self.view.ReassignCrewSuccess(ReassignCrewResponse: response)
                } else {
                    // Show alert
                    print("error = \(errorMessage ?? "")")
                }
            }
        }
    }
}
