//
//  ExstreamTaskLocationViewModel.swift
//  DoorcastRebase
//
//  Created by Codebele 07 on 25/05/2022.
//

import Foundation


protocol ExstreamTaskLocationViewModelProtocol:BaseViewModelProtocol {
    func ExstreamTaskLocationSuccess(ExstreamTaskLocationViewModelResponse : ExstreamTaskLocationModel)
}

class ExstreamTaskLocationViewModel {
    var view: ExstreamTaskLocationViewModelProtocol!
    init(_ view: ExstreamTaskLocationViewModelProtocol) {
        self.view = view
    }
    func ExstreamTaskLocationViewModel(dictParam: [String: Any]){
        
        let parms = NSDictionary(dictionary:dictParam)
        print("Parameters = \(parms)")
        
        self.view?.showLoader()
        ServiceManager.postOrPutApiCall(endPoint: ApiEndpoints.exstreamTaskLocation, parameters: parms as NSDictionary, resultType: ExstreamTaskLocationModel.self) { sucess, result, errorMessage in
            
            self.view?.hideLoader()
            DispatchQueue.main.async {
                
                if sucess {
                    guard let response = result else {return}
                    self.view.ExstreamTaskLocationSuccess(ExstreamTaskLocationViewModelResponse: response)
                } else {
                    // Show alert
                    print("error = \(errorMessage ?? "")")
                }
            }
        }
    }
}
