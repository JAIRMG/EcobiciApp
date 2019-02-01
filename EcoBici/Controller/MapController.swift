//
//  MapController.swift
//  Ecobici
//
//  Created by Pablo Ramirez on 1/30/19.
//  Copyright © 2019 Pablo Ramirez. All rights reserved.
//

import UIKit
import GoogleMaps

class MapController: UIViewController, GMSMapViewDelegate {
    
    let mapCView: MapView = MapView()
    
    var map: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mapCView.showLoader()
        serviceManager.stationsService(referenceController: self)
    }
    
    func initView(){
        
        self.view = mapCView.initView(reference: self, view: self.view)
        self.map = mapCView.map
        self.map.delegate = self
    }
    
    func showStationsInMap(stations: [[String:AnyObject]]){
        mapCView.hideLoader()
        
        print("show markers")
        mapCView.showMarkersStations(stations: stations)
    }
    
    func errorsEvents(){
        mapCView.hideLoader()
        ////////////////////// Mostrar una ventana de error
        
        mapCView.showAlertError(reference: self, titleText: "Error", textMessage: "Error al cargar las estaciones cercanas")
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: marker.position.latitude, longitude: marker.position.longitude, zoom: 18.0)
        map.animate(to: camera)
        mapView.delegate = self
        
        if let userData = marker.userData as? [String:AnyObject] {
            print("name = \(userData["name"])")
            if mapCView.isDetailViewActive{
                mapCView.hideDetailsMarker(showAgain: true, userData: userData)
            }
            else{
                mapCView.showDetailsMarker(userData: userData)
            }
        }
        
        return true
    }
    
    public func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        print("tap en mylocationbutton")
        
        return true
    }
    
    public func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
        print("tap en el mapa")
        if mapCView.isDetailViewActive{
            mapCView.hideDetailsMarker(showAgain: false)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
