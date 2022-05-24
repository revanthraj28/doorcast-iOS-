//
//  Constants.swift
//  DoorcastRebase
//
//  Created by U Dinesh Kumar Reddy on 04/05/22.
//

import Foundation
import UIKit
/*SETTING USER DEFAULTS*/
let defaults = UserDefaults.standard

let loginResponseDefaultKey = "LoginResponse"
let KPlatform = "Platform"
let KPlatformValue = "iOS"
let KContentType = "Content-Type"
let KContentTypeValue = "application/json"
let KAccept = "Accept"
let KAcceptValue = "application/json"
let KAuthorization = "Authorization"
//let KDEVICE_ID = "DEVICE_ID"
let KAccesstoken = "Accesstoken"



let KDeviceID = UIDevice.current.identifierForVendor!.uuidString
let KDeviceModelName = UIDevice.modelName
let KOsType = UIDevice.current.systemVersion
var showproperty = String()
var crewPropertyIds = [String]()
var crewPropertyALLIds = [String]()
var timerBool = false
var KLat = String()
var KLong = String()
var incompleteScreen = String()

let GlobelAccessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.Im94Zm9yZCBjYXBzIg._nKgScZrZagPYMtl2D9cYgxsBV_EoDgqmuMFGDuEAek"

var BASE_URL = defaults.string(forKey: UserDefaultsKeys.Base_url) ?? "https://staging.doorcast.tech/api/"

/* URL endpoints */
struct ApiEndpoints {
    static let UpdateProfilenApi = "update_empdetails"
    
    static let crewLoginApi = "exstream_crewlogin"
    static let getOrganizationApi = "get_organizations"
    static let newTaskListApi = "exstream_newtaskList"
    static let crewlogoutApi = "signout"
    static let crewpropertyApi = "getproperty_Org"
    static let ForgotPasswordApi = "exstream_forgotPassword"
    static let ResendOTPApi = "exstream_resendOtp"
    static let ResetPasswordApi = "exstream_resetPassword"
    static let SubTaskListApi = "exstream-sub-task"
    static let ReassignCrewApi = "exstream_getUserCompeltedTask"
    static let ReassignApi = "exstream_reassignTask"
    static let getCrewListApi = "exstream_getCrewList"
    static let AddCrewApi = "exstream_add_crew"
    static let forceFinishApi = "exstream_getInprogressTaskUser"
    static let forceStop = "exstream_forceStop"
    static let startDayCrewTask = "exstream_crewTaskLog"
    
    static let exstreamTaskLocation = "exstream_TaskLocation"
}

/*App messages*/
struct Message {
    static let internetConnectionError = "Please check your connection and try reconnecting to internet"
    static let sessionExpired = "Your session has been expired, please login again"
}


/*USER ENTERED DETAILS DEFAULTS*/

struct UserDefaultsKeys {
    static var userLoggedIn = "userLoggedIn"
    static var loggedInStatus = "loggedInStatus"
    static var globalAT = "globalAT"
    static var Base_url = "Base_url"
    static var task_id = "task_id"
    static var task_id_cipher = "task_id_cipher"
    static var taskname = "taskname"
    static var group_id = "group_id"
    static var task_type = "task_type"
    static var property_id = "propertyid"
    static var crew_list = "crew_list"
    static var task_list = "task_list"
    static var address = "address"
    static var org_id  = "org_id"
    static var propertyname = "propertyname"
    static var role_name = "role_name"
    static var screenlanding = "screen_landing"
}


struct sessionMgrDefaults {
    
    static var userLoggedIn = "username"
    static var loggedInStatus = "email"
    static var globalAT = "mobile_no"
    static var Base_url = "accesstoken"
}



/*LOCAL JSON FILES*/
struct LocalJsonFiles {
    static var incompleteTaskDetails = "IncompleteTaskDetails"
    static var ForceFinish = "ForceFinish"
}
