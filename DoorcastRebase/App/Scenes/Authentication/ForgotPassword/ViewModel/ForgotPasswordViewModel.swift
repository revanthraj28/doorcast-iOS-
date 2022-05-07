//
//  ForgotPasswordViewModel.swift
//  DoorcastRebase
//
//  Created by Codebele 07 on 04/05/2022.
//

import Foundation

protocol ForgotPasswordViewModelProtocol {
    func ForgotPasswordSuccess(ForgotPasswordResponse : ForgotPasswordModel)
}

class ForgotPasswordViewModel {
    var view : ForgotPasswordViewModelProtocol!
    init(_ view: ForgotPasswordViewModelProtocol){
        self.view = view
    }
    func ForgotPasswordApi(dictParam: [String : Any]){
        let paramsDict = NSDictionary(dictionary : dictParam)
        print("Params = \(paramsDict)")
        
        print("SessionManager.loginInfo?.data?.accesstoken = \(SessionManager.loginInfo?.data?.accesstoken)")
        ServiceManager.postOrPutApiCall(endPoint: ApiEndpoints.ForgotPasswordApi, parameters: paramsDict as NSDictionary, resultType: ForgotPasswordModel.self) { sucess, result, errorMessage in
            DispatchQueue.main.async {
                if sucess {
                    guard let response = result else {return}
                    self.view.ForgotPasswordSuccess(ForgotPasswordResponse: response)
                } else {
                    print("error = \(errorMessage ?? "")")
                }
            }
        }
    }
}
