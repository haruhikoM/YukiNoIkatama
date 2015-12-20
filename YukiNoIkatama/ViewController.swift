//
//  ViewController.swift
//  YukiNoIkatama
//
//  Created by Minamiguchi Haruhiko on 12/19/15.
//  Copyright © 2015 Minamiguchi Haruhiko. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func tookIkatama(sender: AnyObject) {
    //// Energy
    let kcalUnit = HKUnit(fromString: "kcal")
    let energyQuantity = HKQuantity(unit: kcalUnit, doubleValue: 347)
    let energyType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryEnergyConsumed)!
    let date = NSDate()
    let ikatamaEnergySample = HKQuantitySample(type: energyType, quantity: energyQuantity, startDate: date, endDate: date)
    
    //// Protein
    let gramUnit = HKUnit.gramUnit()
    let proteinQuantity = HKQuantity(unit: gramUnit, doubleValue: 18.9)
    let proteinType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryProtein)!
    let ikatamaProteinSample = HKQuantitySample(type: proteinType, quantity: proteinQuantity, startDate: date, endDate: date)
    
    
    
    var itemSet = Set<HKQuantitySample>()
    itemSet.insert(ikatamaEnergySample)
    itemSet.insert(ikatamaProteinSample)
    
    let foodType = HKCorrelationType.correlationTypeForIdentifier(HKCorrelationTypeIdentifierFood)!
    let ikatama = HKCorrelation(type: foodType, startDate: date, endDate: date, objects: itemSet)
    
    guard HKHealthStore.isHealthDataAvailable() else { return }
    let healthStore = HKHealthStore()
    
    let typeSet: Set<HKSampleType> = [energyType, proteinType]
    healthStore.requestAuthorizationToShareTypes(typeSet, readTypes: nil) { success, error -> Void in
      // if request is approved
      healthStore.saveObject(ikatama) { success, error in
        if success { print("DONE!!") }
      }
    }
  }
  
}

