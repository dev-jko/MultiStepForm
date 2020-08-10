//
//  Network.swift
//  MultiStepForm
//
//  Created by Jaedoo Ko on 2020/08/07.
//  Copyright © 2020 jko. All rights reserved.
//

import Foundation

protocol NetworkType {
    typealias SurveySubmitResult = Result<String, Error>
    
    func submitSurvey(survey: SurveyAnswer, completion: @escaping (SurveySubmitResult) -> Void)
}

struct Network: NetworkType {
    func submitSurvey(
        survey: SurveyAnswer,
        completion: @escaping (SurveySubmitResult) -> Void
    ) {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 2) {
            print(survey.text)
            print(survey.radio)
            print(survey.checkbox)
            DispatchQueue.main.async {
                completion(.success("설문에 참여해주셔서 감사합니다"))
            }
        }
    }
}
