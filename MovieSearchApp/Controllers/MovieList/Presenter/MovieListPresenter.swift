//
//  MovieListPresenter.swift
//  MovieSearchApp
//
//  Created by MAC on 10/14/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import Foundation
protocol MovieListView:NSObjectProtocol
{
    func startLoading()
    func finishLoading()
    func setMovieList(list:[Movie])
}
class MovieListPresenter
{
    fileprivate var movieListView : MovieListView?
    func attachView(view : MovieListView)
    {
        movieListView = view
    }
    func detachView()
    {
        movieListView = nil
    }
    func getMovieList(searchString:String,pageCount:Int)
    {
        movieListView?.startLoading()
        
        WebServiceManager.sharedInstance.getMovieSearchList(searchText: searchString, page: pageCount){ (status, message, responseObject, error) in
            
            if(status == true)
            {
                self.movieListView?.finishLoading()

                if let response = responseObject as? [Movie]
                {
                    self.movieListView?.setMovieList(list: response)

                }

                
            }
            else
            {
                self.movieListView?.finishLoading()

                print("wooohhhhh failed")
                
            }
        

    }
}
}
