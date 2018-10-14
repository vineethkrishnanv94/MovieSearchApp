//
//  MovieListViewController.swift
//  MovieSearchApp
//
//  Created by MAC on 10/14/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit

class MovieListViewController: BaseViewController {
    let movieListPresenter = MovieListPresenter()
    var movieList = [Movie]()
    var pageCount = 1

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var movieListCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)

        movieListCollectionView.keyboardDismissMode = .onDrag
        movieListPresenter.attachView(view: self)
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.view.endEditing(true)
    }
    
    func callSearchRequest()
    {
        if(ConnectionCheck.isConnectedToNetwork())
        {
            movieListPresenter.getMovieList(searchString: searchTextField.text!, pageCount: pageCount)
            
        }else
        {
            showAlertView(heading: "No Internet connection", message: "Please check your internet connection")
        }
    }
    
    
    @objc func textFieldDidChange(textField: UITextField){
        pageCount = 1
        movieList.removeAll()
        DispatchQueue.main.async {
            self.movieListCollectionView.reloadData()
        }

        callSearchRequest()
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = movieListCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        

        
        flowLayout.invalidateLayout()
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

extension MovieListViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        cell.cellContent = movieList[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenRect: CGRect = collectionView.frame
        let screenWidth: CGFloat = screenRect.size.width
        let cellWidth = Float(screenWidth / 2.0) - 20 //Replace the divisor with the column count requirement. Make sure to have it in float.
        let size = CGSize(width: CGFloat(cellWidth), height: CGFloat(cellWidth))
        
        return size
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailViewController
        controller.selectedMovieItem = movieList[indexPath.item]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == movieList.count{
            pageCount = pageCount + 1
            callSearchRequest()
            
        }
    }
}
extension MovieListViewController : MovieListView
{
    func startLoading() {
        
    }

    func finishLoading(){
    }
    func setMovieList(list:[Movie]){
        self.movieList.append(contentsOf: list)
        DispatchQueue.main.async {
            self.movieListCollectionView.reloadData()
        }
        
    }

}
