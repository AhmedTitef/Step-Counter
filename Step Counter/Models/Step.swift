//
//  Step.swift
//  Step Counter
//
//  Created by Ahmed Elsayed on 7/30/21.
//

import Foundation

struct Step: Identifiable {
    let id = UUID()
    
    let count : Int
    let startDate : Date
    let endDate : Date
}
