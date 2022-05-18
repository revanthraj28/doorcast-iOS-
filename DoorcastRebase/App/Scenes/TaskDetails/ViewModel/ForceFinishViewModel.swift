//
//  ForceFinishViewModel.swift
//  DoorcastRebase
//
//  Created by Codebele 06 on 11/05/22.
//

import Foundation

protocol ForceFinishViewModelProtocol : BaseViewModelProtocol {
    func ForceFinishSuccess(ForceFinishResponse : ForceFinishModel)
}

class ForceFinishViewModel {
    var view: ForceFinishViewModelProtocol!
    init(_ view: ForceFinishViewModelProtocol) {
        self.view = view
    }
    func ForceFinishApi(dictParam: [String: Any]){
        let paramsDict = NSDictionary(dictionary:dictParam)
        print("Parameters = \(paramsDict)")
        
        self.view?.showLoader()
        ServiceManager.postOrPutApiCall(endPoint: ApiEndpoints.forceFinishApi, parameters: paramsDict as NSDictionary, resultType: ForceFinishModel.self) { sucess, result, errorMessage in
            
            DispatchQueue.main.async {
                self.view?.hideLoader()
                if sucess {
                    guard let response = result else {return}
                    self.view.ForceFinishSuccess(ForceFinishResponse: response)
                } else {
                    // Show alert
                    print("error = \(errorMessage ?? "")")
                }
            }
        }
    }
    
}
