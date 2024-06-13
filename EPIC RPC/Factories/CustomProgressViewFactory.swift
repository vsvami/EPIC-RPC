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
    
    let value: Float
    let tintColor: UIColor
    let angle: Double

    init(value: Float, tintColor: UIColor, angle: Double) {
        self.value = value
        self.tintColor = tintColor
        self.angle = angle
    }

    func createProgressView() -> UIProgressView {
        let progressView = UIProgressView()
        progressView.transform = CGAffineTransform(rotationAngle: .pi / angle)
        progressView.progress = value
        progressView.tintColor = tintColor
        progressView.backgroundColor = .customBlue
        
        return progressView
    }
}
