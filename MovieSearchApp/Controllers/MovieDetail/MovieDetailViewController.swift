//
//  MovieDetailViewController.swift
//  MovieSearchApp
//
//  Created by MAC on 10/14/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit

class MovieDetailViewController: BaseViewController {
    
    @IBOutlet weak var movieDetailTableView: UITableView!
    
    @IBOutlet weak var posterImageView: UIImageView!
    var selectedMovieItem : Movie?
    let movieDetailPresenter = MovieDetailPresenter()
    var movieDetailList = [movieDetail]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieDetailPresenter.attachView(view: self)

        if let item = selectedMovieItem
        {
            movieDetailPresenter.getMovieDetails(item: item)

            if let image = item.poster
            {
                posterImageView.sd_setImage(with: URL(string: image))

            }

        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension MovieDetailViewController : UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieDetailList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieDetailTableViewCell", for: indexPath) as! MovieDetailTableViewCell
        cell.cellContent = movieDetailList[indexPath.row]
        return cell
    }
}
extension MovieDetailViewController : MovieDetailView
{
    func startLoading()
    {
    }
    func finishLoading(){
    }
    func setMovieDetailList(list:[movieDetail])
    {
        movieDetailList = list
        DispatchQueue.main.async {
            self.movieDetailTableView.reloadData()
        }
        
    }
}
