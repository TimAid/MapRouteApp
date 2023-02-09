//
//  Alert.swift
//  MapRouteApp
//
//  Created by Timur Mannapov on 2023/2/9.
//

import Foundation
import UIKit

//MARK: - Alert
extension UIViewController {
    
    func showAlert(title: String, placeholder: String, completion: @escaping (String) -> Void ) {
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            guard let textfield = alertController.textFields?.first else { return }
            guard let text = textfield.text else { return }
            completion(text)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addTextField { textfield in
            textfield.placeholder = placeholder
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        present(alertController, animated: true)
    }
    
    func errorAlert(title: String, message: String) {
        let alertContoller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        
        alertContoller.addAction(okAction)
        
        present(alertContoller, animated: true)
    }
}
