//
//  GetOrganizationsViewModel.swift
//  DoorcastRebase
//
//  Created by Codebele 09 on 04/05/22.
//

import Foundation
import UIKit

protocol GetOrganizationsModelProtocol {
    func organizationDetails(response : GetOrganizationsModel)
}

class GetOrganizations {
    var view: GetOrganizationsModelProtocol!
    init(_ view: GetOrganizationsModelProtocol) {
        self.view = view
    }
    func getOrganizationApi() {
        
        //https://staging.doorcast.tech/api/get_organizations
        ServiceManager.getApiCall(endPoint: ApiEndpoints.getOrganizationApi, resultType: GetOrganizationsModel.self) { sucess, result, errorMessage in
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
