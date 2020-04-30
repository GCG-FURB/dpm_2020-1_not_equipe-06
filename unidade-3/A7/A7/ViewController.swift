//
//  ViewController.swift
//  A7
//
//  Created by Daniel dos Santos on 22/04/20.
//  Copyright © 2020 Daniel dos Santos. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate {
    
    var manager:CBCentralManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        manager = CBCentralManager(delegate: self, queue: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Peripheral: \(peripheral)")
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        var consoleMsg = ""
        
        switch central.state {
            
        case .poweredOff:
            consoleMsg = "Bluetooth is powered off"
        case .poweredOn:
            consoleMsg = "Bluetooth is powered on"
            manager.scanForPeripherals(withServices: nil, options: nil)
        case .resetting:
            consoleMsg = "Bluetooth is resetting"
        case .unauthorized:
            consoleMsg = "Bluetooth is unauthorized"
        case .unknown:
            consoleMsg = "Bluetooth is unknown"
        case .unsupported:
            consoleMsg = "Bluetooth is unsupported"
        }
        
        print(consoleMsg)
    }
    
}

