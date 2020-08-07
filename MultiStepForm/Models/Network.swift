//
//  Network.swift
//  MultiStepForm
//
//  Created by Jaedoo Ko on 2020/08/07.
//  Copyright © 2020 jko. All rights reserved.
//

import Foundation

struct Network {
    func submitSurvey(
        survey: SurveyAnswer,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
            print(survey.text)
            print(survey.radio)
            print(survey.checkbox)
            completion(.success("설문에 참여해주셔서 감사합니다"))
        }
    }
}
