//
//  Form1ViewController.swift
//  MultiStepForm
//
//  Created by Jaedoo Ko on 2020/08/07.
//  Copyright © 2020 jko. All rights reserved.
//

import UIKit

final class Form1ViewController: UIViewController {

    // MARK: - UI Properties
    
    private let textField: UITextField = UITextField()
    
    // MARK: - Properties
    
    private let survey: SurveyAnswer
    private weak var coordinator: (Form2CoordinatorType & SurveyFinishCoordinatorType)?
    
    // MARK: - Lifecycle

    init(
        survey: SurveyAnswer,
        coordinator: Form2CoordinatorType & SurveyFinishCoordinatorType
    ) {
        self.survey = survey
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLayout()
        bindStyles()
        setNextButton()
        setBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textField.text = survey.text
        textField.layoutIfNeeded()
    }
    
    // MARK: - Functions
    
    private func setUpLayout() {
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
    }
    
    private func setBackButton() {
        let backButton = UIBarButtonItem(
            title: "Back",
            style: .plain,
            target: self,
            action: #selector(backButtonClicked(_:))
        )
        navigationItem.setLeftBarButton(backButton, animated: true)
    }
    
    private func setNextButton() {
        let nextButton = UIBarButtonItem(
            title: "Next",
            style: .done,
            target: self,
            action: #selector(nextButtonClicked(_:))
        )
        navigationItem.setRightBarButton(nextButton, animated: true)
    }
    
    @objc
    private func nextButtonClicked(_ sender: UIBarButtonItem) {
        changeText()
        pushToNext()
    }
    
    private func pushToNext() {
        coordinator?.pushToForm2(survey: survey)
    }
    
    private func changeText() {
        let text = textField.text ?? ""
        survey.text = text
    }
    
    @objc
    private func backButtonClicked(_ sender: UIBarButtonItem) {
        coordinator?.finishSurveyForm()
    }
}
