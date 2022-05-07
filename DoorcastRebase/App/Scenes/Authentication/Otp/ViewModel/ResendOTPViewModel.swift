//
//  ResendOTPViewModel.swift
//  DoorcastRebase
//
//  Created by Codebele 07 on 05/05/2022.
//

import Foundation

protocol ResendOTPViewModelProtocol {
    func ResendOTPSuccess(ResendOTPResponse : ResendOTPModel)
}

class ResendOTPViewModel {
    var view : ResendOTPViewModelProtocol!
    init(_ view: ResendOTPViewModelProtocol){
        self.view = view
    }
    func ResendOTPApi(dictParam: [String : Any]){
        let paramsDict = NSDictionary(dictionary : dictParam)
        print("Params = \(paramsDict)")
        
        print("SessionManager.loginInfo?.data?.accesstoken = \(SessionManager.loginInfo?.data?.accesstoken)")
        ServiceManager.postOrPutApiCall(endPoint: ApiEndpoints.ResendOTPApi, parameters: paramsDict as NSDictionary, resultType: ResendOTPModel.self) { sucess, result, errorMessage in
            DispatchQueue.main.async {
                if sucess {
                    guard let response = result else {return}
                    self.view.ResendOTPSuccess(ResendOTPResponse: response)
                } else {
                    print("error = \(errorMessage ?? "")")
                }
            }
        }
    }
}

