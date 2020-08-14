//
//  SurveyCoordinator.swift
//  MultiStepForm
//
//  Created by Jaedoo Ko on 2020/08/09.
//  Copyright © 2020 jko. All rights reserved.
//

import UIKit

protocol SurveyGettable {
    func getSurvey(_ survey: SurveyAnswer)
}

protocol PreviousFormCoordinateType: class {
    func backToPreviousForm(survey: SurveyAnswer)
}

protocol Form2CoordinatorType: class {
    func pushToForm2(survey: SurveyAnswer)
}

protocol Form3CoordinatorType: class {
    func pushToForm3(survey: SurveyAnswer)
}

protocol SurveyFinishCoordinatorType: class {
    func finishSurveyForm()
}

class SurveyCoordinator: Coordinator {
        
    // MARK: - Properties
    
    var parent: Coordinator?
    var children: [Coordinator] = []
    private let navigationController: UINavigationController
    private let surveyAnswerFactory: SurveyAnswer.Factory
    private let form1ViewControllerFactory: Form1ViewController.Factory
    private let form2ViewControllerFactory: Form2ViewController.Factory
    private let form3ViewControllerFactory: Form3ViewController.Factory
    
    // MARK: - Lifecycle
    
    init(
        navigationController: UINavigationController,
        surveyAnswerFactory: @escaping SurveyAnswer.Factory,
        form1ViewControllerFactory: @escaping Form1ViewController.Factory,
        form2ViewControllerFactory: @escaping Form2ViewController.Factory,
        form3ViewControllerFactory: @escaping Form3ViewController.Factory
    ) {
        self.navigationController = navigationController
        self.surveyAnswerFactory = surveyAnswerFactory
        self.form1ViewControllerFactory = form1ViewControllerFactory
        self.form2ViewControllerFactory = form2ViewControllerFactory
        self.form3ViewControllerFactory = form3ViewControllerFactory
    }
    
    // MARK: - Functions
    
    func start() {
        let survey = surveyAnswerFactory()
        let viewController = form1ViewControllerFactory(survey, self)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension SurveyCoordinator: Form2CoordinatorType {
    func pushToForm2(survey: SurveyAnswer) {
        let viewController = form2ViewControllerFactory(survey, self)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension SurveyCoordinator: Form3CoordinatorType {
    func pushToForm3(survey: SurveyAnswer) {
        let viewController = form3ViewControllerFactory(survey, self)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension SurveyCoordinator: SurveyFinishCoordinatorType {
    func finishSurveyForm() {
        navigationController.dismiss(animated: true, completion: nil)
        parent?.popChild()
    }
}

extension SurveyCoordinator: PreviousFormCoordinateType {
    func backToPreviousForm(survey: SurveyAnswer) {
        navigationController.popViewController(animated: true)
        if let viewController = navigationController.topViewController as? SurveyGettable {
            viewController.getSurvey(survey)
        }
    }
}
