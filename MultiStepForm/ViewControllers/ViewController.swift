//
//  ViewController.swift
//  MultiStepForm
//
//  Created by Jaedoo Ko on 2020/08/07.
//  Copyright © 2020 jko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let titleLabel: UILabel = UILabel()
    private let surveyButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLayout()
        bindStyles()
        
        surveyButton.addTarget(
            self,
            action: #selector(surveyButtonClicked(_:)),
            for: .touchUpInside
        )
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
    
    @objc
    private func surveyButtonClicked(_ sender: UIButton) {
        let survey = SurveyAnswer()
        let viewController = Form1ViewController(survey: survey)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
