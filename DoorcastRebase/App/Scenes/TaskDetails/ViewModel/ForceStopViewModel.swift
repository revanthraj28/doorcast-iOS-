//
//  ForceStopViewModel.swift
//  DoorcastRebase
//
//  Created by Codebele 07 on 17/05/2022.
//

import Foundation


protocol ForceStopViewModelProtocol : BaseViewModelProtocol {
    func ForceStopSuccess(ForceStopResponse : ForceModel)
}

class ForceStopViewModel {
    var view: ForceStopViewModelProtocol!
    init(_ view: ForceStopViewModelProtocol) {
        self.view = view
    }
    func ForceStopApi(dictParam: [String: Any]){
        let parms = NSDictionary(dictionary:dictParam)
        print("Parameters = \(parms)")
        
        self.view?.showLoader()
        ServiceManager.postOrPutApiCall(endPoint: ApiEndpoints.forceStop , parameters: parms as NSDictionary, resultType: ForceModel.self) { sucess, result, errorMessage in
            
            DispatchQueue.main.async {
                self.view?.hideLoader()
                if sucess {
                    guard let response = result else {return}
                    self.view.ForceStopSuccess(ForceStopResponse: response)
                } else {
                    // Show alert
                    print("error = \(errorMessage ?? "")")
                }
            }
        }
    }
    
}

