//
//  HomeViewModel.swift
//  MultiStepForm
//
//  Created by Jaedoo Ko on 2020/08/11.
//  Copyright © 2020 jko. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol HomeViewModelInputs {
    func deinited()
    func surveyButtonClicked()
}

protocol HomeViewModelOutputs {
    func presentSurveyForm() -> Signal<Void>
}

protocol HomeViewModelType {
    var inputs: HomeViewModelInputs { get }
    var outputs: HomeViewModelOutputs { get }
}

final class HomeViewModel: HomeViewModelType,
HomeViewModelInputs, HomeViewModelOutputs {
    
    // MARK: - Properties
    
    var inputs: HomeViewModelInputs { return self }
    var outputs: HomeViewModelOutputs { return self }
    private var disposeBag = DisposeBag()
    
    // MARK: - Inputs
    
    private let deinitedProperty: PublishRelay<Void> = PublishRelay()
    func deinited() {
        deinitedProperty.accept(Void())
    }
    
    private let surveyButtonClickedProperty: PublishRelay<Void> = PublishRelay()
    func surveyButtonClicked() {
        surveyButtonClickedProperty.accept(Void())
    }
    
    // MARK: - Outputs
    
    private let presentSurveyFormProperty: PublishRelay<Void> = PublishRelay()
    func presentSurveyForm() -> Signal<Void> {
        return presentSurveyFormProperty.asSignal()
    }
    
    
    // MARK: - Lifecycle
    
    init() {
        
        deinitedProperty
            .bind(onNext: { self.disposeBag = DisposeBag() })
            .disposed(by: disposeBag)
        
        surveyButtonClickedProperty
            .bind(to: presentSurveyFormProperty)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Functions
}

