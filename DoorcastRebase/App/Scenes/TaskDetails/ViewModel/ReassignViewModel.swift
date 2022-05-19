//
//  ReassignViewModel.swift
//  DoorcastRebase
//
//  Created by Codebele 07 on 19/05/2022.
//

import Foundation

protocol ReassignViewModelProtocol : BaseViewModelProtocol {
    func ReassignSuccess(ReassignResponse : ReassignModel)
}

class ReassignViewModel {
    var view: ReassignViewModelProtocol!
    init(_ view: ReassignViewModelProtocol) {
        self.view = view
    }
    func reassignApi(dictParam: [String: Any]){
        let parms = NSDictionary(dictionary:dictParam)
        print("Parameters = \(parms)")
        
        self.view?.showLoader()
        ServiceManager.postOrPutApiCall(endPoint: ApiEndpoints.ReassignApi , parameters: parms as NSDictionary, resultType: ReassignModel.self) { sucess, result, errorMessage in

            DispatchQueue.main.async {
                self.view?.hideLoader()
                if sucess {
                    guard let response = result else {return}
                    self.view.ReassignSuccess(ReassignResponse: response)
                } else {
                    // Show alert
                    print("error = \(errorMessage ?? "")")
                }
            }
        }
    }
    
}
