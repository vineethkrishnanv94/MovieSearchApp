//
//  BaseViewController.swift
//  MovieSearchApp
//
//  Created by MAC on 10/14/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var activityView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlertView(heading:String,message:String){
        DispatchQueue.main.async {
            
            let alert = UIAlertController(title: heading, message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func showLoader()
    {
        activityView = UIActivityIndicatorView()
        activityView.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.whiteLarge
        
        activityView.color = UIColor.red
        
        activityView.center = self.view.center
        activityView.startAnimating()
        
        self.view.addSubview(activityView)
    }
    func hideLoader()
    {
        self.activityView.stopAnimating()
        self.activityView.removeFromSuperview()
        
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
