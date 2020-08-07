//
//  SurveyAnswer.swift
//  MultiStepForm
//
//  Created by Jaedoo Ko on 2020/08/07.
//  Copyright © 2020 jko. All rights reserved.
//

import Foundation

class SurveyAnswer {
    var text: String = ""
    var radio: Radio = .none
    var checkbox: [Bool] = [Bool](repeating: false, count: 4)
}

extension SurveyAnswer {
    enum Radio: Int {
        case none
        case one
        case two
    }
}
