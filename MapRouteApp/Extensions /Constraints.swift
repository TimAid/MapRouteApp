//
//  Constraints.swift
//  MapRouteApp
//
//  Created by Timur Mannapov on 2023/2/9.
//

import Foundation
import UIKit

extension ViewController {
    
    //MARK: setConstraints
    func setConstraints() {
        
        let mapViewContstraints = [
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        let addButtonConstraints = [
            addButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: 40),
            addButton.widthAnchor.constraint(equalToConstant: 80)
        ]
        
        let resetButtonConstraints = [
            resetButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -20),
            resetButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 20),
            resetButton.widthAnchor.constraint(equalToConstant: 80),
            resetButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        let routeButtonConstraints = [
            routeButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -20),
            routeButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20),
            routeButton.widthAnchor.constraint(equalToConstant: 80),
            routeButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        NSLayoutConstraint.activate(mapViewContstraints)
        NSLayoutConstraint.activate(addButtonConstraints)
        NSLayoutConstraint.activate(resetButtonConstraints)
        NSLayoutConstraint.activate(routeButtonConstraints)
    }
}
