//
//  UpdateTaskStatusViewModel.swift
//  DoorcastRebase
//
//  Created by Codebele 07 on 24/05/2022.
//

import Foundation

protocol UpdateTaskStatusViewModelProtocol : BaseViewModelProtocol {
    func UpdateTaskStatusSuccess(UpdateTaskStatusResponse : UpdateTaskStatusModel)
}

class UpdateTaskStatusViewModel {
    var view: UpdateTaskStatusViewModelProtocol!
    init(_ view: UpdateTaskStatusViewModelProtocol) {
        self.view = view
    }
    func UpdateTaskStatus(dictParam: [String: Any]){
        let parms = NSDictionary(dictionary:dictParam)
        print("Parameters = \(parms)")
        
        self.view?.showLoader()
        ServiceManager.postOrPutApiCall(endPoint: ApiEndpoints.UpdateTaskStatus , parameters: parms as NSDictionary, resultType: UpdateTaskStatusModel.self) { sucess, result, errorMessage in

            DispatchQueue.main.async {
                self.view?.hideLoader()
                if sucess {
                    guard let response = result else {return}
                    self.view.UpdateTaskStatusSuccess(UpdateTaskStatusResponse: response)
                } else {
                    // Show alert
                    print("error = \(errorMessage ?? "")")
                }
            }
        }
    }
    
}
