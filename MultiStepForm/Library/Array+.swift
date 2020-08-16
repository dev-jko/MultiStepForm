//
//  Array+.swift
//  MultiStepForm
//
//  Created by Jaedoo Ko on 2020/08/16.
//  Copyright © 2020 jko. All rights reserved.
//

import Foundation

extension Array {
    func indexAt(index: Int) -> Element? {
        guard index < self.count else { return nil }
        return self[index]
    }
}
