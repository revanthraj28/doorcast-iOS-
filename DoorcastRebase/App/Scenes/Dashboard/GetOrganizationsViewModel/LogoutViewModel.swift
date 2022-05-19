//
//  LogoutViewModel.swift
//  DoorcastRebase
//
//  Created by Codebele 09 on 05/05/22.
//

import Foundation
import Firebase


protocol LogoutViewModelProtocol:BaseViewModelProtocol {
    func logoutSuccess(logoutResponse : LogoutModel)
}

class LogoutViewModel {
    var view: LogoutViewModelProtocol!
    init(_ view: LogoutViewModelProtocol) {
        self.view = view
    }
    func logoutApi(){
        
        self.view.showLoader()
        ServiceManager.postOrPutApiCall(endPoint: ApiEndpoints.crewlogoutApi, parameters:nil, resultType: LogoutModel.self) { sucess, result, errorMessage in
            
            self.view.hideLoader()
            if sucess {
                let center = UNUserNotificationCenter.current()
                center.removeAllDeliveredNotifications()
                guard let response = result else {return}
                self.view.logoutSuccess(logoutResponse: response)
            } else {
                print("error = \(errorMessage ?? "")")
            }
            
        }
    }
}
