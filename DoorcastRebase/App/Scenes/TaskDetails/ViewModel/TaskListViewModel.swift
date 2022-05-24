//
//  TaskListViewModel.swift
//  DoorcastRebase
//
//  Created by U Dinesh Kumar Reddy on 04/05/22.
//

import Foundation

protocol TaskListProtocol: BaseViewModelProtocol {
    func showInCompleteTaskList(response: IncompleteTaskListModel?)
    func CrewTaskLogResponse(response: CrewTaskLogModel?)
}

class TaskListViewModel {
    
    weak var view: TaskListProtocol?

    init(_ view: TaskListProtocol) {
        self.view = view
    }
    
    
    //incompleteTaskList or completeTaskList Api
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
    
    
    
    func startOrStopDayTask(){
        
        var parms = [String: Any]()
        parms["distance"] = ""
        parms["device"] = KDeviceModelName
        parms["os_type"] = KOsType
        parms["device_id"] = KDeviceID
        parms["type"] = defaults.string(forKey: "daytype")
        parms["latitude"] = KLat
        parms["longitude"] = KLong
        parms["task_id"] = ""
        
        print("url \(ApiEndpoints.startDayCrewTask)")
        print("Payload = \(parms)")
        self.view?.showLoader()
        ServiceManager.postOrPutApiCall(endPoint: ApiEndpoints.startDayCrewTask, parameters: parms as NSDictionary, resultType: CrewTaskLogModel.self) { sucess, result, errorMessage in
            DispatchQueue.main.async {
                self.view?.hideLoader()
                if sucess {
                    guard let response = result else {return}
                    self.view?.CrewTaskLogResponse(response: response)
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
