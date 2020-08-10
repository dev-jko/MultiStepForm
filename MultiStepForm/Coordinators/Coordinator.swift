//
//  Coordinator.swift
//  MultiStepForm
//
//  Created by Jaedoo Ko on 2020/08/09.
//  Copyright © 2020 jko. All rights reserved.
//

import Foundation

protocol Coordinator: class {
    var parent: Coordinator? { get set }
    var children: [Coordinator] { get set }
    
    func start()
    func popChild()
}

extension Coordinator {
    func popChild() {
        guard !children.isEmpty else { return }
        _ = children.popLast()
    }
}
