//
//  ViewController+Extension.swift
//  SwiftDemo
//
//  Created by Zahide Sena Kurtak on 9.02.2025.
//

import UIKit

private let padding: CGFloat = 22
private let spacing: CGFloat = 15

extension ViewController {
    func setupUI() {
        
        imageView.image = UIImage(named: "insider_logo.jpeg")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        demoHeader.textAlignment = .left
        demoDescription.textAlignment = .left
        
        view.backgroundColor = .white
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = spacing
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -padding),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -padding),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -2 * padding)
        ])
        
        
        stackView.addArrangedSubviews([
            imageView, demoHeader, demoDescription,
            userAttributesLabel, setAttributeButton,
            userIdentifiersLabel, loginButton, logoutButton, signUpButton, setLocaleButton,
            eventLabel, triggerEventButton
        ])
        
        
        stackView.addArrangedSubviews([
            productLabel, createProductButton,
            cartLabel
        ])
        
        let innerStackView = UIStackView(arrangedSubviews: [addToCartButton, removeFromCartButton])
        innerStackView.axis = .horizontal
        innerStackView.spacing = spacing / 4
        innerStackView.distribution = .fillEqually
        stackView.addArrangedSubview(innerStackView)
        
        let extraStackView = UIStackView(arrangedSubviews: [cartClearButton])
        extraStackView.axis = .horizontal
        extraStackView.spacing = spacing / 4
        extraStackView.distribution = .fillEqually
        
        stackView.addArrangedSubview(extraStackView)
        
        let wishlistStackView = UIStackView(arrangedSubviews: [addedToWishlistButton, removedFromWishlistButton])
        wishlistStackView.axis = .horizontal
        wishlistStackView.spacing = spacing / 4
        wishlistStackView.distribution = .fillEqually
        
        stackView.addArrangedSubviews([wishlistLabel, wishlistStackView, wishlistClearedButton])

        
        let socialProofStackView = UIStackView(arrangedSubviews: [triggerSocialProofButton, dismissSocialProofButton])
        socialProofStackView.axis = .horizontal
        socialProofStackView.spacing = spacing / 4
        socialProofStackView.distribution = .fillEqually

        stackView.addArrangedSubviews([
            smartRecommenderLabel, getSmartDataButton,
            socialProofLabel,
            socialProofStackView,
            pageVisitMethodsLabel,
        ])
        
        let pageVisitStackView = UIStackView(arrangedSubviews: [homePageButton, listingPageButton])
        pageVisitStackView.axis = .horizontal
        pageVisitStackView.spacing = spacing / 4
        pageVisitStackView.distribution = .fillEqually
        stackView.addArrangedSubview(pageVisitStackView)
        
        let pageExtraStackView = UIStackView(arrangedSubviews: [productDetailPageButton, cartPageButton])
        pageExtraStackView.axis = .horizontal
        pageExtraStackView.spacing = spacing / 4
        pageExtraStackView.distribution = .fillEqually
        stackView.addArrangedSubview(pageExtraStackView)
        
        let pageStackViews = UIStackView(arrangedSubviews: [wishListPageButton, confirmationPageButton])
        pageStackViews.axis = .horizontal
        pageStackViews.spacing = spacing / 4
        pageStackViews.distribution = .fillEqually
        stackView.addArrangedSubview(pageStackViews)

        let gdprStackView = UIStackView(arrangedSubviews: [gdprTrueButton, gdprFalseButton])
        gdprStackView.axis = .horizontal
        gdprStackView.spacing = spacing / 4
        gdprStackView.distribution = .fillEqually
        
        let stringVariableStackView = UIStackView(arrangedSubviews: [getStringButton, getStringtWithoutCacheButton])
        stringVariableStackView.axis = .horizontal
        stringVariableStackView.spacing = spacing / 4
        stringVariableStackView.distribution = .fillEqually
        
        let booleanVariableStackView = UIStackView(arrangedSubviews: [getBooleanButton, getBooleanWithoutCacheButton])
        booleanVariableStackView.axis = .horizontal
        booleanVariableStackView.spacing = spacing / 4
        booleanVariableStackView.distribution = .fillEqually
        
        
        let numberVariableStackView = UIStackView(arrangedSubviews: [getNumberButton, getNumbertWithoutCacheButton])
        numberVariableStackView.axis = .horizontal
        numberVariableStackView.spacing = spacing / 4
        numberVariableStackView.distribution = .fillEqually
        
        stackView.addArrangedSubviews([
            gdprLabel, gdprStackView,
            messageCenterLabel, getMessageCenterButton,
            contentOptimizerLabel,
            stringVariableStackView, booleanVariableStackView, numberVariableStackView,
            reinitLabel, reinitButton,
        ])
        
        let blockStackView = UIStackView(arrangedSubviews: [enableInAppButton, disableInAppButton])
        blockStackView.axis = .horizontal
        blockStackView.spacing = spacing / 4
        blockStackView.distribution = .fillEqually
        
        stackView.addArrangedSubviews([blockInAppLabel, blockStackView])
    }
    
    static func createSectionLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }
    
    static func createLabel(text: String, fontSize: CGFloat, weight: UIFont.Weight, numberOfLines: Int = 1) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        label.numberOfLines = numberOfLines
        label.textAlignment = .center
        label.textColor = .black
        return label
    }
    
    func createActionButton(title: String, color: UIColor, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = color
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
        button.layer.cornerRadius = 8
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
}
