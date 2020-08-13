//
//  HomeViewController.swift
//  MultiStepForm
//
//  Created by Jaedoo Ko on 2020/08/07.
//  Copyright © 2020 jko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    // MARK: - UI Properties
    
    private let titleLabel: UILabel = UILabel()
    private let surveyButton: UIButton = UIButton()
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private weak var coordinator: SurveyFormCoordinatorType?
    private let viewModel: HomeViewModelType
    
    // MARK: - Lifecycle
    
    init(
        coordinator: SurveyFormCoordinatorType,
        viewModel: HomeViewModelType
    ) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLayout()
        bindStyles()
        bindViewModel()
    }
    
    // MARK: - Functions
    
    private func bindViewModel() {
        surveyButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in self?.viewModel.inputs.surveyButtonClicked() })
            .disposed(by: disposeBag)
        
        viewModel.outputs.presentSurveyForm()
            .emit(onNext: { [weak self] in self?.coordinator?.pushToSurveyForm() })
            .disposed(by: disposeBag)
    }
    
    private func setUpLayout() {
        [
            titleLabel,
            surveyButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            
            surveyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            surveyButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 100),
        ])
    }
    
    private func bindStyles() {
        view.backgroundColor = .white
        
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.text = "Multi Step Form"
        
        surveyButton.setTitle("설문조사 시작", for: .normal)
        surveyButton.setTitleColor(.white, for: .normal)
        surveyButton.backgroundColor = .systemBlue
    }
}
