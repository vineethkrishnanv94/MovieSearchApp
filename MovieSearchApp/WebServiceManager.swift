//
//  WebServiceManager.swift
//  SalesTracker
//
//  Created by Arunkumar KM on 03/08/16.
//  Copyright © 2016 ST. All rights reserved.

import UIKit
import Alamofire
import SwiftyJSON
//import MBProgressHUD

class WebServiceManager: NSObject {
    //    var authToken = UserDefaults.standard.value(forKey: "user_auth_token") as! String
    static let sharedInstance = WebServiceManager()
    var webMethodType:ServiceMethodType = ServiceMethodType.none
    var completionHandler:WebServiceCompletionHandler?
    var downloadCompletionHandler:downloaderCompletionHandler?
    var showConnectivityErrorMessage:Bool = true
    var showLoadingIndicator:Bool = true
    
    //    var hud:MBProgressHUD?
    
    var httpHeaders = [
        
        WS_Param_Key_ApiKey: WS_ApiKey,
        WS_Param_Key_ContentType: WS_ContentType
    ]
    
    
    
    
    
    
    //MARK:- Functions corresponding to each endpoint
    
    
    //MARK:- Restaurant
    /**
     * Restaurant Category List Web Service
     
     - parameter handler:  completion block with results
     */
    
    func cancelCurrentRequest()
    {
        
        let sessionManager = Alamofire.SessionManager.default
        sessionManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
        
    }
    
    
    
    
    
    func getMovieSearchList(searchText:String,page:Int,fghandler:WebServiceCompletionHandler?)
    {
        self.webMethodType = ServiceMethodType.movieSearch
        self.completionHandler = fghandler
        let parameters = ["s":searchText,"page":page,"apikey":OMDB_API_KEY] as [String : AnyObject]
        self.sendWebServiceRequest(requestJsonDict: parameters, webServiceMethod: "", httpMethodType: .get, headers: nil)
    }
    
  
    
    
    //MARK:- WEB SERVICE CORE FUNCTIONALITY MODULE
    
    /**
     To set up initial configurations for all web services
     
     Checks network connectivity, appends session tokens if needed
     
     
     - returns: status
     */
    
    private func setUpInitialConfigurations() -> Bool {
        
        let connectivityError:NSError!
        var callService:Bool = true
        
        /* if ( self.showConnectivityErrorMessage == true ) {
         
         callService = STAppController.sharedInstance.isConnectivityAvailable()
         }
         
         if callService == false {
         
         connectivityError = NSError(domain:noInternetConnectivityError, code:noInternetConnectivityErrorCode, userInfo:nil)
         self.handleFailureResponse(connectivityError)
         
         STCommon.sharedInstance.showNoInternetConnectivityMessage()
         }
         
         if callService == true {
         
         if self.isSessionTokenNeeded() == true {
         
         httpHeaders[WS_Param_Key_SessionToken] = STWebServiceUtility.sharedInstance.getApiSessionToken()
         }
         }*/
        
        return callService
    }
    
    /**
     To determine if session token is needed
     
     - returns: status
     */
    
    func isSessionTokenNeeded() -> Bool {
        
        var needed:Bool = true
        
        switch self.webMethodType {
            
            //        case .Login, .ForgotPassword, .Registration:
        //            needed = false
        default:
            needed = true
        }
        
        return needed
    }
    
    //MARK: Parsing dispatcher methods
    
    /**
     To pass valid data to appropriate response parsers. Creates error in case failure / data format mismatches
     
     - parameter data: response data
     */
    
    func handleSuccessResponse(data:NSData?) {
        
        //        let customError = NSError(domain:WS_Error_NoData, code: WS_ErrorCode_NoData, userInfo: nil)
        //        self.handleFailureResponse(error: customError)
        
        if let responseData = data {
            
            
            do
            {
                
                if let json:JSON = try JSON(data:responseData as Data) {
                    
                    let responseParser:ResponseParser = ResponseParser()
                    responseParser.parseWithResponse(json: json, serviceMethodType:self.webMethodType, completionHandler: { [weak self](status, message, responseObject, error) -> Void in
                        
                        if let ref = self {
                            
                            if let handler = ref.completionHandler {
                                
                                print("Parsing executed  #123\(status)")
                                
                                handler(status, message, responseObject, error)
                            }
                        }
                    })
                    
                } else {
                    
                    if let handler = self.completionHandler {
                        
                        let customError = NSError(domain:WS_Error_DataFormat, code: WS_ErrorCode_DataFormat, userInfo: nil)
                        print("Parsing not executed  #6")
                        
                        handler(false, nil, nil, customError)
                    }
                }
                
                
                
            }
            catch {
                print(error)
            }
            
            
            
        } else {
            
            print("Parsing not executed  #7")
            
            let customError = NSError(domain:WS_Error_NoData, code: WS_ErrorCode_NoData, userInfo: nil)
            self.handleFailureResponse(error: customError)
        }
    }
    
    
    
    //MARK: Web service failure handlers
    
    func handleFailureResponse(error:NSError) {
        
        if let handler = self.completionHandler {
            
            handler(false, nil, nil , error)
        }
    }
    
    /**
     Cooks and send HTTP errors according to HTTP error codes
     
     - parameter statusCode:
     */
    
    func handleErrorWithHttpStatusCode(statusCode:Int) {
        
        let error:NSError!
        
        switch statusCode
        {
        case 400:
            error = NSError(domain:WS_HTTP_Error_BadRequest, code:WS_HTTP_ErrorCode_BadRequest, userInfo:nil)
        case 401:
            error = NSError(domain:WS_HTTP_Error_UnAuthorizedAccess, code:WS_HTTP_ErrorCode_UnAuthorizedAccess, userInfo:nil)
        case 403:
            error = NSError(domain:WS_HTTP_Error_Forbidden, code:WS_HTTP_ErrorCode_Forbidden, userInfo:nil)
        case 404:
            error = NSError(domain:WS_HTTP_Error_ResourceNotFound, code:WS_HTTP_ErrorCode_ResourceNotFound, userInfo:nil)
        case 408:
            error = NSError(domain:WS_HTTP_Error_TimeOut, code:WS_HTTP_ErrorCode_TimeOut, userInfo:nil)
            
            if let handler = self.completionHandler
            {
                handler(false, "Sorry", "You cannot proceed because you have lost internet connection.Please make sure you have active WIFI or data connection enabled" as AnyObject?, error)
            }
            
            
        default:
            error = NSError(domain:WS_HTTP_Error_Other, code:WS_HTTP_ErrorCode_Other, userInfo:nil)
        }
        
        if self.showConnectivityErrorMessage == true {
            
            //            STCommon.sharedInstance.showServerConnectivityMessage()
        }
        
        //        self.handleSuccessResponse(data: error)
    }
    
    //MARK: Core functions that do web service access
    
    /**
     Web Service request
     
     - parameter requestJsonDict: parameters
     - parameter sMethod:         web method name like Login, Logout etc...
     - parameter mType:           HTTP method type like POST, GET etc....
     */
    
    func sendWebServiceRequest(requestJsonDict:[String:AnyObject]?, webServiceMethod sMethod:String, httpMethodType mType:HttpMethod,headers:HTTPHeaders?) {
        
        
        let url = "\(baseUrl)\(sMethod)"
        
        print(mType)
        var methodType : HTTPMethod
        if mType == .post {
            methodType = .post
        }
        else
        {
            methodType = .get
        }
        Alamofire.request(url, method: methodType, parameters: requestJsonDict, encoding: URLEncoding.queryString, headers: headers).responseJSON { response in
            
            
            print("request",response.request)
            print("response",response.description)
            
            if response.response != nil
            {
                if let obj = response.result.value {
                    
                    print("JSON: \(obj)")
                    
                }
                
                
                
                print("original request",response.request ?? 00)  // original URL request
                print("response",response.response) // URL response
                //print(response.data)     // server data
                print("result",response.result)   // result of response serialization
                print("response status code",response.response?.statusCode) // status code
                
                if let statusCode = response.response?.statusCode {
                    
                    var status = 0
                    if(statusCode == WS_HTTP_CreatedCode)
                    {
                        status = WS_HTTP_SuccessCode
                    }
                    else
                    {
                        status = statusCode
                    }
                    
                    if  (status != WS_HTTP_SuccessCode) {
                        
                        do
                        {
                            if let json:JSON = try JSON(data:response.data!  as Data)
                            {
                                let responseParser:ResponseParser = ResponseParser()
                                
                                
                                if let handler = self.completionHandler {
                                    
                                    handler(false, nil, nil , nil)
                                }
                                
                                
                                
                            }
                        }
                        catch
                        {}
                        
                    }
                    else {
                        
                        switch response.result {
                            
                        case .success:
                            
                            if let obj = response.result.value {
                                
                                print("NEW JSON: \(obj)")
                                
                                
                                self.handleSuccessResponse(data: response.data as NSData?)
                            }
                            
                        case .failure(let error):
                            
                            self.handleFailureResponse(error: error as NSError)
                            if let handler = self.completionHandler {
                                
                                handler(false, nil, nil , nil)
                            }
                        }
                    }
                }
                else
                {
                    if self.showConnectivityErrorMessage == true {
                        
                        
                    }
                    
                    let error:NSError = NSError(domain:WS_Error_NoData, code:WS_ErrorCode_NoData, userInfo: nil)
                    self.handleFailureResponse(error: error)
                }
            }
            else
            {
                if self.showConnectivityErrorMessage == true {
                    
                }
                
                let error:NSError = NSError(domain:WS_Error_NoData, code:WS_ErrorCode_NoData, userInfo: nil)
                self.handleFailureResponse(error: error)
            }
        }
        
        
    }
    
    
    
    
    //MARK:- memory
    
    deinit {
        print("Web Service manager de-allocated")
    }
}
