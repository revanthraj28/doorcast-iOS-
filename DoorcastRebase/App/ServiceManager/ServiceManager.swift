//
//  ServiceManager.swift
//  AppStructureDemo
//
//  Created by U Dinesh Kumar Reddy on 09/03/22.
//

import UIKit
import Reachability
import MBProgressHUD
import Network

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

struct ApiResultModel : Decodable {
    let resultCode : Int?
    let message : String?
    
    enum CodingKeys: String, CodingKey {
        case resultCode = "resultCode"
        case message = "message"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        resultCode = try values.decodeIfPresent(Int.self, forKey: .resultCode)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
}

enum ApiError: Error {
    case networkError
    case invalidRequest
    case decodeFailed(Error)
    case responseFailed(Error?)
    case serverError
    case nonZeroResultCode(String)
    case unknown
    case endPoint
    case operationFailed
    case invalidEmail
    case invalidPassword
    
    var message: String {
        switch self {
        case .networkError:
           return Message.internetConnectionError
        case .invalidRequest:
            return "Invalid request"
        case .decodeFailed(_):
            return "An error has occurred. Please try again."
//            return "Decoding failed \(error.localizedDescription)"
        case .responseFailed(_):
//            return "Failed to get the response \(error?.localizedDescription ?? "error")"
              return "Failed to get a response"
        case .nonZeroResultCode(let message):
            return message
        case .unknown:
            return "An unknown error has occurred"
        case .operationFailed:
            return "Operation failed"
        case .endPoint:
            return "Error creating endpoint"
        case .invalidEmail:
            return "Email not found."
        case .invalidPassword:
            return "Invalid password"
        case .serverError:
            return "Server busy"
        }
    }
}

class ServiceManager {

    static func setHeaderForRequest(req: inout URLRequest) {
        req.addValue(KContentTypeValue, forHTTPHeaderField: KContentType)
//        req.addValue(tempAccessToken, forHTTPHeaderField: KAccesstoken)
//        if defaults.string(forKey: UserDefaultsKeys.globalAT) != "" {
//            req.addValue("\(defaults.string(forKey: UserDefaultsKeys.globalAT) ?? "")", forHTTPHeaderField: KAccesstoken)
//        } else
        if SessionManager.loginInfo?.data?.accesstoken != "" {
            req.addValue("\(SessionManager.loginInfo?.data?.accesstoken ?? "")", forHTTPHeaderField: KAccesstoken)
        }
//        else {
//
//        }
        print("Access token = \(SessionManager.loginInfo?.data?.accesstoken)")
    }
    
    static func isConnection() -> Bool {
        let reachability = Reachability()
        if reachability!.connection == .none {
            return false
        }
        return true
    }
    

    static func isConnectionWif() -> Bool {
        let reachability = Reachability()
        if reachability!.connection == .wifi {
            return true
        }
        return false
    }

    static func sessionExpired(strCode: String) {
//        DispatchQueue.main.async {
////            debugPrint("Error code=====\(strCode)")
//            DataModel.shared.logout()
//            sceneDelegate.window?.rootViewController?.showAlert(message: Message.sessionExpired, actionBlock: {
//                sceneDelegate.gotoDashboardScreen()
//            })
//        }
    }
    
    static func getApiCall<T: Decodable>(endPoint: String, urlParams: Dictionary<String,String>? = nil, resultType: T.Type, completionHandler:@escaping(Bool, _ result: T?, String?) -> Void) {
        
        if !isConnection() {
            print("Error: you are offline")
            //SwiftLogger.writeToFile(message: "\n \(ApiError.networkError.message)")
            completionHandler(false, nil, ApiError.networkError.message)
            return
        }

        guard var urlComponents = URLComponents(string: "\(BASE_URL)\(endPoint)") else {
            print("Error: cannot create URL")
//            SwiftLogger.writeToFile(message: "\n \(ApiError.invalidRequest.message)")
            completionHandler(false, nil, ApiError.invalidRequest.message)
            return
        }
        print("Get url = \(urlComponents)")
   
        // Append paramaters to url if present
        if let urlParams = urlParams, !urlParams.isEmpty {
            var queryItemsArray:[URLQueryItem] = []
            for (key,value) in urlParams {
                queryItemsArray.append(URLQueryItem(name: key, value: value))
            }
            urlComponents.queryItems = queryItemsArray
        }
        
        guard let completeEndpointURL = urlComponents.url else {
            print("Error: cannot create URL")
            completionHandler(false, nil, ApiError.invalidRequest.message)
            return
        }
        
        // Create the url request
        var request = URLRequest(url: completeEndpointURL)
//        SwiftLogger.writeToFile(message: "\n \(kEndPoint) \(completeEndpointURL) \n ")
        request.httpMethod = HTTPMethod.get.rawValue
        
        /* set reqeust header and platform*/
        self.setHeaderForRequest(req: &request)
        print("Request for \(endPoint) :: \(request)")
        
        // If you are using Basic Authentication uncomment the follow line and add your base64 string
        //        request.setValue("Basic MY_BASIC_AUTH_STRING", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            print("Response for \(String(describing: response?.url?.absoluteURL)) :: \(String(describing: response))")
            
            /*Chick session status*/
            guard let response = response as? HTTPURLResponse else {return}
            print("****** Get api Response status code = \(response.statusCode)")
            if response.statusCode == 403 {

                self.sessionExpired(strCode: "\(response.statusCode)")
                return
            }
            
            guard error == nil else {
                print("Error: error calling GET")
                print(error!)

                completionHandler(false, nil, ApiError.responseFailed(error).message)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")

                completionHandler(false, nil, ApiError.responseFailed(error).message)
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed, statuscode = \(response.statusCode)")
                if response.statusCode == 401 {
                    completionHandler(false, nil, ApiError.invalidEmail.message)
                } else if response.statusCode == 402 {
                    completionHandler(false, nil, ApiError.invalidPassword.message)
                } else {
                    completionHandler(false, nil, ApiError.responseFailed(error).message)
                }
                return
            }
            guard let response = response as? HTTPURLResponse else {
                print("Error: Email doesn't exist, status code = \(response.statusCode)")
                completionHandler(false, nil, ApiError.invalidEmail.message)
                return
            }
            do {
//                print(String(data: data, encoding: .utf8)!)
                guard let result = try JSONDecoder().decode(T?.self, from: data)else {
                    print("Error: Cannot decode the object")
                    completionHandler(false, nil, ApiError.decodeFailed(error!).message)
                    return
                }
                let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)

                completionHandler(true, result, nil)
            } catch {
                print("Error: Trying to convert JSON data to string")
                print(error.localizedDescription)
                print(error)

                completionHandler(false, nil, ApiError.unknown.message)
                return
            }
        }.resume()
    }
    
    
    static func getApiCallForJson<T: Decodable>(endPoint: String, resultType: T.Type, completionHandler:@escaping(Bool, _ result: T?, String?) -> Void) {
        
        if !isConnection() {
            print("Error: you are offline")

            completionHandler(false, nil, ApiError.networkError.message)
            return
        }
        guard let strurl = URL(string: "\(BASE_URL)\(endPoint)") else {
            print("Error: cannot create URL")

            completionHandler(false, nil, ApiError.invalidRequest.message)
            return
        }
        // Create the url request
        var request = URLRequest(url: strurl)
        request.addValue(KContentTypeValue, forHTTPHeaderField: KContentType)
        request.addValue(KAcceptValue, forHTTPHeaderField: KAccept)
        request.addValue(KPlatformValue, forHTTPHeaderField: KPlatform)
        
        request.httpMethod = HTTPMethod.get.rawValue
        
        print("Request for \(endPoint) :: \(request)")
        
        // If you are using Basic Authentication uncomment the follow line and add your base64 string
        //        request.setValue("Basic MY_BASIC_AUTH_STRING", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            /*Chick session status*/
            guard let response = response as? HTTPURLResponse else {return}
            if response.statusCode == 403 {
                
                self.sessionExpired(strCode: "\(response.statusCode)")
                completionHandler(false, nil, nil)
                return
            }
            
            guard error == nil else {
                print("Error: error calling GET")
                print(error!)
                
                completionHandler(false, nil, ApiError.responseFailed(error).message)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                
                completionHandler(false, nil, ApiError.responseFailed(error).message)
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                 
                completionHandler(false, nil, ApiError.responseFailed(error).message)
                return
            }
            do {
                guard let result = try JSONDecoder().decode(T?.self, from: data)else {
                    print("Error: Cannot decode the object")
                    
                    completionHandler(false, nil, ApiError.decodeFailed(error!).message)
                    return
                }
                let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print(json as? [String: Any] ?? [:])
                
                completionHandler(true, result, nil)
            } catch {
                print("Error: Trying to convert JSON data to string")
                print(error.localizedDescription)
                print(error)
                
                completionHandler(false, nil, ApiError.unknown.message)
                return
            }
        }.resume()
    }
    
    /*
    static func getApiCallForForPlaying<T: Decodable>(endPoint: String, resultType: T.Type, completionHandler:@escaping(Bool, _ result: T?, String?) -> Void) {
        
        if !isConnection() {
            print("Error: you are offline")
            completionHandler(false, nil, ApiError.networkError.message)
            return
        }
        guard let strurl = URL(string: "\(endPoint)") else {
            print("Error: cannot create URL")
            completionHandler(false, nil, ApiError.invalidRequest.message)
            return
        }
        // Create the url request
        var request = URLRequest(url: strurl)
        //        if let authToken = DataModel.shared.sessionId {
        //            request.addValue("\(authToken)", forHTTPHeaderField: "Authorization")
        //        }
        request.httpMethod = HTTPMethod.get.rawValue
        
        // If you are using Basic Authentication uncomment the follow line and add your base64 string
        //        request.setValue("Basic MY_BASIC_AUTH_STRING", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling GET")
                print(error!)
                completionHandler(false, nil, ApiError.responseFailed(error).message)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                completionHandler(false, nil, ApiError.responseFailed(error).message)
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                completionHandler(false, nil, ApiError.responseFailed(error).message)
                return
            }
            do {
                guard let result = try JSONDecoder().decode(T?.self, from: data)else {
                    print("Error: Cannot decode the object")
                    completionHandler(false, nil, ApiError.decodeFailed(error!).message)
                    return
                }
                completionHandler(true, result, nil)
            } catch {
                print("Error: Trying to convert JSON data to string")
                print(error.localizedDescription)
                print(error)
                completionHandler(false, nil, ApiError.unknown.message)
                return
            }
        }.resume()
    }
*/
    
    static func postOrPutApiCall<T: Decodable>(authorization: Bool = false, endPoint: String, urlParams: Dictionary<String,String>? = nil, parameters: NSDictionary? = nil, methodType: HTTPMethod = .post, resultType: T.Type, completionHandler:@escaping(Bool, _ result: T?, String?) -> Void) {
        if !isConnection() {
            print("Error: you are offline")
            
            completionHandler(false, nil, ApiError.networkError.message)
            return
        }
        
        
        guard var urlComponents = URLComponents(string: "\(BASE_URL)\(endPoint)") else {
            print("Error: cannot create URL")
            
            completionHandler(false, nil, ApiError.invalidRequest.message)
            return
        }
   
        // Append paramaters to url if present
        if let urlParams = urlParams, !urlParams.isEmpty {
            var queryItemsArray:[URLQueryItem] = []
            for (key,value) in urlParams {
                queryItemsArray.append(URLQueryItem(name: key, value: value))
            }
            urlComponents.queryItems = queryItemsArray
        }
        
        guard let completeEndpointURL = urlComponents.url else {
            print("Error: cannot create URL")
            completionHandler(false, nil, ApiError.invalidRequest.message)
            return
        }
        
        // Create the url request
        print("URL endpoint :: \(completeEndpointURL)")
        var request = URLRequest(url: completeEndpointURL)
        
        request.httpMethod = methodType.rawValue
        
        /* set reqeust header and platform*/
        self.setHeaderForRequest(req: &request)
        
        if let params = parameters // this block run only for post api
        {
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted) // pass dictionary to data object and set it as request body
            } catch let error {
                print(error.localizedDescription)
                completionHandler(false, nil, ApiError.unknown.message)
            }
        }
        
        print("Request for \(endPoint) :: \(request)")
        
        // If you are using Basic Authentication uncomment the follow line and add your base64 string
        //        request.setValue("Basic MY_BASIC_AUTH_STRING", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            /*Chick session status*/
            guard let response = response as? HTTPURLResponse else {
                print("Error in response")
                completionHandler(false, nil, ApiError.serverError.message)
                return
            }
            print("****** Post api Response status code = \(response.statusCode)")
            if response.statusCode == 403 {
                completionHandler(false, nil, Message.sessionExpired)
                self.sessionExpired(strCode: "\(response.statusCode)")
                return
            }
            
            guard error == nil else {
                print("Error: error calling GET")
                print(error!)
                
                completionHandler(false, nil, ApiError.responseFailed(error).message)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                
                completionHandler(false, nil, ApiError.responseFailed(error).message)
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed, status code = \(response.statusCode)")
                if response.statusCode == 401 {
                    completionHandler(false, nil, ApiError.invalidEmail.message)
                } else if response.statusCode == 402 {
                    completionHandler(false, nil, ApiError.invalidPassword.message)
                } else {
                    completionHandler(false, nil, ApiError.responseFailed(error).message)
                }
                
                return
            }
            do {
//                debugPrint("header=====\(response.allHeaderFields)")
//                print(String(data: data, encoding: .utf8)!)
                guard let result = try JSONDecoder().decode(T?.self, from: data)else {
                    print("Error: Cannot decode the object")
                    
                    completionHandler(false, nil, ApiError.decodeFailed(error!).message)
                    return
                }
                if let authToken =  response.allHeaderFields["Authorization"] as? String {
//                    debugPrint("header=====\(authToken)")
//                    DataModel.shared.authToken = authToken
                }
                let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                completionHandler(true, result, nil)
            } catch {
                print("Error: Trying to convert JSON data to string")
                print(error)
                
                completionHandler(false, nil, ApiError.unknown.message)
                return
            }
        }.resume()
    }
    
    static func uploadFile<T: Decodable>(endPoint: String, urlParams: Dictionary<String,String>? = nil, fileParameterName: String, fileName: String, fileData: Data, fileContentType: String, resultType: T.Type, completionHandler:@escaping(Bool, _ result: T?, String?) -> Void) {
        if !isConnection() {
            print("Error: you are offline")
            completionHandler(false, nil, ApiError.networkError.message)
            return
        }
        
        guard var urlComponents = URLComponents(string: "\(BASE_URL)\(endPoint)") else {
            print("Error: cannot create URL")
            completionHandler(false, nil, ApiError.invalidRequest.message)
            return
        }
   
        // Append paramaters to url if present
        if let urlParams = urlParams, !urlParams.isEmpty {
            var queryItemsArray:[URLQueryItem] = []
            for (key,value) in urlParams {
                queryItemsArray.append(URLQueryItem(name: key, value: value))
            }
            urlComponents.queryItems = queryItemsArray
        }
        
        guard let completeEndpointURL = urlComponents.url else {
            print("Error: cannot create URL")
            completionHandler(false, nil, ApiError.invalidRequest.message)
            return
        }
        
        // Create the url request
        print("URL endpoint :: \(completeEndpointURL)")
        var request = URLRequest(url: completeEndpointURL)
        request.httpMethod = HTTPMethod.post.rawValue
        
        // generate boundary string using a unique per-app string
        
        let boundary = UUID().uuidString
        let session = URLSession.shared
        
        ///Add a access Token
        
//        if let authToken = DataModel.shared.sessionId {
//            request.addValue("\(authToken)", forHTTPHeaderField: KAuthorization)
//        }
        
        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: KContentType)
        var data = Data()
        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(fileParameterName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: \(fileContentType)\r\n\r\n".data(using: .utf8)!)
        data.append(fileData)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        // Send a POST request to the URL, with the data we created earlier
        print(request)
        session.uploadTask(with: request, from: data, completionHandler: { (data, response, error) in
            do {
                //do whatever want with the response here
                guard error == nil else {
                    print("Error: error calling POST")
                    print(error!)
                    completionHandler(false, nil, ApiError.responseFailed(error).message)
                    return
                }
                guard let data = data else {
                    print("Error: Did not receive data")
                    completionHandler(false, nil, ApiError.responseFailed(error).message)
                    return
                }
                guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                    print("Error: HTTP request failed")
                    completionHandler(false, nil, ApiError.responseFailed(error).message)
                    return
                }
                do {
                    guard let result = try JSONDecoder().decode(T?.self, from: data)else {
                        print("Error: Cannot decode the object")
                        completionHandler(false, nil, ApiError.decodeFailed(error!).message)
                        return
                    }
                    completionHandler(true, result, nil)
                } catch {
                    print("Error: Trying to convert JSON data to string")
                    completionHandler(false, nil, ApiError.unknown.message)
                    return
                }
            }}).resume()
    }
 
    
//    static func uploadImage<T: Decodable>(paramName: String, fileName: String, image: UIImage , resultType: T.Type, completionHandler:@escaping(Bool, _ result: T?, String?) -> Void) {
//
//
//        let urlPath = "\(BASE_URL)\(endPoint)"
//        guard let finalURL = URL(string: urlPath) else {
//            print("Error creating endpoint")
//
//            return
//        }
//
//        // generate boundary string using a unique per-app string
//
//        let boundary = UUID().uuidString
//
//        let session = URLSession.shared
//
//        // Set the URLRequest to POST and to the specified URL
//
//        var urlRequest = URLRequest(url: finalURL)
//
//
//        urlRequest.httpMethod = HTTPMethod.post.rawValue
//
////        if let authToken = DataModel.shared.sessionId {
////            urlRequest.addValue("\(authToken)", forHTTPHeaderField: KAuthorization)
////        }
////        if let deviceId = DataModel.shared.deviceId {
////            urlRequest.addValue("\(deviceId)", forHTTPHeaderField: KDEVICE_ID)
////        }
//
//
//        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
//        // And the boundary is also set here
//        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: KContentType)
//        var data = Data()
//
//        // Add the image data to the raw http request data
//        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
//        data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
//        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
//        if let imageData = image.jpegData(compressionQuality: 1.0) {
//            data.append(imageData)
//        }
//        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
//
//        // Send a POST request to the URL, with the data we created earlier
//        print(urlRequest)
//        session.uploadTask(with: urlRequest, from: data, completionHandler: { (data, response, error) in
//            do {
//                /*Chick session status*/
//                guard let response = response as? HTTPURLResponse else {return}
//                if response.statusCode == 403 {
//
//                    self.sessionExpired(strCode: "\(response.statusCode)")
//                    return
//                }
//
//                //do whatever want with the response here
//                guard error == nil else {
//                    print("Error: error calling GET")
//                    print(error!)
//
//                    completionHandler(false, nil, ApiError.responseFailed(error).message)
//                    return
//                }
//                guard let data = data else {
//                    print("Error: Did not receive data")
//
//                    completionHandler(false, nil, ApiError.responseFailed(error).message)
//                    return
//                }
//                guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
//                    print("Error: HTTP request failed")
//
//                    completionHandler(false, nil, ApiError.responseFailed(error).message)
//                    return
//                }
//                do {
//                    guard let result = try JSONDecoder().decode(T?.self, from: data)else {
//                        print("Error: Cannot decode the object")
//
//                        completionHandler(false, nil, ApiError.decodeFailed(error!).message)
//                        return
//                    }
//                    print(result)
//                    let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
//
//                    completionHandler(true, result, nil)
//                } catch {
//                    print("Error: Trying to convert JSON data to string")
//
//                    completionHandler(false, nil, ApiError.unknown.message)
//                    return
//                }
//            }}).resume()
//    }
    
    static func deleteApiCall<T: Decodable>(endPoint: String, resultType: T.Type, completionHandler:@escaping(Bool, _ result: T?, String?) -> Void) {
        if !isConnection() {
            print("Error: you are offline")
            
            completionHandler(false, nil, ApiError.networkError.message)
            return
        }
        guard let strurl = URL(string: "\(BASE_URL)\(endPoint)") else {
            print("Error: cannot create URL")
            
            completionHandler(false, nil, ApiError.invalidRequest.message)
            return
        }
        // Create the url request
        print("URL endpoint :: \(strurl)")
        
        var request = URLRequest(url: strurl)
        request.httpMethod = HTTPMethod.delete.rawValue
        
//        if let deviceId = DataModel.shared.deviceId {
//            request.addValue("\(deviceId)", forHTTPHeaderField: KDEVICE_ID)
//        }
        // If you are using Basic Authentication uncomment the follow line and add your base64 string
        //        request.setValue("Basic MY_BASIC_AUTH_STRING", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            /*Chick session status*/
            guard let response = response as? HTTPURLResponse else {return}
            if response.statusCode == 403 {
                
                self.sessionExpired(strCode: "\(response.statusCode)")
                return
            }
            
            guard error == nil else {
                print("Error: error calling GET")
                print(error!)
                
                completionHandler(false, nil, ApiError.responseFailed(error).message)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                
                completionHandler(false, nil, ApiError.responseFailed(error).message)
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                
                completionHandler(false, nil, ApiError.responseFailed(error).message)
                return
            }
            do {
                guard let result = try JSONDecoder().decode(T?.self, from: data)else {
                    print("Error: Cannot decode the object")
                    
                    completionHandler(false, nil, ApiError.decodeFailed(error!).message)
                    return
                }
                let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                completionHandler(true, result, nil)
            } catch {
                print("Error: Trying to convert JSON data to string")
                
                completionHandler(false, nil, ApiError.unknown.message)
                return
            }
        }.resume()
    }
    
    /// To send an array in request
    static func sendArrayRequest<T: Decodable>(data: Data, endPoint: String, resultType: T.Type, completionHandler:@escaping(Bool, _ result: T?, String?) -> Void) {
        
        //        guard let userId = DataModel.shared.userUniqueId else {
        //            return
        //        }
        let urlPath = "\(BASE_URL)\(endPoint)"
        guard let finalURL = URL(string: urlPath) else {
            print("Error creating endpoint")
            
            return
        }
        var request = URLRequest(url: finalURL,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling GET")
                print(error!)
                
                completionHandler(false, nil, ApiError.responseFailed(error).message)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                
                completionHandler(false, nil, ApiError.responseFailed(error).message)
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                
                completionHandler(false, nil, ApiError.responseFailed(error).message)
                return
            }
            do {
                guard let result = try JSONDecoder().decode(T?.self, from: data)else {
                    print("Error: Cannot decode the object")
                    
                    completionHandler(false, nil, ApiError.decodeFailed(error!).message)
                    return
                }
                let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                completionHandler(true, result, nil)
            } catch {
                print("Error: Trying to convert JSON data to string")
                print(error.localizedDescription)
                print(error)
                
                completionHandler(false, nil, ApiError.unknown.message)
                return
            }
        }
        
        task.resume()
    }
    
    static func getNetworkType() -> NetworkType {
        let reachability = try? Reachability()
        if reachability!.connection == .none {
            return .NONE
        } else if reachability?.connection == .cellular {
            return .CELLULAR
        } else if reachability?.connection == .wifi {
            return .WIFI
        }
        return .NONE
    }
}

enum NetworkType {
    case WIFI
    case CELLULAR
    case NONE
}
