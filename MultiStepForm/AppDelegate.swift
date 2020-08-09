//
//  AppDelegate.swift
//  MultiStepForm
//
//  Created by Jaedoo Ko on 2020/08/07.
//  Copyright © 2020 jko. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let appCoordinator: AppCoordinatorType
    
    override init() {
        let dependency = AppDependency.resolve()
        appCoordinator = dependency.appCoordinator
        
        super.init()
    }
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        window = appCoordinator.window
        appCoordinator.start()
        
        return true
    }
}

