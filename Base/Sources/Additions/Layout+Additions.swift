//
//  UIEdgeInsets+Additions.swift
//  Example
//
//  Created by Insider on 6.11.2025.
//

import UIKit

extension UIEdgeInsets {

    public init(inset: CGFloat) {
        self.init(top: inset, left: inset, bottom: inset, right: inset)
    }

    public init(left: CGFloat) {
        self.init(top: 0, left: left, bottom: 0, right: 0)
    }
}

extension NSDirectionalEdgeInsets {

    public init(inset: CGFloat) {
        self.init(top: inset, leading: inset, bottom: inset, trailing: inset)
    }
}
