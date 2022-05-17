//
//  ForceStopViewModel.swift
//  DoorcastRebase
//
//  Created by Codebele 07 on 17/05/2022.
//

import Foundation


protocol ForceStopViewModelProtocol : BaseViewModelProtocol {
    func ForceStopSuccess(ForceStopResponse : ForceModel)
}

class ForceStopViewModel {
    var view: ForceStopViewModelProtocol!
    init(_ view: ForceStopViewModelProtocol) {
        self.view = view
    }
    func ForceStopApi(dictParam: [String: Any]){
        let paramsDict = NSDictionary(dictionary:dictParam)
        print("Parameters = \(paramsDict)")
//        func SubTaskListApi(task_id: String, task_id_check: String, group_id: String, type: String){
//            let dict =  ["task_id": task_id_check , "task_id_check": task_id, "group_id": group_id, "type": type ]
//        {"crew_list":"749","task_list":"3049","main_task_id":"3049","org_id":"24"}
        
        self.view?.showLoader()
        ServiceManager.postOrPutApiCall(endPoint: ApiEndpoints.forceStop , parameters: paramsDict as NSDictionary, resultType: ForceModel.self) { sucess, result, errorMessage in
            
            DispatchQueue.main.async {
                self.view?.hideLoader()
                if sucess {
                    guard let response = result else {return}
                    self.view.ForceStopSuccess(ForceStopResponse: response)
                } else {
                    // Show alert
                    print("error = \(errorMessage ?? "")")
                }
            }
        }
    }
    
}

