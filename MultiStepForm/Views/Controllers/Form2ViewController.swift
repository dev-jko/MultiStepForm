//
//  Form2ViewController.swift
//  MultiStepForm
//
//  Created by Jaedoo Ko on 2020/08/07.
//  Copyright © 2020 jko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class Form2ViewController: UIViewController {    
    
    // MARK: - UI Properties
    
    private let buttons: [UIButton] = [UIButton(), UIButton()]
    private let nextButton: UIBarButtonItem = UIBarButtonItem()
    private let backButton: UIBarButtonItem = UIBarButtonItem()
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private weak var coordinator: (Form3CoordinatorType & PreviousFormCoordinateType)?
    private let viewModel: Form2ViewModelType
    
    // MARK: - Lifecycle
    
    init(
        survey: SurveyAnswer,
        coordinator: Form3CoordinatorType & PreviousFormCoordinateType,
        viewModel: Form2ViewModelType
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
        print("form 2 view controller deinited")
    }
    
    // MARK: - Functions
    
    private func bindViewModel() {
        
        nextButton.rx.tap
            .bind(onNext: { [weak self] in self?.viewModel.inputs.nextButtonClicked() })
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .bind(onNext: { [weak self] in self?.viewModel.inputs.backButtonClicked() })
            .disposed(by: disposeBag)
        
        buttons.enumerated().forEach({ [weak self] idx, btn in
            btn.rx.tap
                .bind(onNext: { self?.viewModel.inputs.radioButtonClicked(index: idx) })
                .disposed(by: disposeBag)
        })
        
        viewModel.outputs.selectedRadioButton()
            .drive(onNext: { [weak self] in self?.buttonSelectionChagned(index: $0) })
            .disposed(by: disposeBag)
        
        viewModel.outputs.coordinate()
            .emit(onNext: { [weak self] in
                switch $0 {
                case .next(let survey):
                    self?.coordinator?.pushToForm3(survey: survey)
                case .back(let survey):
                    self?.coordinator?.backToPreviousForm(survey: survey)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setUpLayout() {
        navigationItem.setRightBarButton(nextButton, animated: true)
        navigationItem.setLeftBarButton(backButton, animated: true)
        
        buttons.forEach {
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
            buttons[1].widthAnchor.constraint(equalTo: buttons[0].widthAnchor)
        ])
    }
    
    private func bindStyles() {
        view.backgroundColor = .white
        
        buttons.forEach { btn in
            btn.setTitleColor(.black, for: .normal)
            btn.setTitleColor(.white, for: .selected)
            btn.backgroundColor = .white
            btn.layer.borderColor = UIColor.black.cgColor
            btn.layer.borderWidth = 1
        }
        buttons[0].setTitle("A", for: .normal)
        buttons[1].setTitle("B", for: .normal)
        
        nextButton.title = "Next"
        nextButton.style = .done
        
        backButton.title = "Back"
        backButton.style = .plain
    }
    
    private func buttonSelectionChagned(index: Int) {
        buttons.enumerated().forEach { idx, btn in
            if idx == index {
                btn.isSelected = true
                btn.backgroundColor = .systemBlue
                btn.layer.borderWidth = 0
            } else {
                btn.isSelected = false
                btn.backgroundColor = .white
                btn.layer.borderWidth = 1
            }
        }
    }
}

extension Form2ViewController: SurveyGettable {
    func getSurvey(_ survey: SurveyAnswer) {
        viewModel.inputs.survey(survey)
    }
}
