//
//  AddCrewViewModel.swift
//  DoorcastRebase
//
//  Created by Codebele 07 on 18/05/2022.
//

import Foundation

protocol AddCrewViewModelProtocol : BaseViewModelProtocol {
    func AddCrewSuccess(AddCrewResponse : AddCrewModel)
}

class AddCrewViewModel {
    var view: AddCrewViewModelProtocol!
    init(_ view: AddCrewViewModelProtocol) {
        self.view = view
    }
    func AddCrewApi(dictParam: [String: Any]){
        let parms = NSDictionary(dictionary:dictParam)
        print("Parameters = \(parms)")
        
        self.view?.showLoader()
        ServiceManager.postOrPutApiCall(endPoint: ApiEndpoints.AddCrewApi , parameters: parms as NSDictionary, resultType: AddCrewModel.self) { sucess, result, errorMessage in

            DispatchQueue.main.async {
                self.view?.hideLoader()
                if sucess {
                    guard let response = result else {return}
                    self.view.AddCrewSuccess(AddCrewResponse: response)
                } else {
                    // Show alert
                    print("error = \(errorMessage ?? "")")
                }
            }
        }
    }
    
}
