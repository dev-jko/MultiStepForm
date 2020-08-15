//
//  Form2ViewModel.swift
//  MultiStepForm
//
//  Created by Jaedoo Ko on 2020/08/13.
//  Copyright © 2020 jko. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum Form2Coordinating {
    case next(SurveyAnswer)
    case back(SurveyAnswer)
}

protocol Form2ViewModelInputs {
    func survey(_ survey: SurveyAnswer)
    func nextButtonClicked()
    func backButtonClicked()
    func radioButtonClicked(index: Int)
}

protocol Form2ViewModelOutputs {
    func coordinate() -> Signal<Form2Coordinating>
    func selectedRadioButton() -> Driver<Int>
}

protocol Form2ViewModelType {
    var inputs: Form2ViewModelInputs { get }
    var outputs: Form2ViewModelOutputs { get }
}

final class Form2ViewModel: Form2ViewModelType,
Form2ViewModelInputs, Form2ViewModelOutputs {
    
    // MARK: - Properties
    
    var inputs: Form2ViewModelInputs { return self }
    var outputs: Form2ViewModelOutputs { return self }
    private var disposeBag = DisposeBag()
    
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
    
    private let radioButtonClickedProperty: PublishRelay<Int> = PublishRelay()
    func radioButtonClicked(index: Int) {
        radioButtonClickedProperty.accept(index)
    }
    
    
    // MARK: - Outputs
    
    private let coordinateProperty: PublishRelay<Form2Coordinating> = PublishRelay()
    func coordinate() -> Signal<Form2Coordinating> {
        return coordinateProperty.asSignal()
    }
    
    private let selectedRadioButtonProperty: BehaviorRelay<Int> = BehaviorRelay(value: -1)
    func selectedRadioButton() -> Driver<Int> {
        return selectedRadioButtonProperty.asDriver()
    }
    
    // MARK: - Lifecycle
    
    init() {
        
        let initialRadio = surveyProperty
            .filter { $0.radio != .none }
            .map { $0.radio.rawValue - 1 }
        
        let radio = Observable.merge(
            initialRadio,
            radioButtonClickedProperty.asObservable()
        )
        
        radio
            .bind(to: selectedRadioButtonProperty)
            .disposed(by: disposeBag)
        
        let modifiedSurvey = Observable.combineLatest(surveyProperty, radio)
            .map({ (survey, index) -> SurveyAnswer in
                guard let radio = SurveyAnswer.Radio.init(rawValue: index + 1) else {
                    return survey
                }
                var newSurvey = survey
                newSurvey.radio = radio
                return newSurvey
            })
        
        nextButtonClickedProperty
            .withLatestFrom(modifiedSurvey)
            .map { Form2Coordinating.next($0) }
            .bind(to: coordinateProperty)
            .disposed(by: disposeBag)
        
        backButtonClickedProperty
            .withLatestFrom(modifiedSurvey)
            .map { Form2Coordinating.back($0) }
            .bind(to: coordinateProperty)
            .disposed(by: disposeBag)
        
    }
    
    deinit {
        print("form 2 view model deinited")
    }
    
    // MARK: - Functions
}
