//
//  Form3ViewController.swift
//  MultiStepForm
//
//  Created by Jaedoo Ko on 2020/08/07.
//  Copyright © 2020 jko. All rights reserved.
//

import UIKit

class Form3ViewController: UIViewController {
    
    // MARK: - UI Properties
    
    private let buttons: [UIButton] = [UIButton(), UIButton(), UIButton(), UIButton()]
    
    // MARK: - Properties
    
    private let survey: SurveyAnswer
    private weak var coordinator: SurveySubmitCoordinatorType?
    private let network: NetworkType
    
    // MARK: - Lifecycle
    
    init(
        survey: SurveyAnswer,
        coordinator: SurveySubmitCoordinatorType,
        network: NetworkType
    ) {
        self.survey = survey
        self.coordinator = coordinator
        self.network = network
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLayout()
        bindStyles()
        setSubmitButton()
        
        buttons.enumerated().forEach { index, btn in
            btn.tag = index
            btn.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for i in 0..<buttons.count {
            buttonSelectionChagned(isSelected: survey.checkbox[i], index: i)
        }
    }
    
    // MARK: - Functions
    
    private func setUpLayout() {
        buttons
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
    }
    
    private func setSubmitButton() {
        let submitButton = UIBarButtonItem(
            title: "Submit",
            style: .done,
            target: self,
            action: #selector(submitButtonClicked(_:))
        )
        navigationItem.setRightBarButton(submitButton, animated: true)
    }
    
    @objc
    private func submitButtonClicked(_ sender: UIBarButtonItem) {
        network.submitSurvey(survey: survey) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let msg):
                    self?.coordinator?.finishSurveyForm()
                case .failure(let err):
                    self?.coordinator?.alertError()
                }
            }
        }
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
        survey.checkbox[index] = value
        buttonSelectionChagned(isSelected: value, index: index)
    }
}
