//
//  HomeViewModel.swift
//  DoorcastRebase
//
//  Created by U Dinesh Kumar Reddy on 04/05/22.
//

import Foundation
protocol HomeViewModelProtocol {
    func organizationDetails(response : HomeModel)
}

class HomeViewModel {
    var view: HomeViewModelProtocol!
    init(_ view: HomeViewModelProtocol) {
        self.view = view
    }
    func getApi() {
        //https://staging.doorcast.tech/api/get_organizations
        ServiceManager.getApiCall(endPoint: ApiEndpoints.getOrganizationApi, resultType: HomeModel.self) { sucess, result, errorMessage in
            DispatchQueue.main.async {
                if sucess {
                    guard let resultValue = result else {return}
                    self.view?.organizationDetails(response: resultValue)
                } else {
                    debugPrint(errorMessage ?? "")
                }
            }
        }
    }
}
