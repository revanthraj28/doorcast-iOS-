//
//  SubTaskViewModel.swift
//  DoorcastRebase
//
//  Created by Codebele 09 on 09/05/22.
//

import Foundation

protocol SubTaskListProtocol: BaseViewModelProtocol {
    func subTaskList(response: SubtaskDetailModel?)
}

class SubTaskListViewModel {
    
    weak var view: SubTaskListProtocol?

    init(_ view: SubTaskListProtocol) {
        self.view = view
    }
    
    
    func SubTaskListApi(task_id: String, task_id_check: String, group_id: String, type: String){
        let dict =  ["task_id": task_id_check , "task_id_check": task_id, "group_id": group_id, "type": type ]
        
        print("Dict = \(dict)")
        self.view?.showLoader()
        ServiceManager.postOrPutApiCall(endPoint: ApiEndpoints.SubTaskListApi, parameters: dict as NSDictionary, resultType: SubtaskDetailModel.self) { sucess, result, errorMessage in
            DispatchQueue.main.async {
                self.view?.hideLoader()
                if sucess {
                    guard let response = result else {return}
                    self.view?.subTaskList(response: response)
                } else {
                    print("error = \(errorMessage ?? "")")
                }
            }
        }
    }
    
}


