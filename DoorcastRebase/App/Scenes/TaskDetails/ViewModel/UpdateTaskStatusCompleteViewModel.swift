//
//  UpdateTaskStatusViewModel.swift
//  DoorcastRebase
//
//  Created by Codebele 07 on 24/05/2022.
//

import Foundation

protocol UpdateTaskStatusCompleteViewModelProtocol : BaseViewModelProtocol {
    func UpdateTaskStatusCompleteSuccess(UpdateTaskStatusCompleteResponse : UpdateTaskStatusCompleteModel)
}

class UpdateTaskStatusCompleteViewModel {
    var view: UpdateTaskStatusCompleteViewModelProtocol!
    init(_ view: UpdateTaskStatusCompleteViewModelProtocol) {
        self.view = view
    }
    func UpdateTaskStatusComplete(dictParam: [String: Any]){
        let parms = NSDictionary(dictionary:dictParam)
        print("Parameters = \(parms)")
        
        self.view?.showLoader()
        ServiceManager.postOrPutApiCall(endPoint: ApiEndpoints.UpdateTaskStatus , parameters: parms as NSDictionary, resultType: UpdateTaskStatusCompleteModel.self) { sucess, result, errorMessage in

            DispatchQueue.main.async {
                self.view?.hideLoader()
                if sucess {
                    guard let response = result else {return}
                    self.view.UpdateTaskStatusCompleteSuccess(UpdateTaskStatusCompleteResponse: response)
                } else {
                    // Show alert
                    print("error = \(errorMessage ?? "")")
                }
            }
        }
    }
    
}
