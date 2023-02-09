//
//  ViewController.swift
//  MapRouteApp
//
//  Created by Timur Mannapov on 2023/2/8.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    //MARK: - Properties
    
    var annotationsArray = [MKPointAnnotation]()
    

    let mapView: MKMapView = {
        let view = MKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let addButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 5
        button.layer.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1).cgColor
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let resetButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 5
        button.layer.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1).cgColor
        button.isHidden = true
        button.setTitle("Reset", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let routeButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 5
        button.layer.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1).cgColor
        button.isHidden = true
        button.setTitle("Route", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        setSubviews()
        setConstraints()
        
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetButtonPressed), for: .touchUpInside)
        routeButton.addTarget(self, action: #selector(routeButtonPressed), for: .touchUpInside)
    }

    //MARK: - SetSubviews
    
    private func setSubviews() {
        view.addSubview(mapView)
        mapView.addSubview(addButton)
        mapView.addSubview(resetButton)
        mapView.addSubview(routeButton)
    }
    
    //MARK: - PressButton Methods
    
    @objc func addButtonPressed() {
        showAlert(title: "Добавить точку", placeholder: "Введите адрес") { [weak self] text in
            self?.setupPlacemark(addressPlace: text)
        }
    }
    
    @objc func resetButtonPressed() {
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        annotationsArray = [MKPointAnnotation]()
        resetButton.isHidden = true
        routeButton.isHidden = true
    }
    
     @objc func routeButtonPressed() {
        
         for index in 0..<annotationsArray.count - 1 {
            createDirectionRequest(startLocation: annotationsArray[index].coordinate, destinationCoordinate: annotationsArray[index + 1].coordinate)
        }
        mapView.showAnnotations(annotationsArray, animated: true)
    }
    
    //MARK: - SetupAnnotation
    
    /// Добавляем аннотацию на карту и добавляем эту аннотацию в массив аннотаций
    private func setupPlacemark(addressPlace: String) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressPlace) { [weak self] placemarks, error in
            
            if let error = error {
                print(error.localizedDescription)
                self?.errorAlert(title: "Ошибка", message: "Сервер недоступен. Попробуйте довабить адрес еще раз")
                return
            }
            
            guard let strongSelf = self else { return }
            
            /// find placemark
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = "\(addressPlace)"
            guard let placemarkLocation = placemark?.location else { return }
            annotation.coordinate = placemarkLocation.coordinate

            strongSelf.annotationsArray.append(annotation)
            
            ///check if have 3 pins on map -> route
            if strongSelf.annotationsArray.count > 2 {
                strongSelf.resetButton.isHidden = false
                strongSelf.routeButton.isHidden = false
            }
            
            strongSelf.mapView.showAnnotations(strongSelf.annotationsArray, animated: true)
        }
    }
    
    //MARK: CreateAtoBRoute
    
    /// Метод который строит маршрут между двух точек
    private func createDirectionRequest(startLocation: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        
        let startLocation = MKPlacemark(coordinate: startLocation)
        let destinationLocation = MKPlacemark(coordinate: destinationCoordinate)
        
        ///request
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startLocation)
        request.destination = MKMapItem(placemark: destinationLocation)
        request.transportType = .walking
        request.requestsAlternateRoutes = true
        
        ///direction
        let direction = MKDirections(request: request)
        direction.calculate { [weak self] response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let response = response else {
                self?.errorAlert(title: "Ошибка", message: "Маршрут недоступен")
                return
            }
            
            var minRoute = response.routes.first
            minRoute = response.routes.sorted { $0.distance < $1.distance}.first
            print(minRoute?.distance)

            self?.mapView.addOverlay(minRoute!.polyline)
        }
    }
}

//MARK: - MKMapViewDelegate
extension ViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .darkGray
        return renderer
    }
}
