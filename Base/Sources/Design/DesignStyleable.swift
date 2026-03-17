//
//  DesignStyleable.swift
//  Example
//
//  Created by Insider on 22.12.2025.
//

import UIKit

@MainActor public protocol DesignStyleable: AnyObject {

    associatedtype DesignStyleBuilder

    @discardableResult
    func style(with builder: ((DesignStyleBuilder) -> ())) -> Self
}
