//
//  MapView.swift
//  Ecobici
//
//  Created by Pablo Ramirez on 1/30/19.
//  Copyright © 2019 Pablo Ramirez. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

public class MapView: UIView, GMSMapViewDelegate{
    
    var map: GMSMapView!
    var referenceMapController: MapController!
    
    let subview: UIView = UIView()
    let indicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var view: UIView!
    
    func initView(reference: MapController, view: UIView) -> UIView{
        self.referenceMapController = reference
        view.backgroundColor = UIColor(rgba: barColor)
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let titleView: UIView = UIView(frame: CGRect(x: 0, y: statusBarHeight, width: view.frame.width, height: view.frame.height * 0.075))
        titleView.backgroundColor = UIColor(rgba: barColor)
        view.addSubview(titleView)
        
        let titleLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: titleView.frame.width, height: titleView.frame.height))
        titleLabel.text = "Mapa Ecobici"
        titleLabel.font = titleLabel.font.withSize(regularFontSize)
        titleLabel.textAlignment = .center
        titleView.addSubview(titleLabel)
        
        //////////////////// Map View
        
        let myLocation = getCurrentLocation()
        var camera = GMSCameraPosition()
        
        if(!checkPermissions()){
            
            camera = GMSCameraPosition.camera(withLatitude: 19.3039965, longitude: -99.2108294, zoom: 11.12)
            checkPermissionsAlert()
            
        } else {
            camera = GMSCameraPosition.camera(withLatitude: myLocation.coordinate.latitude, longitude: myLocation.coordinate.longitude, zoom: 14.0)
        }
        
        map = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        map.frame = CGRect(x: 0, y: titleView.frame.height + titleView.frame.origin.y, width: view.frame.width, height: view.frame.height - titleView.frame.height - titleView.frame.origin.y)
        map.isMyLocationEnabled = true
        map.delegate = self
        map.settings.myLocationButton = true
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 19.4141, longitude: -99.1799)
        marker.map = map
        
        view.addSubview(map)
        
        //////////////////// Loader Interface
        
        subview.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        subview.backgroundColor = UIColor.black
        subview.alpha = 0.5
        subview.tag = 101
        subview.isHidden = true
        view.addSubview(subview)
        
        indicatorView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        indicatorView.center = CGPoint(x: view.frame.width * 0.5, y: view.frame.height * 0.5)
        indicatorView.style = .gray
        indicatorView.tag = 102
        indicatorView.isHidden = true
        view.addSubview(indicatorView)
        
        return view
    }
    
    func checkPermissionsAlert(){
        let alertController = UIAlertController(title: NSLocalizedString("Aviso", comment: ""), message: NSLocalizedString("Activa tu GPS para poder usar esta sección", comment: ""), preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: NSLocalizedString("Configuraciones", comment: ""), style: .default) { (UIAlertAction) in
            if let url = URL(string:UIApplication.openSettingsURLString) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:])
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        referenceMapController.present(alertController, animated: true, completion: nil)
    }
    
    func showLoader(){
        subview.isHidden = false
        indicatorView.isHidden = false
        indicatorView.startAnimating()
    }
    
    func hideLoader(){
        subview.isHidden = true
        indicatorView.isHidden = true
    }
    
}
