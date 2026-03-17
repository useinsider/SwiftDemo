//
//  UIImage+Design.swift
//  Example
//
//  Created by Insider on 22.12.2025.
//

import UIKit

extension UIImage {

    public static func dynamicImage(light: UIImage?, dark: UIImage?) -> UIImage {
        let imageAsset = UIImageAsset()
        if let light {
            let lightTrait = UITraitCollection(userInterfaceStyle: .light)
            imageAsset.register(light, with: lightTrait)
        }
        if let dark {
            let darkTrait = UITraitCollection(userInterfaceStyle: .dark)
            imageAsset.register(dark, with: darkTrait)
        }
        return imageAsset.image(with: .current)
    }

    public convenience init?(color: UIColor, size: CGSize) {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        guard let cgImage = image.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }

    public convenience init?(gradient: (start: UIColor, end: UIColor), size: CGSize) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            gradient.start.cgColor,
            gradient.end.cgColor
        ]
        gradientLayer.locations = [0.0, 0.6]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.frame = CGRect(origin: .zero, size: size)

        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }

        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        gradientLayer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }

    private func withAlphaComponent(_ alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension UIImage {

    public static let buttonBackground = dynamicImage(
        light: UIImage(
            gradient: (.gradientOrange, .gradientRed),
            size: CGSize(width: 10, height: 10)
        ),
        dark: UIImage(
            color: .nova,
            size: CGSize(width: 10, height: 10)
        )
    )

    public static let buttonBackgroundHighlighted = dynamicImage(
        light: UIImage(
            gradient: (.gradientOrange, .gradientRed),
            size: CGSize(width: 10, height: 10)
        )?.withAlphaComponent(0.8),
        dark: UIImage(
            color: .nova,
            size: CGSize(width: 10, height: 10)
        )?.withAlphaComponent(0.8)
    )
}
