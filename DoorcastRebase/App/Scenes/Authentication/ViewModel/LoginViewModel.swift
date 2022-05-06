//
//  LoginViewModel.swift
//  DoorcastRebase
//
//  Created by U Dinesh Kumar Reddy on 04/05/22.
//

import Foundation

protocol LoginViewModelProtocol {
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
        /*
         {"device":"ios",
         "device_id":"e813bc2f7fbbc829",
         "os_type":"R",
         "latitude":0.0,
         "longitude":0.0,
         "email":"chaitranew@gmail.com",
         "password":"exstream",
         "device_token":"embLbUlYRDChPUTgGUV6Ob:APA91bGvpyfL_W7VC_m7dEaXD-Wr22lgRufMJavjcJg7rGHZfugdgisgbOYz2oz4aUlm8fMJOwu3s5w4sZY31h_py4S6C-TeA2n54tI2nClMtIddA_EuCi-O34CnZxi6aL82EKr4k4Sf"}
         */
        
        ServiceManager.postOrPutApiCall(endPoint: ApiEndpoints.crewLoginApi, parameters: paramsDict as NSDictionary, resultType: LoginModel.self) { sucess, result, errorMessage in
            DispatchQueue.main.async {
                if sucess {
                    guard let response = result else {return}
                    self.view.loginSuccess(loginResponse: response)
                } else {
                    // Show alert
                    print("error = \(errorMessage ?? "")")
                }
            }
        }
    }
}
