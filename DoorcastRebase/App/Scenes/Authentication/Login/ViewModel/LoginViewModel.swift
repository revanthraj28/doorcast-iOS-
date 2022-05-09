//
//  LoginViewModel.swift
//  DoorcastRebase
//
//  Created by U Dinesh Kumar Reddy on 04/05/22.
//

import Foundation

protocol LoginViewModelProtocol : BaseViewModelProtocol{
    func loginSuccess(loginResponse : LoginModel)
}

class LoginViewModel {
    var view: LoginViewModelProtocol!
    init(_ view: LoginViewModelProtocol) {
        self.view = view
    }
    func loginApi(dictParam: [String: Any]){
        let paramsDict = NSDictionary(dictionary:dictParam)
        print("Parameters = \(paramsDict)")
        self.view.showLoader()
        ServiceManager.postOrPutApiCall(endPoint: ApiEndpoints.crewLoginApi, parameters: paramsDict as NSDictionary, resultType: LoginModel.self) { sucess, result, errorMessage in
            DispatchQueue.main.async {
                self.view.hideLoader()
                if sucess {
                    guard let response = result else {return}
                    self.view.loginSuccess(loginResponse: response)
                } else {
                    // Show alert
//                    self.view.showToast(message: errorMessage ?? "")
                    self.view.showPositionalToast(message: errorMessage ?? "", position: .bottom)
                    print("error = \(errorMessage ?? "")")
                }
            }
        }
    }
}
