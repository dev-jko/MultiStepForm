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
    private var children = [Coordinator]()
    private let viewControllerFactory: ViewController.Factory
    private let surveyCoordinatorFactory: SurveyCoordinator.Factory
    
    // MARK: - Lifecycle
    
    init(
        viewControllerFactory: @escaping ViewController.Factory,
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
        let coordinator = surveyCoordinatorFactory(navigationController)
        coordinator.start()
        children.append(coordinator)
        
        if let rootViewController = window.rootViewController {
            navigationController.modalPresentationStyle = .fullScreen
            rootViewController.present(navigationController, animated: true, completion: nil)
        } else {
            window.rootViewController = navigationController
        }
    }
}
