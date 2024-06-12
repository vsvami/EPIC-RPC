//
//  CustomProgressViewFactory.swift
//  EPICRPS
//
//  Created by Vladimir Dmitriev on 11.06.24.
//

import UIKit

protocol ProgressViewFactory {
    func createProgressView() -> UIProgressView
}

final class CustomProgressViewFactory: ProgressViewFactory {
    
    let tintColor: UIColor
    let angle: Double

    init(tintColor: UIColor, angle: Double) {
        self.tintColor = tintColor
        self.angle = angle
    }

    func createProgressView() -> UIProgressView {
        let progressView = UIProgressView()
        progressView.transform = CGAffineTransform(rotationAngle: .pi / angle)
        progressView.progress = 0.5
        progressView.tintColor = tintColor
        progressView.backgroundColor = .customBlue
        
        return progressView
    }
}
