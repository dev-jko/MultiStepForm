//
//  DI.swift
//  MultiStepForm
//
//  Created by Jaedoo Ko on 2020/08/09.
//  Copyright © 2020 jko. All rights reserved.
//

import UIKit

extension AppDependency {
    static func resolve() -> AppDependency {
        let network: NetworkType = Network()
        
        return .init(
            appCoordinator: AppCoordinator(
                viewControllerFactory: { coordinator in
                    HomeViewController(
                        coordinator: coordinator,
                        viewModel: HomeViewModel()
                    )
                },
                surveyCoordinatorFactory: { navigationController in
                    SurveyCoordinator(
                        navigationController: navigationController,
                        surveyAnswerFactory: { SurveyAnswer() },
                        form1ViewControllerFactory: { survey, coordinator in
                            Form1ViewController(
                                survey: survey,
                                coordinator: coordinator,
                                viewModel: Form1ViewModel()
                            )
                        },
                        form2ViewControllerFactory: { survey, coordinator in
                            Form2ViewController(
                                survey: survey,
                                coordinator: coordinator,
                                viewModel: Form2ViewModel()
                            )
                        },
                        form3ViewControllerFactory: { survey, coordinator in
                            Form3ViewController(
                                survey: survey,
                                coordinator: coordinator,
                                network: network
                            )
                        }
                    )
                }
            )
        )
    }
}


struct AppDependency {
    let appCoordinator: AppCoordinatorType
}

extension HomeViewController {
    typealias Factory = (SurveyFormCoordinatorType) -> HomeViewController
}

extension SurveyCoordinator {
    typealias Factory = (UINavigationController) -> Coordinator
}

extension SurveyAnswer {
    typealias Factory = () -> SurveyAnswer
}

extension Form1ViewController {
    typealias Factory = (SurveyAnswer, Form2CoordinatorType & SurveyFinishCoordinatorType) -> Form1ViewController
}

extension Form2ViewController {
    typealias Factory = (SurveyAnswer, Form3CoordinatorType & PreviousFormCoordinateType) -> Form2ViewController
}

extension Form3ViewController {
    typealias Factory = (SurveyAnswer, SurveyFinishCoordinatorType & PreviousFormCoordinateType) -> Form3ViewController
}
