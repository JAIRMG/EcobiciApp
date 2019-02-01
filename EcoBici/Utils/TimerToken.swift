//
//  Timer.swift
//  Ecobici
//
//  Created by Pablo Ramirez on 1/31/19.
//  Copyright © 2019 Pablo Ramirez. All rights reserved.
//

import Foundation

public class TimerToken: NSObject {
    
    func startTimer(){
        countSecondsTimer = 0
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil,repeats: true)
    }
    
    @objc func updateTime() {
        countSecondsTimer += 1
        if countSecondsTimer >= 3600{
            endTimer()
            
            //////// Accion para informar al usuario que su sesión ha expirado
        }
    }
    
    func endTimer() {
        countdownTimer.invalidate()
    }
    
}
