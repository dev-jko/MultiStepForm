//
//  Alertable.swift
//  MultiStepForm
//
//  Created by Jaedoo Ko on 2020/08/10.
//  Copyright © 2020 jko. All rights reserved.
//

import UIKit

protocol Alertable {
    func alert(title: String, message: String, completion: (() -> Void)?)
    func dismissAlert(_ sender: TapGestureRecognizer)
}

class TapGestureRecognizer: UITapGestureRecognizer {
    var completion: (() -> Void)?
    
    init(target: Any?, action: Selector?, completion: (() -> Void)? = nil) {
        self.completion = completion
        
        super.init(target: target, action: action)
    }
}

extension UIViewController: Alertable {
    func alert(title: String, message: String, completion: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true) { [weak self] in
            let recognizer = TapGestureRecognizer(
                target: self,
                action: #selector(self?.dismissAlert(_:)),
                completion: completion
            )
            alert.view.superview?.addGestureRecognizer(recognizer)
            alert.view.superview?.isUserInteractionEnabled = true
        }
    }
    
    @objc
    func dismissAlert(_ sender: TapGestureRecognizer) {
        self.dismiss(animated: true, completion: sender.completion)
    }
}
