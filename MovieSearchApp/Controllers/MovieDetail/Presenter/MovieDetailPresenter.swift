//
//  MovieDetailPresenter.swift
//  MovieSearchApp
//
//  Created by MAC on 10/14/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import Foundation
struct movieDetail{
    var type : String?
    var value :String?
}
protocol MovieDetailView:NSObjectProtocol
{
    func startLoading()
    func finishLoading()
    func setMovieDetailList(list:[movieDetail])
}
class MovieDetailPresenter{
    fileprivate var movieDetailView : MovieDetailView?
    func attachView(view : MovieDetailView)
    {
        movieDetailView = view
    }
    func detachView()
    {
        movieDetailView = nil
    }
    func getMovieDetails(item:Movie){
        var list = [movieDetail]()
        
        if let title = item.title
        {
            var titleItem = movieDetail()
            titleItem.value = title
            titleItem.type = "Title"
            list.append(titleItem)
        }
        if let type = item.type
        {
            var typeItem = movieDetail()
            typeItem.value = type
            typeItem.type = "Type"
            list.append(typeItem)

        }
        
        if let imdbID = item.imdbID
        {
            var imdbIDItem = movieDetail()
            imdbIDItem.value = imdbID
            imdbIDItem.type = "ImdbID"
            list.append(imdbIDItem)
            
        }
        if let year = item.year
        {
            var yearItem = movieDetail()
            yearItem.value = year
            yearItem.type = "Year"
            list.append(yearItem)
            
        }
        movieDetailView?.setMovieDetailList(list: list)
    }
    
}
