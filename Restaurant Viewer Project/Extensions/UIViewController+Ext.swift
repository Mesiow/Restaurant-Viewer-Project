//
//  UIViewController+Ext.swift
//  Restaurant Viewer Project
//
//  Created by Chris W on 1/31/25.
//

import UIKit

fileprivate var aView: UIView?

extension UIViewController {
    func presentAlertOnMainThread(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            self.present(alert, animated: true)
        }
    }
    
    func showActivityLoadingView(){
        aView = UIView(frame: self.view.bounds)
        aView!.backgroundColor = .clear
        
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.color = .black
        activityView.center = aView!.center
        activityView.startAnimating()
        aView!.addSubview(activityView)
        self.view.addSubview(aView!)
    }
    
    func removeActivityLoadingView(){
        if aView != nil {
            aView!.removeFromSuperview()
            aView = nil
        }
    }
}

