//
//  Form2ViewController.swift
//  MultiStepForm
//
//  Created by Jaedoo Ko on 2020/08/07.
//  Copyright © 2020 jko. All rights reserved.
//

import UIKit

class Form2ViewController: UIViewController {    
    
    // MARK: - UI Properties
    
    private let buttons: [UIButton] = [UIButton(), UIButton()]
    private var button1: UIButton { buttons[0] }
    private var button2: UIButton { buttons[1] }
    
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
        
        buttons.enumerated().forEach { index, btn in
            btn.tag = index
            btn.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        buttonSelectionChagned(index: survey.radio.rawValue - 1)
    }
    
    // MARK: - Functions
    
    private func setUpLayout() {
        [button1, button2].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            button1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            button1.trailingAnchor.constraint(equalTo: button2.leadingAnchor),
            button1.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            
            button2.leadingAnchor.constraint(equalTo: button1.trailingAnchor),
            button2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            button2.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            button2.widthAnchor.constraint(equalTo: button1.widthAnchor)
        ])
    }
    
    private func bindStyles() {
        view.backgroundColor = .white
        
        [button1, button2].forEach { btn in
            btn.setTitleColor(.black, for: .normal)
            btn.setTitleColor(.white, for: .selected)
            btn.backgroundColor = .white
            btn.layer.borderColor = UIColor.black.cgColor
            btn.layer.borderWidth = 1
        }
        button1.setTitle("A", for: .normal)
        button2.setTitle("B", for: .normal)
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
        let viewController = Form3ViewController(survey: survey)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func buttonSelectionChagned(index: Int) {
        buttons.forEach { btn in
            if btn.tag == index {
                btn.backgroundColor = .systemBlue
                btn.layer.borderWidth = 0
                btn.isSelected = true
            } else {
                btn.backgroundColor = .white
                btn.layer.borderWidth = 1
                btn.isSelected = false
            }
        }
    }
    
    @objc
    private func buttonClicked(_ sender: UIButton) {
        guard let selection = SurveyAnswer.Radio(rawValue: sender.tag + 1) else { return }
        survey.radio = selection
        buttonSelectionChagned(index: sender.tag)
    }
}
