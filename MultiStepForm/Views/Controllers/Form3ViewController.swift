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
    
    private let stackView: UIStackView = UIStackView()
    private let loadingIndicator: LoadingIndicator = LoadingIndicator()
    private let submitButton = UIBarButtonItem()
    private let backButton = UIBarButtonItem()
    
    // MARK: - Properties
    
    private weak var coordinator: (SurveyFinishCoordinatorType & PreviousFormCoordinateType)?
    private var viewModel: Form3ViewModelType
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
    }
    
    deinit {
        print("form 3 view controller deinited")
    }
    
    // MARK: - Functions
    
    private func bindViewModel() {
        
        submitButton.rx.tap
            .bind(onNext: { [weak self] in self?.viewModel.inputs.submitButtonClicked() })
            .disposed(by: disposeBag)
            
        backButton.rx.tap
            .bind(onNext: { [weak self] in self?.viewModel.inputs.backButtonClicked() })
            .disposed(by: disposeBag)
        
        viewModel.outputs.checkboxes()
            .compactMap({ [weak self] in self?.makeCheckboxButtons(descriptions: $0) })
            .drive(onNext: { [weak self] btns in
                self?.configureCheckbox(buttons: btns)
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.checkboxStates()
            .drive(onNext: { [weak self] states in
                states.enumerated().forEach { self?.buttonSelectionChagned(index: $0, isSelected: $1) }
            })
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
        
        [stackView, loadingIndicator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bindStyles() {
        view.backgroundColor = .white
        
        submitButton.title = "Submit"
        submitButton.style = .done
        
        backButton.title = "Back"
        backButton.style = .plain
        
        stackView.axis = .vertical
        stackView.alignment = .center
    }
    
    private func buttonSelectionChagned(index: Int, isSelected: Bool) {
        guard let btn = stackView.arrangedSubviews.indexAt(index: index) as? UIButton else { return }
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
    
    private func makeCheckboxButtons(descriptions: [String]) -> [UIButton] {
        return descriptions.map {
            let btn = UIButton()
            btn.setTitleColor(.black, for: .normal)
            btn.setTitleColor(.white, for: .selected)
            btn.layer.borderColor = UIColor.black.cgColor
            btn.setTitle($0, for: .normal)
            return btn
        }
    }
    
    private func configureCheckbox(buttons: [UIButton]) {
        buttons.enumerated().forEach { idx, btn in
            stackView.addArrangedSubview(btn)
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.widthAnchor.constraint(greaterThanOrEqualTo: view.widthAnchor, multiplier: 0.6).isActive = true
            btn.tag = idx
            btn.addTarget(self, action: #selector(checkboxButtonClicked(_:)), for: .touchUpInside)
        }
    }
    
    @objc
    private func checkboxButtonClicked(_ sender: UIButton) {
        viewModel.inputs.checkboxButtonClicked(index: sender.tag)
    }
}
