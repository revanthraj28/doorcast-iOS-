//
//  GetOrganizationsViewModel.swift
//  DoorcastRebase
//
//  Created by Codebele 09 on 04/05/22.
//

import Foundation
import UIKit

protocol GetOrganizationsModelProtocol: BaseViewModelProtocol {
    func organizationDetails(response : GetOrganizationsModel)
}

class GetOrganizationsViewModel {
    var view: GetOrganizationsModelProtocol!
    init(_ view: GetOrganizationsModelProtocol) {
        self.view = view
    }
    func getOrganizationApi() {
        
        //https://staging.doorcast.tech/api/get_organizations
        self.view.showLoader()
        ServiceManager.getApiCall(endPoint: ApiEndpoints.getOrganizationApi, resultType: GetOrganizationsModel.self) { sucess, result, errorMessage in
            DispatchQueue.main.async {
                self.view.hideLoader()
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
