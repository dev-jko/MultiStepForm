//
//  Network.swift
//  MultiStepForm
//
//  Created by Jaedoo Ko on 2020/08/07.
//  Copyright © 2020 jko. All rights reserved.
//

import Foundation
import RxSwift

fileprivate protocol NetworkType {
    typealias SurveySubmitResult = Result<String, Error>
    
    func submitSurvey(survey: SurveyAnswer, completion: @escaping (SurveySubmitResult) -> Void)
}

fileprivate struct Network: NetworkType {
    func submitSurvey(
        survey: SurveyAnswer,
        completion: @escaping (SurveySubmitResult) -> Void
    ) {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 2) {
            
            let string = """
            --submission--
            text     : \(survey.text)
            radio    : \(survey.radio)
            checkbox : \(survey.checkbox.states)
            --------------
            """
            print(string)
            
            DispatchQueue.main.async {
                completion(.success("설문에 참여해주셔서 감사합니다"))
            }
        }
    }
}

protocol RxNetworkType {
    typealias SurveySubmitResult = Result<String, Error>
    
    func submitSurvey(survey: SurveyAnswer) -> Single<SurveySubmitResult>
}

struct RxNetwork: RxNetworkType {
    private let network: NetworkType = Network()
    
    func submitSurvey(survey: SurveyAnswer) -> Single<SurveySubmitResult> {
        return Single.create { single in
            self.network.submitSurvey(survey: survey, completion: { result in
                single(.success(result))
            })
            return Disposables.create()
        }
    }
}
