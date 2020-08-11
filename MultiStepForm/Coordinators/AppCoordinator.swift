//
//  AppCoordinator.swift
//  MultiStepForm
//
//  Created by Jaedoo Ko on 2020/08/09.
//  Copyright © 2020 jko. All rights reserved.
//

import UIKit

protocol AppCoordinatorType: Coordinator {
    var window: UIWindow { get }
}

protocol SurveyFormCoordinatorType: class {
    func pushToSurveyForm()
}

class AppCoordinator: AppCoordinatorType {
    
    // MARK: - Properties
    
    lazy var window: UIWindow = UIWindow()
    var parent: Coordinator?
    var children = [Coordinator]()
    private let viewControllerFactory: HomeViewController.Factory
    private let surveyCoordinatorFactory: SurveyCoordinator.Factory
    
    // MARK: - Lifecycle
    
    init(
        viewControllerFactory: @escaping HomeViewController.Factory,
        surveyCoordinatorFactory: @escaping SurveyCoordinator.Factory
    ) {
        self.viewControllerFactory = viewControllerFactory
        self.surveyCoordinatorFactory = surveyCoordinatorFactory
    }
    
    // MARK: - Functions
    
    func start() {
        let viewController = viewControllerFactory(self)
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}

extension AppCoordinator: SurveyFormCoordinatorType {
    func pushToSurveyForm() {
        let navigationController = UINavigationController()
        navigationController.modalPresentationStyle = .fullScreen

        let coordinator = surveyCoordinatorFactory(navigationController)
        coordinator.parent = self
        coordinator.start()
        children.append(coordinator)
        
        window.rootViewController?.present(navigationController, animated: true, completion: nil)
    }
}
