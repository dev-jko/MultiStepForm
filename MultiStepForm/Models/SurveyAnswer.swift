//
//  SurveyAnswer.swift
//  MultiStepForm
//
//  Created by Jaedoo Ko on 2020/08/07.
//  Copyright © 2020 jko. All rights reserved.
//

import Foundation

struct SurveyAnswer {
    var text: String = ""
    var radio: Radio = .none
    var checkbox: Checkbox = Checkbox(descriptions: ["B1", "B2", "B3", "B4"])
}

extension SurveyAnswer {
    enum Radio: Int {
        case none
        case one
        case two
    }
    
    struct Checkbox {
        let descriptions: [String]
        var states: [Bool]
        
        init(descriptions: [String]) {
            self.descriptions = descriptions
            states = Array(repeating: false, count: descriptions.count)
        }
    }
}

extension SurveyAnswer.Radio {
    var description: String {
        switch self {
        case .none: return ""
        case .one: return "A1"
        case .two: return "A2"
        }
    }
}
