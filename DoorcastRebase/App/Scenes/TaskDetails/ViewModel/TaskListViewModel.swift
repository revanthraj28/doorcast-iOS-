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
    
    
    
    //startTast or stopTast Api
    
    
    
    
    
    
    func getInCompleteTaskListMockData() {
        self.view?.showLoader()
        let responseJsonModel = IncompleteTaskListModel.fromJSON(jsonFile: LocalJsonFiles.incompleteTaskDetails) as IncompleteTaskListModel?
        self.view?.hideLoader()
        self.view?.showInCompleteTaskList(response: responseJsonModel)
    }
    
}




//URL: ```https://staging.doorcast.tech/api/exstream_crewTaskLog```
//
//Method: POST
//
//Authentication Headers:
//```
//  Accesstoken: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.Ijc0OSI.0SuocLrTA4szVKXCbZEMuaCYhqPSwToxOynGmWB82EU,
//  Content-Type: application\/json
//```
//
//Payload: ```{
//  "distance" : "",
//  "device" : "iPhone SE (2nd generation)",
//  "os_type" : "15.4.1",
//  "device_id" : "D462D210-77BB-44A7-A79C-B2B924A56F8D",
//  "type" : "start",
//  "latitude" : 15.151603,
//  "longitude" : 76.922963999999993,
//  "task_id" : ""
//}```
//
//Response: ```{
//    data =     {
//        "ideal_time" = "00:00:00";
//        "individual_taskworking_time" = "00:00:00";
//        "working_time" = "00:00:00";
//    };
//    message = "Total ideal time for crew";
//    status = 1;
//}```





//URL: ```https://staging.doorcast.tech/api/exstream_crewTaskLog```
//
//Method: POST
//
//Authentication Headers:
//```
//  Content-Type: application\/json,
//  Accesstoken: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.Ijc0OSI.0SuocLrTA4szVKXCbZEMuaCYhqPSwToxOynGmWB82EU
//```
//
//Payload: ```{
//  "type" : "stop",
//  "longitude" : 76.922963999999993,
//  "device" : "iPhone SE (2nd generation)",
//  "task_id" : "",
//  "latitude" : 15.151603,
//  "os_type" : "15.4.1",
//  "device_id" : "D462D210-77BB-44A7-A79C-B2B924A56F8D",
//  "distance" : ""
//}```
//
//Response: ```{
//    data =     {
//        "ideal_time" = "00:00:00";
//        "individual_taskworking_time" = "00:00:00";
//        "working_time" = "00:00:00";
//    };
//    message = "Total ideal time for crew";
//    status = 1;
//}```
