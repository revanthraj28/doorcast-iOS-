//
//  TaskDetailsViewModel.swift
//  DoorcastRebase
//
//  Created by CODEBELE-01 on 23/05/22.
//

import Foundation



protocol TaskDetailsViewModelDelegate:BaseViewModelProtocol {
    func startStopTaskLogResponse(response:CrewTaskLogModel?)
}


class TaskDetailsViewModel {
    
    weak var view: TaskDetailsViewModelDelegate!
    
    init(view:TaskDetailsViewModelDelegate) {
        self.view = view
    }
    
//    func callExstreamTaskLocationAPI(taskidcheck:String,taskid:String) {
//
//
//        let parms =  ["task_id_check": taskidcheck , "task_id": taskid]
//        print("parms = \(parms)")
//
//        self.view?.showLoader()
//        ServiceManager.postOrPutApiCall(endPoint: ApiEndpoints.exstreamTaskLocation, parameters: parms as NSDictionary, resultType: ExstreamTaskLocationModel.self) { sucess, result, errormsg in
//            DispatchQueue.main.async {
//                self.view?.hideLoader()
//                if sucess {
//                    guard let response = result else {return}
//                    self.view?.exstreamTaskLocationResponse(response: response)
//                }else {
//                    print("error = \(errormsg ?? "")")
//                }
//
//            }
//
//        }
//    }
    
    
    
    func startOrStopDayTask(){
        
        var parms = [String: Any]()
        parms["distance"] = ""
        parms["device"] = KDeviceModelName
        parms["os_type"] = KOsType
        parms["device_id"] = KDeviceID
        parms["type"] = defaults.string(forKey: "daytype")
        parms["latitude"] = KLat
        parms["longitude"] = KLong
        parms["task_id"] = defaults.string(forKey:UserDefaultsKeys.task_id) ?? ""
        
        print("url \(ApiEndpoints.startDayCrewTask)")
        print("Payload = \(parms)")
        self.view?.showLoader()
        ServiceManager.postOrPutApiCall(endPoint: ApiEndpoints.startDayCrewTask, parameters: parms as NSDictionary, resultType: CrewTaskLogModel.self) { sucess, result, errorMessage in
            DispatchQueue.main.async {
                self.view?.hideLoader()
                if sucess {
                    guard let response = result else {return}
                    self.view?.startStopTaskLogResponse(response: response)
                } else {
                    print("error = \(errorMessage ?? "")")
                }
            }
        }
    }

    
}
