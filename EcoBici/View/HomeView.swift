//
//  HomeView.swift
//  Ecobici
//
//  Created by Pablo Ramirez on 1/31/19.
//  Copyright © 2019 Pablo Ramirez. All rights reserved.
//

import Foundation
import UIKit

protocol HomeDelegate{
    func onButtonPressed(sender: UIButton)
}

public class HomeView: UIView{
    
    var homeDelegate: HomeDelegate!
    
    var referenceController: HomeController!
    var view: UIView!
    
    let subview: UIView = UIView()
    let indicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func initView(reference: HomeController, view: UIView) -> UIView{
        self.referenceController = reference
        view.backgroundColor = UIColor(rgba: barColor)
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let startButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.3, height: view.frame.height * 0.075))
        startButton.center = CGPoint(x: view.frame.width * 0.5, y: view.frame.height * 0.75)
        startButton.setTitle("Iniciar", for: .normal)
        startButton.setTitleColor(UIColor.black, for: .normal)
        startButton.addTarget(self, action: #selector(onButtonPressed(sender:)), for: .touchUpInside)
        view.addSubview(startButton)
        
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
    
    func showLoader(){
        subview.isHidden = false
        indicatorView.isHidden = false
        indicatorView.startAnimating()
    }
    
    func hideLoader(){
        subview.isHidden = true
        indicatorView.isHidden = true
    }
    
    func showAlertError(reference: HomeController, titleText: String, textMessage: String){
        let alertController = UIAlertController(title: titleText, message: textMessage, preferredStyle: .alert)
        let acceptAction = UIAlertAction(title: "Aceptar", style: .default) { (action: UIAlertAction) in
            print("Accept Action");
            
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(acceptAction)
        reference.present(alertController, animated: true, completion: nil)
    }
    
    @objc func onButtonPressed(sender: UIButton){
        homeDelegate.onButtonPressed(sender: sender)
    }
}
