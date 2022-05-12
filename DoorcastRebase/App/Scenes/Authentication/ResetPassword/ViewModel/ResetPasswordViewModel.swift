//
//  ResetPasswordViewModel.swift
//  DoorcastRebase
//
//  Created by Codebele 07 on 05/05/2022.
//

import Foundation


protocol ResetpasswordViewModelProtocol:BaseViewModelProtocol {
    func ResetpasswordSuccess(ResetpasswordResponse : ResetPasswordModel)
}

class ResetpasswordViewModel {
    var view : ResetpasswordViewModelProtocol!
    init(_ view: ResetpasswordViewModelProtocol){
        self.view = view
    }
    func ResetPasswordApi(dictParam: [String : Any]){
        let paramsDict = NSDictionary(dictionary : dictParam)
        print("Params = \(paramsDict)")
        
        self.view.showLoader()
        ServiceManager.postOrPutApiCall(endPoint: ApiEndpoints.ResetPasswordApi, parameters: paramsDict as NSDictionary, resultType: ResetPasswordModel.self) { sucess, result, errorMessage in
            
            self.view.hideLoader()
            DispatchQueue.main.async {
                if sucess {
                    guard let response = result else {return}
                    self.view.ResetpasswordSuccess(ResetpasswordResponse: response)
                } else {
                    print("error = \(errorMessage ?? "")")
                }
            }
        }
    }
}

