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
    
    // MARK: - Lifecycle

    init(survey: SurveyAnswer) {
        self.survey = survey
        
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
        let viewController = Form2ViewController(survey: survey)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func changeText() {
        let text = textField.text ?? ""
        survey.text = text
    }
}
