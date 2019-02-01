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

public class MapView: UIView{
    
    var map: GMSMapView!
    var referenceMapController: MapController!
    
    let subview: UIView = UIView()
    let indicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var view: UIView!
    
    let detailsView: UIView = UIView()
    var isDetailViewActive = false
    
    func initView(reference: MapController, view: UIView) -> UIView{
        self.view = view
        
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
        //map.delegate = self
        map.settings.myLocationButton = true
        
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
    
    func showDetailsMarker(userData: [String:AnyObject]){
        detailsView.frame = CGRect(x: view.frame.width * 0.05, y: view.frame.height, width: view.frame.width * 0.9, height: view.frame.height * 0.25)
        detailsView.backgroundColor = UIColor.white
        view.addSubview(detailsView)
        
        let nameLabel: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: detailsView.frame.width * 0.25, height: detailsView.frame.height / 3))
        nameLabel.setTitle("Nombre:", for: .normal)
        nameLabel.setTitleColor(UIColor.black, for: .normal)
        nameLabel.titleLabel?.font = UIFont.systemFont(ofSize: regularFontSize)
        nameLabel.titleLabel?.textAlignment = .left
        nameLabel.contentHorizontalAlignment = .left
        nameLabel.contentVerticalAlignment = .fill
        nameLabel.titleEdgeInsets = UIEdgeInsets(top: 0, left: nameLabel.frame.width * 0.05, bottom: 0, right: 0)
        detailsView.addSubview(nameLabel)
        
        let nameText: UIButton = UIButton(frame: CGRect(x: nameLabel.frame.width, y: 0, width: detailsView.frame.width * 0.75, height: nameLabel.frame.height))
        nameText.setTitle(userData["name"] as! String, for: .normal)
        nameText.setTitleColor(UIColor.black, for: .normal)
        nameText.titleLabel?.font = UIFont.systemFont(ofSize: regularFontSize)
        nameText.titleLabel?.textAlignment = .center
        nameText.titleLabel?.numberOfLines = 2
        nameText.contentHorizontalAlignment = .center
        nameText.contentVerticalAlignment = .fill
        nameText.titleEdgeInsets = UIEdgeInsets(top: 0, left: nameText.frame.width * 0.05, bottom: 0, right: nameText.frame.width * 0.05)
        detailsView.addSubview(nameText)
        
        let addressLabel: UIButton = UIButton(frame: CGRect(x: 0, y: nameLabel.frame.height, width: nameLabel.frame.width, height: nameLabel.frame.height))
        addressLabel.setTitle("Dirección:", for: .normal)
        addressLabel.setTitleColor(UIColor.black, for: .normal)
        addressLabel.titleLabel?.font = UIFont.systemFont(ofSize: regularFontSize)
        addressLabel.titleLabel?.textAlignment = .left
        addressLabel.contentHorizontalAlignment = .left
        addressLabel.contentVerticalAlignment = .fill
        addressLabel.titleEdgeInsets = UIEdgeInsets(top: 0, left: addressLabel.frame.width * 0.05, bottom: 0, right: 0)
        detailsView.addSubview(addressLabel)
        
        let addressText: UIButton = UIButton(frame: CGRect(x: addressLabel.frame.width, y: nameLabel.frame.origin.y + nameLabel.frame.height, width: nameText.frame.width, height: nameText.frame.height))
        addressText.setTitle(userData["address"] as! String, for: .normal)
        addressText.setTitleColor(UIColor.black, for: .normal)
        addressText.titleLabel?.font = UIFont.systemFont(ofSize: regularFontSize)
        addressText.titleLabel?.textAlignment = .center
        addressText.titleLabel?.numberOfLines = 2
        addressText.contentHorizontalAlignment = .center
        addressText.contentVerticalAlignment = .fill
        addressText.titleEdgeInsets = UIEdgeInsets(top: 0, left: addressText.frame.width * 0.05, bottom: 0, right: addressText.frame.width * 0.05)
        detailsView.addSubview(addressText)
        
        let stationTypeLabel: UIButton = UIButton(frame: CGRect(x: 0, y: addressLabel.frame.origin.y + addressLabel.frame.height, width: nameLabel.frame.width, height: nameLabel.frame.height))
        stationTypeLabel.setTitle("Tipo de estación:", for: .normal)
        stationTypeLabel.setTitleColor(UIColor.black, for: .normal)
        stationTypeLabel.titleLabel?.font = UIFont.systemFont(ofSize: regularFontSize)
        stationTypeLabel.titleLabel?.textAlignment = .left
        stationTypeLabel.contentHorizontalAlignment = .left
        stationTypeLabel.contentVerticalAlignment = .fill
        stationTypeLabel.titleEdgeInsets = UIEdgeInsets(top: 0, left: stationTypeLabel.frame.width * 0.05, bottom: 0, right: 0)
        detailsView.addSubview(stationTypeLabel)
        
        let stationTypeText: UIButton = UIButton(frame: CGRect(x: stationTypeLabel.frame.width, y: stationTypeLabel.frame.origin.y, width: nameText.frame.width, height: nameText.frame.height))
        stationTypeText.setTitle(userData["address"] as! String, for: .normal)
        stationTypeText.setTitleColor(UIColor.black, for: .normal)
        stationTypeText.titleLabel?.font = UIFont.systemFont(ofSize: regularFontSize)
        stationTypeText.titleLabel?.textAlignment = .center
        stationTypeText.titleLabel?.numberOfLines = 2
        stationTypeText.contentHorizontalAlignment = .center
        stationTypeText.contentVerticalAlignment = .fill
        stationTypeText.titleEdgeInsets = UIEdgeInsets(top: 0, left: stationTypeText.frame.width * 0.05, bottom: 0, right: stationTypeText.frame.width * 0.05)
        detailsView.addSubview(stationTypeText)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.detailsView.frame.origin.y = self.view.frame.height - self.detailsView.frame.height
        }) { (_) in
            self.isDetailViewActive = true
        }
        
       
        
    }
    
    func hideDetailsMarker(showAgain: Bool, userData: [String:AnyObject]!=nil){
        
        
        UIView.animate(withDuration: 0.5, animations: {
            self.detailsView.frame.origin.y = self.view.frame.height
        }) { (_) in
            for subview in self.detailsView.subviews{
                subview.removeFromSuperview()
            }
            
            self.isDetailViewActive = false
            
            if showAgain{
                self.showDetailsMarker(userData: userData)
            }
        }
        
    
    }
    
    func showMarkersStations(stations: [[String:AnyObject]]){
        for station in stations{
            if let location = station["location"] as? [String:AnyObject]{
                let latitude: Double = location["lat"] as! Double
                let longitude: Double = location["lon"] as! Double
                let name: String = station["name"] as! String
                let address: String = station["address"] as! String
                let stationType: String = station["stationType"] as! String
                
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                marker.map = map
                marker.userData = [
                    "name": name,
                    "address": address,
                    "stationType": stationType
                ]
            }
        }
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
    
    func showAlertError(reference: MapController, titleText: String, textMessage: String){
        let alertController = UIAlertController(title: titleText, message: textMessage, preferredStyle: .alert)
        let acceptAction = UIAlertAction(title: "Aceptar", style: .default) { (action: UIAlertAction) in
            print("Accept Action");
            
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(acceptAction)
        reference.present(alertController, animated: true, completion: nil)
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
    
}
