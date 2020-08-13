//
//  Form1ViewController.swift
//  MultiStepForm
//
//  Created by Jaedoo Ko on 2020/08/07.
//  Copyright © 2020 jko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class Form1ViewController: UIViewController {

    // MARK: - UI Properties
    
    private let textField: UITextField = UITextField()
    private let backButton: UIBarButtonItem = UIBarButtonItem()
    private let nextButton: UIBarButtonItem = UIBarButtonItem()
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private weak var coordinator: (Form2CoordinatorType & SurveyFinishCoordinatorType)?
    private let viewModel: Form1ViewModelType
    
    // MARK: - Lifecycle

    init(
        survey: SurveyAnswer,
        coordinator: Form2CoordinatorType & SurveyFinishCoordinatorType,
        viewModel: Form1ViewModelType
    ) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        viewModel.inputs.survey(survey)
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
    
    deinit {
        print("form 1 view controller deinited")
    }
    
    // MARK: - Functions
    
    private func bindViewModel() {
        textField.rx.text
            .orEmpty
            .bind(onNext: viewModel.inputs.textAnswer(_:))
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in self?.viewModel.inputs.navigationButtonClicked(.next) })
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in self?.viewModel.inputs.navigationButtonClicked(.back) })
            .disposed(by: disposeBag)
        
        viewModel.outputs.surveyAnswerText()
            .drive(textField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.coordinating()
            .emit(onNext: { [weak self] data in
                switch data {
                case .next(let survey):
                    self?.coordinator?.pushToForm2(survey: survey)
                case .back:
                    self?.coordinator?.finishSurveyForm()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setUpLayout() {
        navigationItem.setLeftBarButton(backButton, animated: true)
        navigationItem.setRightBarButton(nextButton, animated: true)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100)
        ])
    }
    
    private func bindStyles() {
        view.backgroundColor = .white
        
        textField.placeholder = "answer1"
        textField.textColor = .black
        textField.borderStyle = .line
        
        backButton.title = "Back"
        backButton.style = .plain
        
        nextButton.title = "Next"
        nextButton.style = .done
    }
}
