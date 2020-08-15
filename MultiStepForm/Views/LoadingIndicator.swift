//
//  LoadingIndicator.swift
//  MultiStepForm
//
//  Created by Jaedoo Ko on 2020/08/10.
//  Copyright © 2020 jko. All rights reserved.
//

import UIKit

public class LoadingIndicator: UIView {
    
    // MARK: - UI Properties
    
    private let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    
    // MARK: - Properties
    
    public var isLoading: Bool = false {
        didSet {
            if isLoading { startAnimating() }
            else { stopAnimating() }
        }
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpLayout()
        bindStyles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setUpLayout() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            self.widthAnchor.constraint(greaterThanOrEqualToConstant: 80),
            self.heightAnchor.constraint(greaterThanOrEqualToConstant: 80)
        ])
    }
    
    private func bindStyles() {
        self.backgroundColor = .lightGray
        self.layer.cornerRadius = 15
    }
        
    public func startAnimating() {
        activityIndicator.startAnimating()
        self.isHidden = false
    }
    
    public func stopAnimating() {
        activityIndicator.stopAnimating()
        self.isHidden = true
    }
}
