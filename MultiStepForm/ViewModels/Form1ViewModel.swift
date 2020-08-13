//
//  Form1ViewModel.swift
//  MultiStepForm
//
//  Created by Jaedoo Ko on 2020/08/13.
//  Copyright © 2020 jko. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum Form1InputData {
    case next
    case back
}

enum Form1ViewControllerData {
    case next(SurveyAnswer)
    case back
}

protocol Form1ViewModelInputs {
    func survey(_ survey: SurveyAnswer)
    func navigationButtonClicked(_ type: Form1InputData)
    func textAnswer(_ text: String)
}

protocol Form1ViewModelOutputs {
    func coordinating() -> Signal<Form1ViewControllerData>
    func surveyAnswerText() -> Driver<String>
}

protocol Form1ViewModelType {
    var inputs: Form1ViewModelInputs { get }
    var outputs: Form1ViewModelOutputs { get }
}

final class Form1ViewModel: Form1ViewModelType,
Form1ViewModelInputs, Form1ViewModelOutputs {
    
    // MARK: - Properties
    
    var inputs: Form1ViewModelInputs { return self }
    var outputs: Form1ViewModelOutputs { return self }
    private var disposeBag = DisposeBag()
    
    // MARK: - Inputs
    
    private let surveyProperty: PublishRelay<SurveyAnswer> = PublishRelay()
    func survey(_ survey: SurveyAnswer) {
        surveyProperty.accept(survey)
    }
    
    private let navigationButtonClickedProperty: PublishRelay<Form1InputData> = PublishRelay()
    func navigationButtonClicked(_ type: Form1InputData) {
        navigationButtonClickedProperty.accept(type)
    }
    
    private let textAnswerProperty: PublishRelay<String> = PublishRelay()
    func textAnswer(_ text: String) {
        textAnswerProperty.accept(text)
    }
    
    // MARK: - Outputs

    private let coordinatingProperty: PublishRelay<Form1ViewControllerData> = PublishRelay()
    func coordinating() -> Signal<Form1ViewControllerData> {
        return coordinatingProperty.asSignal()
    }
    
    private let surveyAnswerTextProperty: BehaviorRelay<String> = BehaviorRelay(value: "")
    func surveyAnswerText() -> Driver<String> {
        return surveyAnswerTextProperty.asDriver()
    }
    
    // MARK: - Lifecycle
    
    init() {
        print("form 1 view model init")
        
        surveyProperty
            .map { $0.text }
            .bind(to: surveyAnswerTextProperty)
            .disposed(by: disposeBag)
        
        let modifiedSurvey = Observable.combineLatest(surveyProperty, textAnswerProperty)
            .map({ (survey, text) -> SurveyAnswer in
                var newSurvey = survey
                newSurvey.text = text
                return newSurvey
            })
        
        navigationButtonClickedProperty
            .filter { $0 == Form1InputData.next }
            .withLatestFrom(modifiedSurvey)
            .map { Form1ViewControllerData.next($0) }
            .bind(to: coordinatingProperty)
            .disposed(by: disposeBag)
        
        navigationButtonClickedProperty
            .filter { $0 == Form1InputData.back }
            .map { _ in Form1ViewControllerData.back }
            .bind(to: coordinatingProperty)
            .disposed(by: disposeBag)
    }
    
    deinit {
        print("form 1 view model deinited")
    }
    
    // MARK: - Functions
}

