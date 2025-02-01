//
//  UIViewController+Ext.swift
//  Restaurant Viewer Project
//
//  Created by Chris W on 1/31/25.
//

import UIKit

extension UIViewController {
    func presentAlertOnMainThread(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            self.present(alert, animated: true)
        }
    }
}

