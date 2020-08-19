//
//  Form3ViewModel.swift
//  MultiStepForm
//
//  Created by Jaedoo Ko on 2020/08/15.
//  Copyright © 2020 jko. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum Form3AlertType {
    case success(String)
    case error(String)
}

extension Form3AlertType {
    var title: String {
        switch self {
        case .success:
            return "제출 완료"
        case .error:
            return "에러 발생"
        }
    }
}

enum Form3Coordinating {
    case finish
    case back(SurveyAnswer)
}

protocol Form3ViewModelInputs {
    func survey(_ survey: SurveyAnswer)
    func submitButtonClicked()
    func backButtonClicked()
    func checkboxButtonClicked(index: Int)
    func submissionSuccess()
}

protocol Form3ViewModelOutputs {
    func isLoading() -> Driver<Bool>
    func coordinate() -> Signal<Form3Coordinating>
    func alert() -> Signal<Form3AlertType>
    func checkboxes() -> Driver<[String]>
    func checkboxStates() -> Driver<[Bool]>
}

protocol Form3ViewModelType {
    var inputs: Form3ViewModelInputs { get }
    var outputs: Form3ViewModelOutputs { get }
}

final class Form3ViewModel: Form3ViewModelType,
Form3ViewModelInputs, Form3ViewModelOutputs {
    
    // MARK: - Properties
    
    var inputs: Form3ViewModelInputs { return self }
    var outputs: Form3ViewModelOutputs { return self }
    private let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    
    private let surveyProperty = PublishRelay<SurveyAnswer>()
    func survey(_ survey: SurveyAnswer) {
        surveyProperty.accept(survey)
    }
    
    private let submitButtonClickedProperty = PublishRelay<Void>()
    func submitButtonClicked() {
        submitButtonClickedProperty.accept(Void())
    }
    
    private let backButtonClickedProperty = PublishRelay<Void>()
    func backButtonClicked() {
        backButtonClickedProperty.accept(Void())
    }
    
    private let checkboxButtonClickedProperty = PublishRelay<Int>()
    func checkboxButtonClicked(index: Int) {
        checkboxButtonClickedProperty.accept(index)
    }
    
    private let submissionSuccessProperty = PublishRelay<Void>()
    func submissionSuccess() {
        submissionSuccessProperty.accept(Void())
    }
    
    // MARK: - Outputs
    
    private let coordinateProperty = PublishRelay<Form3Coordinating>()
    func coordinate() -> Signal<Form3Coordinating> {
        return coordinateProperty.asSignal()
    }
    
    private let isLoadingProperty = BehaviorRelay<Bool>(value: false)
    func isLoading() -> Driver<Bool> {
        return isLoadingProperty.asDriver()
    }
    
    private let alertProperty = PublishRelay<Form3AlertType>()
    func alert() -> Signal<Form3AlertType> {
        return alertProperty.asSignal()
    }
    
    private let checkboxesProperty = BehaviorRelay<[String]>(value: [])
    func checkboxes() -> Driver<[String]> {
        return checkboxesProperty.asDriver()
    }
    
    private let checkboxStatesProperty = BehaviorRelay<[Bool]>(value: [])
    func checkboxStates() -> Driver<[Bool]> {
        return checkboxStatesProperty.asDriver()
    }
    
    // MARK: - Lifecycle
    
    init(network: RxNetworkType) {
        
        surveyProperty
            .map { $0.checkbox.descriptions }
            .bind(to: checkboxesProperty)
            .disposed(by: disposeBag)
        
        surveyProperty
            .map { $0.checkbox.states }
            .bind(to: checkboxStatesProperty)
            .disposed(by: disposeBag)
        
        checkboxButtonClickedProperty
            .withLatestFrom(checkboxStatesProperty) { index, states in (index, states) }
            .map({ index, states -> [Bool] in
                guard index < states.count else { return states }
                var newStates = states
                newStates[index].toggle()
                return newStates
            })
            .bind(to: checkboxStatesProperty)
            .disposed(by: disposeBag)
        
        let modifiedSurvey = Observable.combineLatest(surveyProperty, checkboxStatesProperty)
            .map({ survey, states -> SurveyAnswer in
                var newSurvey = survey
                newSurvey.checkbox.states = states
                return newSurvey
            })
        
        let survey = Observable.merge(surveyProperty.asObservable(), modifiedSurvey)
        
        submitButtonClickedProperty
            .withLatestFrom(survey)
            .do(onNext: { [weak self] _ in self?.isLoadingProperty.accept(true) })
            .flatMap(network.submitSurvey(survey:))
            .bind(onNext: { [weak self] result in
                self?.isLoadingProperty.accept(false)
                switch result {
                case .success(let msg):
                    self?.alertProperty.accept(.success(msg))
                case .failure(let err):
                    self?.alertProperty.accept(.error(err.localizedDescription))
                }
            })
            .disposed(by: disposeBag)
        
        backButtonClickedProperty
            .withLatestFrom(survey)
            .map { Form3Coordinating.back($0) }
            .bind(to: coordinateProperty)
            .disposed(by: disposeBag)
        
        submissionSuccessProperty
            .map { Form3Coordinating.finish }
            .bind(to: coordinateProperty)
            .disposed(by: disposeBag)
    }
    
    deinit {
        print("form 3 view model deinited")
    }
    
    // MARK: - Functions
}

