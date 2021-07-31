//
//  ContentView.swift
//  Step Counter
//
//  Created by Ahmed Elsayed on 7/30/21.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    
    private var healthStore : HealthStore?
    
    @State private var steps: [Step] = [Step]()
    
    init() {
        healthStore = HealthStore()
    }
    private func updateUIFromStatics(staticsCollection: HKStatisticsCollection){
        
        let startDate = Calendar.current.date(byAdding: .hour ,value:-24 , to: Date())!
        
        
        let endDate = Date()
        
        
        staticsCollection.enumerateStatistics(from: startDate, to: endDate){(statics , stop) in
           
            let count = statics.sumQuantity()?.doubleValue(for: .count())
            
            let step = Step(count: Int(count ?? 0), startDate: statics.startDate , endDate: statics.endDate)
            steps.append(step)
            
            
        }
        steps.reverse()
    }
    
    var body: some View {
        
        
        
        List(steps, id: \.id){step in
            
            VStack(alignment: .leading){
                Text(step.startDate, style: .date).opacity(1)
                Text("\(step.count) \(" steps")" )
                
                HStack{
                    
                    Text(step.startDate, style: .time).opacity(0.5)
                    Text(" - ")
                    Text(step.endDate, style: .time).opacity(0.5)
                }
               
                
            }
            
           
        }
            .onAppear{
                if let healthStore = healthStore{
                    healthStore.requestAuthorization{ success in
                        if success{
                            healthStore.calculateSteps{
                                staticsCollection in
                                
                                if let staticsCollection  = staticsCollection{
                                    //update the UI
                                    updateUIFromStatics(staticsCollection: staticsCollection)
                                }
                            }
                        }
                    }
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
