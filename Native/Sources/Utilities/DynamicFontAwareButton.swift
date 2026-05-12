//
//  DynamicFontAwareButton.swift
//  Example
//
//  Created by Insider on 22.12.2025.
//

import UIKit

@MainActor public final class DynamicFontAwareButton: UIButton {

    private var font: Font?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupNotification()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupNotification()
    }

    public func setFont(_ font: Font) {
        self.font = font
        updateFont()
    }

    private func setupNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contentSizeCategoryDidChange),
            name: UIContentSizeCategory.didChangeNotification,
            object: nil
        )
    }

    @objc private func contentSizeCategoryDidChange() {
        updateFont()
    }

    private func updateFont() {
        guard let font else { return }
        if var configuration {
            configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = .scaledFont(font)
                return outgoing
            }
            self.configuration = configuration
        } else {
            self.titleLabel?.font = .scaledFont(font)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
 }
