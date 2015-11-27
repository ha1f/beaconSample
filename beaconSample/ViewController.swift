//
//  ViewController.swift
//  iBeaconDemo
//
//  Created by Fumitoshi Ogata on 2014/07/03.
//  Copyright (c) 2014年 Fumitoshi Ogata. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    let macBeaconRegion = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA")!, identifier:"ha1fMacBeacon")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    // 認証状況の取得
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways {
            startMonitoring(macBeaconRegion)
        }
    }

    // beaconの計測ごとに呼ばれる
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        print("beacons=\(beacons)")
        if !beacons.isEmpty {
            let beacon = beacons[0] 
            updateDistance(beacon.proximity)
        } else {
            updateDistance(.Unknown)
            //manager.stopRangingBeaconsInRegion(region)
        }
    }
    
    func startMonitoring(beaconRegion: CLBeaconRegion) {
        if CLLocationManager.isMonitoringAvailableForClass(CLBeaconRegion.self) {
            locationManager.startMonitoringForRegion(beaconRegion)
        }
    }
    
    func startRanging(beaconRegion: CLBeaconRegion) {
        if CLLocationManager.isRangingAvailable() {
            locationManager.startRangingBeaconsInRegion(beaconRegion)
        }
    }
    
    func updateDistance(distance: CLProximity) {
        switch distance {
        case .Unknown:
            print("distance:unknown")
            self.view.backgroundColor = UIColor.grayColor()
            
        case .Far:
            print("distance:far")
            self.view.backgroundColor = UIColor.blueColor()
            
        case .Near:
            print("distance:near")
            self.view.backgroundColor = UIColor.orangeColor()
            
        case .Immediate:
            print("distance:immediate")
            self.view.backgroundColor = UIColor.redColor()
        }
    }
    
    // モニタリング開始直後
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        // 現在自分がどのような状況にいるのか、知らせる(didDetermineStateを呼ぶ)よう要求
        manager.requestStateForRegion(region)
        print("start scanning")
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        // 距離測定を開始
        if region.isMemberOfClass(CLBeaconRegion.self) {
            startRanging(region as! CLBeaconRegion)
        }
    }
    
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion inRegion: CLRegion) {
        switch(state) {
        case .Inside:
            print("inside")
            // 距離測定を開始
            if inRegion.isMemberOfClass(CLBeaconRegion.self) {
                startRanging(inRegion as! CLBeaconRegion)
            }
        case .Outside:
            print("outside")
        case .Unknown:
            print("unknown")
        }
    }
}