//
//  ContentView.swift
//  Step Counter
//
//  Created by Ahmed Elsayed on 7/30/21.
//

import SwiftUI
import HealthKit
import SwiftUICharts


struct ContentView: View {
    
    private var healthStore : HealthStore?
    

     @State private var dataSetForBarChart : [(String, Int)] = [(String, Int)]()
    @State private var dataSetForLineChart : [( Double)] = [( Double)]()
    
    @State private var steps: [Step] = [Step]()
    
    init() {
        healthStore = HealthStore()
    }
    private func updateUIFromStatics(staticsCollection: HKStatisticsCollection){
        
        let startDate = Calendar.current.date(byAdding: .hour ,value:-24 , to: Date())!
        
        
        let endDate = Date()
        
        
        staticsCollection.enumerateStatistics(from: startDate, to: endDate){(statistics , stop) in
           
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            
            let step = Step(count: Int(count ?? 0), startDate: statistics.startDate , endDate: statistics.endDate)
            steps.append(step)
            let timeFromatter = DateFormatter()
            timeFromatter.dateFormat = "HH:mm"
            
            
            
            let startTime = timeFromatter.string(from: step.startDate)
            let endTime = timeFromatter.string(from: step.endDate)
            dataSetForBarChart.append(("\(startTime) \("-") \(endTime) ", step.count ))
            
            dataSetForLineChart.append((Double)(step.count) )
            
        }
        steps.reverse()
        
        
        
        print(dataSetForLineChart)
       
        
        
       
    }
    
     
    
    var body: some View {
        
        
        
        VStack(){
            LineChartView(data: dataSetForLineChart, title: "Steps Count", form: ChartForm.extraLarge).padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
            BarChartView(data: ChartData(values: dataSetForBarChart), title: "Last 24 Hours Steps Count", form: ChartForm.extraLarge)
            
        }
        

        
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
