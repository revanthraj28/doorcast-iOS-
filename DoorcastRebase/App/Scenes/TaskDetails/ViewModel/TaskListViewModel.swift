//
//  TaskListViewModel.swift
//  DoorcastRebase
//
//  Created by U Dinesh Kumar Reddy on 04/05/22.
//

import Foundation

protocol TaskListProtocol: BaseViewModelProtocol {
    func showInCompleteTaskList(response: IncompleteTaskListModel?)
}

class TaskListViewModel {
    
    weak var view: TaskListProtocol?

    init(_ view: TaskListProtocol) {
        self.view = view
    }
    
    func InCompleteListApi(task_type: String, from_date: String, to_date: String, propertyid: String, crew_members: String){
        let dict =  ["task_type": task_type , "from_date": from_date, "to_date": to_date, "propertyid": propertyid, "crew_members": crew_members]
        print("Dict = \(dict)")
        self.view?.showLoader()
        ServiceManager.postOrPutApiCall(endPoint: ApiEndpoints.newTaskListApi, parameters: dict as NSDictionary, resultType: IncompleteTaskListModel.self) { sucess, result, errorMessage in
            DispatchQueue.main.async {
                self.view?.hideLoader()
                if sucess {
                    guard let response = result else {return}
                    self.view?.showInCompleteTaskList(response: response)
                } else {
                    print("error = \(errorMessage ?? "")")
                }
            }
        }
    }
    
    func getInCompleteTaskListMockData() {
        self.view?.showLoader()
        let responseJsonModel = IncompleteTaskListModel.fromJSON(jsonFile: LocalJsonFiles.incompleteTaskDetails) as IncompleteTaskListModel?
        self.view?.hideLoader()
        self.view?.showInCompleteTaskList(response: responseJsonModel)
    }
    
}
