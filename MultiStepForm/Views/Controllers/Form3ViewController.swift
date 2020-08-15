//
//  Form3ViewController.swift
//  MultiStepForm
//
//  Created by Jaedoo Ko on 2020/08/07.
//  Copyright © 2020 jko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class Form3ViewController: UIViewController {
    
    // MARK: - UI Properties
    
    private let buttons: [UIButton] = [UIButton(), UIButton(), UIButton(), UIButton()]
    private let loadingIndicator: LoadingIndicator = LoadingIndicator()
    private let submitButton = UIBarButtonItem()
    private let backButton = UIBarButtonItem()
    
    // MARK: - Properties
    
    private weak var coordinator: (SurveyFinishCoordinatorType & PreviousFormCoordinateType)?
    private let viewModel: Form3ViewModelType
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    init(
        survey: SurveyAnswer,
        coordinator: SurveyFinishCoordinatorType & PreviousFormCoordinateType,
        viewModel: Form3ViewModelType
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
        
        buttons.enumerated().forEach { index, btn in
            btn.tag = index
            btn.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        }
    }
    
    deinit {
        print("form 3 view controller deinited")
    }
    
    // MARK: - Functions
    
    private func bindViewModel() {
        
//        self?.alert(title: "제출 완료", message: msg, completion: self?.coordinator?.finishSurveyForm)
//        self?.alert(title: "에러", message: err.localizedDescription, completion: nil)
        
        submitButton.rx.tap
            .bind(onNext: { [weak self] in self?.viewModel.inputs.submitButtonClicked() })
            .disposed(by: disposeBag)
            
        backButton.rx.tap
            .bind(onNext: { [weak self] in self?.viewModel.inputs.backButtonClicked() })
            .disposed(by: disposeBag)
        
        viewModel.outputs.isLoading()
            .drive(onNext: { [weak self] in self?.loadingIndicator.isLoading = $0 })
            .disposed(by: disposeBag)
        
        viewModel.outputs.alert()
            .emit(onNext: { [weak self] type in
                switch type {
                case .success(let msg):
                    self?.alert(title: type.title, message: msg, completion: self?.viewModel.inputs.submissionSuccess)
                case .error(let err):
                    self?.alert(title: type.title, message: err, completion: nil)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.coordinate()
            .emit(onNext: { [weak self] in
                switch $0 {
                case .finish:
                    self?.coordinator?.finishSurveyForm()
                case .back(let survey):
                    self?.coordinator?.backToPreviousForm(survey: survey)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setUpLayout() {
        navigationItem.setRightBarButton(submitButton, animated: true)
        navigationItem.setLeftBarButton(backButton, animated: true)
        
        (buttons + [loadingIndicator])
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            buttons[0].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            buttons[0].trailingAnchor.constraint(equalTo: buttons[1].leadingAnchor),
            buttons[0].topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            
            buttons[1].leadingAnchor.constraint(equalTo: buttons[0].trailingAnchor),
            buttons[1].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            buttons[1].topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            buttons[1].widthAnchor.constraint(equalTo: buttons[0].widthAnchor),
            
            buttons[2].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            buttons[2].trailingAnchor.constraint(equalTo: buttons[3].leadingAnchor),
            buttons[2].topAnchor.constraint(equalTo: buttons[0].bottomAnchor),
            
            buttons[3].leadingAnchor.constraint(equalTo: buttons[2].trailingAnchor),
            buttons[3].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            buttons[3].topAnchor.constraint(equalTo: buttons[0].bottomAnchor),
            buttons[3].widthAnchor.constraint(equalTo: buttons[2].widthAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bindStyles() {
        view.backgroundColor = .white
        
        buttons.forEach { btn in
            btn.setTitleColor(.black, for: .normal)
            btn.setTitleColor(.white, for: .selected)
            btn.layer.borderColor = UIColor.black.cgColor
        }
        buttons[0].setTitle("A", for: .normal)
        buttons[1].setTitle("B", for: .normal)
        buttons[2].setTitle("C", for: .normal)
        buttons[3].setTitle("D", for: .normal)
        
        submitButton.title = "Submit"
        submitButton.style = .done
        
        backButton.title = "Back"
        backButton.style = .plain
    }
    
    private func buttonSelectionChagned(isSelected: Bool, index: Int) {
        let btn = buttons[index]
        if isSelected {
            btn.backgroundColor = .systemBlue
            btn.layer.borderWidth = 0
            btn.isSelected = true
        } else {
            btn.backgroundColor = .white
            btn.layer.borderWidth = 1
            btn.isSelected = false
        }
    }
    
    @objc
    private func buttonClicked(_ sender: UIButton) {
        let index = sender.tag
        let value = !sender.isSelected
//        survey.checkbox[index] = value
        buttonSelectionChagned(isSelected: value, index: index)
    }
}
