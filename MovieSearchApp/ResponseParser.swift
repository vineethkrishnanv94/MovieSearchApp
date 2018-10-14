    
    //
    //  ResponseParser.swift
    //  ItzPremium
    //
    //  Created by Arunkumar KM on 03/08/16.
    //  Copyright © 2017. All rights reserved.
    
    
    import UIKit
    import SwiftyJSON
    import CoreLocation
    
    class ResponseParser: NSObject {
        
        //MARK:- USER
        
        
        private func parseMoviesList(json:JSON, completionHandler handler:WebServiceCompletionHandler) {
            print("Cabs Parsing executed")
            
            // Parse all cabs details
            let movieListArray =  json["Search"].arrayValue.map { (movieObj) -> Movie in
                
                let movieObject = Movie()
                
                
                if let title = movieObj.dictionaryValue["Title"]{
                    movieObject.title = title.stringValue
                }
                
                if let year = movieObj.dictionaryValue["Year"]{
                    movieObject.year = year.stringValue
                }
                if let imdbID = movieObj.dictionaryValue["imdbID"]{
                    movieObject.imdbID = imdbID.stringValue
                }
                if let type = movieObj.dictionaryValue["Type"]{
                    movieObject.type = type.stringValue
                }
                if let poster = movieObj.dictionaryValue["Poster"]{
                    movieObject.poster = poster.stringValue
                }
                
                return movieObject
            }
            handler(true, nil, movieListArray as AnyObject?, nil)
        }
        
        
        
        //MARK:- Basic parser method to parse the Skelton of the response
        
        func parseWithResponse(json:JSON, serviceMethodType methodType:ServiceMethodType, completionHandler handler:WebServiceCompletionHandler)
        {
            
            
            
            print("Parsing not executed  #3")
            
            switch(methodType){
            case .movieSearch:
                parseMoviesList(json: json, completionHandler: handler)
            default:
                print("Method not specified")
            }
            
        }
    
    
    }
