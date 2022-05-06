//
//  LogoutViewModel.swift
//  DoorcastRebase
//
//  Created by Codebele 09 on 05/05/22.
//

import Foundation


protocol LogoutViewModelProtocol {
    func logoutSuccess(logoutResponse : LogoutModel)
}

class LogoutViewModel {
    var view: LogoutViewModelProtocol!
    init(_ view: LogoutViewModelProtocol) {
        self.view = view
    }
    func logoutApi(){
        ServiceManager.postOrPutApiCall(endPoint: ApiEndpoints.crewlogoutApi, parameters:nil, resultType: LogoutModel.self) { sucess, result, errorMessage in
            
                if sucess {
                    guard let response = result else {return}
                    self.view.logoutSuccess(logoutResponse: response)
                } else {
                    print("error = \(errorMessage ?? "")")
                }
            
        }
    }
}
