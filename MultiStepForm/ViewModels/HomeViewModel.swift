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

enum HomeCoordinating {
    case survey
}

protocol HomeViewModelInputs {
    func surveyButtonClicked()
}

protocol HomeViewModelOutputs {
    func coordinate() -> Signal<HomeCoordinating>
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
    
    private let surveyButtonClickedProperty: PublishRelay<Void> = PublishRelay()
    func surveyButtonClicked() {
        surveyButtonClickedProperty.accept(Void())
    }
    
    // MARK: - Outputs
    
    private let coordinateProperty: PublishRelay<HomeCoordinating> = PublishRelay()
    func coordinate() -> Signal<HomeCoordinating> {
        return coordinateProperty.asSignal()
    }
    
    
    // MARK: - Lifecycle
    
    init() {
        surveyButtonClickedProperty
            .map { HomeCoordinating.survey }
            .bind(to: coordinateProperty)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Functions
}

