//
//  HealthStore.swift
//  Step Counter
//
//  Created by Ahmed Elsayed on 7/30/21.
//

import Foundation
import HealthKit



class HealthStore{
    //provides access related to health
    var healthStore: HKHealthStore?
    var query : HKStatisticsCollectionQuery?
    //making sure it is initlized
    init() {
        if HKHealthStore.isHealthDataAvailable(){
            healthStore = HKHealthStore()
        }
    }
    
    //HKStatisticsCollection has all information about the data per day or mont or whatever
    
    func calculateSteps (completion: @escaping (HKStatisticsCollection?)-> Void){
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        
        // start date is exactly 24 hours ago
        let startDate = Calendar.current.date(byAdding: .hour ,value:-24 , to: Date())!
        
        // anchor date is exactly the start of 24 hours ago
        let anchorDate = Calendar.current.startOfDay(for: startDate)

        
        let interval = DateComponents(minute: 5)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        //cummalivesum means we want to calculate using iphone and watch steps
        query = HKStatisticsCollectionQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: interval)
        
        query!.initialResultsHandler = {query, statisticsCollection, error in
            completion(statisticsCollection)
            
        }
        
        //excuting happens here after satifying everything above
        
        if let healthStore = healthStore, let query = self.query{
            healthStore.execute(query)
        }
        
    }
    
    
    func requestAuthorization(completion: @escaping (Bool)-> Void)  {
        
        //track step count
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        // get access to health store
        //uwraping the healthstore to get access of the unwraped version of the healthstore
        guard let healthStore = self.healthStore else {return completion(false)}
        
        //toshare nothing to write data
        //read the steptype
        
        healthStore.requestAuthorization(toShare: [], read: [stepType]) { (success, error ) in completion(success)
        }
        
        
    }
    
}
