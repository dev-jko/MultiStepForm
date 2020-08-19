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

enum Form1Coordinating {
    case next(SurveyAnswer)
    case close
}

protocol Form1ViewModelInputs {
    func survey(_ survey: SurveyAnswer)
    func nextButtonClicked()
    func backButtonClicked()
    func textAnswer(_ text: String)
}

protocol Form1ViewModelOutputs {
    func coordinate() -> Signal<Form1Coordinating>
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
    private let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    
    private let surveyProperty: PublishRelay<SurveyAnswer> = PublishRelay()
    func survey(_ survey: SurveyAnswer) {
        surveyProperty.accept(survey)
    }
    
    private let nextButtonClickedProperty: PublishRelay<Void> = PublishRelay()
    func nextButtonClicked() {
        nextButtonClickedProperty.accept(Void())
    }
    
    private let backButtonClickedProperty: PublishRelay<Void> = PublishRelay()
    func backButtonClicked() {
        backButtonClickedProperty.accept(Void())
    }
    
    private let textAnswerProperty: PublishRelay<String> = PublishRelay()
    func textAnswer(_ text: String) {
        textAnswerProperty.accept(text)
    }
    
    // MARK: - Outputs

    private let coordinatingProperty: PublishRelay<Form1Coordinating> = PublishRelay()
    func coordinate() -> Signal<Form1Coordinating> {
        return coordinatingProperty.asSignal()
    }
    
    private let surveyAnswerTextProperty: BehaviorRelay<String> = BehaviorRelay(value: "")
    func surveyAnswerText() -> Driver<String> {
        return surveyAnswerTextProperty.asDriver()
    }
    
    // MARK: - Lifecycle
    
    init() {
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
        
        nextButtonClickedProperty
            .withLatestFrom(modifiedSurvey)
            .map { Form1Coordinating.next($0) }
            .bind(to: coordinatingProperty)
            .disposed(by: disposeBag)
        
        backButtonClickedProperty
            .map { _ in Form1Coordinating.close }
            .bind(to: coordinatingProperty)
            .disposed(by: disposeBag)
    }
    
    deinit {
        print("form 1 view model deinited")
    }
    
    // MARK: - Functions
}

