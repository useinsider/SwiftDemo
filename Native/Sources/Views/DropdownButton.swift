//
//  DropdownButton.swift
//  Example
//
//  Created by Insider on 26.11.2026.
//

import UIKit

/// A button that opens a single-selection menu of `options` and shows the selected one as its title.
@MainActor public final class DropdownButton: UIButton {

    public private(set) var selectedIndex: Int

    public var onSelect: ((Int) -> Void)?

    public init(options: [String], selectedIndex: Int = 0, accessibilityIdentifier: String) {
        self.selectedIndex = selectedIndex
        super.init(frame: .zero)

        var configuration = UIButton.Configuration.gray()
        configuration.baseForegroundColor = .textPrimary
        configuration.image = UIImage(systemName: "chevron.up.chevron.down")
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 11, weight: .semibold)
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 6
        configuration.titleLineBreakMode = .byTruncatingTail
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.font(.text14)
            return outgoing
        }
        self.configuration = configuration
        contentHorizontalAlignment = .leading
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        self.accessibilityIdentifier = accessibilityIdentifier

        showsMenuAsPrimaryAction = true
        changesSelectionAsPrimaryAction = true
        setOptions(options, selectedIndex: selectedIndex)
    }

    public required init?(coder: NSCoder) {
        self.selectedIndex = 0
        super.init(coder: coder)
    }

    /// Replaces the menu with `options` and selects `selectedIndex` without calling `onSelect`.
    public func setOptions(_ options: [String], selectedIndex: Int) {
        self.selectedIndex = selectedIndex
        menu = UIMenu(children: options.enumerated().map { index, option in
            return UIAction(title: option, state: index == selectedIndex ? .on : .off) { [weak self] _ in
                self?.select(index)
            }
        })
    }

    private func select(_ index: Int) {
        selectedIndex = index
        onSelect?(index)
    }
}
