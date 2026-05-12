//
//  MainViewController.swift
//  Example
//
//  Created by Insider on 29.08.2025.
//

import UIKit
import InsiderMobile

public final class MainViewController: UIViewController {

    private enum Section: Int, CaseIterable {
        case custom
        case core
        case reinit
        case consent
        case user
        case userAttributes
        case inapp
        case event
        case product
        case wishlist
        case contentOptimizer
    }

    @IBOutlet public weak var printLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!

    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, AnyAction> = {
        let inputButtonCell = UICollectionView.CellRegistration<InputButtonCollectionViewCell, AnyAction> {
            cell, indexPath, action in
            cell.setAction(action: action)
        }
        let buttonCell = UICollectionView.CellRegistration<ButtonCollectionViewCell, AnyAction> {
            cell, indexPath, action in
            cell.setAction(action: action)
        }
        let dataSource = UICollectionViewDiffableDataSource<Section, AnyAction>(collectionView: collectionView) {
            collectionView, indexPath, action in
            guard let section = Section(rawValue: indexPath.section) else { return nil }
            switch section {
            case .reinit, .userAttributes, .contentOptimizer:
                return collectionView.dequeueConfiguredReusableCell(using: inputButtonCell, for: indexPath, item: action)
            case .custom, .core, .consent, .user, .inapp, .event, .product, .wishlist:
                return collectionView.dequeueConfiguredReusableCell(using: buttonCell, for: indexPath, item: action)
            }
        }
        let header = UICollectionView.SupplementaryRegistration<SectionHeaderView>(
            elementKind: UICollectionView.elementKindSectionHeader) { headerView, elementKind, indexPath in
                guard let section = Section(rawValue: indexPath.section) else { return }
                let title: String
                switch section {
                case .custom:
                    headerView.configure(with: "Custom")
                case .reinit:
                    headerView.configure(with: "Reinit")
                case .core:
                    headerView.configure(with: "Core")
                case .consent:
                    headerView.configure(with: "Consent")
                case .user:
                    headerView.configure(with: "User")
                case .userAttributes:
                    headerView.configure(with: "User Attributes")
                case .inapp:
                    headerView.configure(with: "Inapp")
                case .event:
                    headerView.configure(with: "Event")
                case .product:
                    headerView.configure(with: "Product")
                case .wishlist:
                    headerView.configure(with: "Wishlist")
                case .contentOptimizer:
                    headerView.configure(with: "Content Optimizer")
                }
            }

        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: header, for: indexPath)
        }
        return dataSource
    }()

    private let coreActions: [AnyAction] = [
        AnyAction(GetInsiderIDAction()),
        AnyAction(RegisterWithQuietPermissionAction()),
        AnyAction(StartTrackingGeofenceAction()),
        AnyAction(AppCardsAction())
    ]

    private let consentActions: [AnyAction] = [
        AnyAction(SetGDPRAction(enabled: true)),
        AnyAction(SetGDPRAction(enabled: false)),
        AnyAction(SetMobileAppAccessAction(enabled: true)),
        AnyAction(SetMobileAppAccessAction(enabled: false)),
        AnyAction(EnableIDFACollectionAction(enabled: true)),
        AnyAction(EnableIDFACollectionAction(enabled: false)),
        AnyAction(EnableIPCollectionAction(enabled: true)),
        AnyAction(EnableIPCollectionAction(enabled: false)),
        AnyAction(EnableCarrierCollectionAction(enabled: true)),
        AnyAction(EnableCarrierCollectionAction(enabled: false)),
        AnyAction(EnableLocationCollectionAction(enabled: true)),
        AnyAction(EnableLocationCollectionAction(enabled: false)),
        AnyAction(SetEmailOptinAction(optin: true)),
        AnyAction(SetEmailOptinAction(optin: false)),
        AnyAction(SetPushOptinAction(optin: true)),
        AnyAction(SetPushOptinAction(optin: false)),
        AnyAction(SetLocationOptinAction(optin: true)),
        AnyAction(SetLocationOptinAction(optin: false)),
        AnyAction(SetSMSOptinAction(optin: true)),
        AnyAction(SetSMSOptinAction(optin: false)),
        AnyAction(SetWhatsAppOptinAction(optin: true)),
        AnyAction(SetWhatsAppOptinAction(optin: false))
    ]

    private let userActions: [AnyAction] = [
        AnyAction(UserLoginAction()),
        AnyAction(UserLogoutAction()),
        AnyAction(UserLogoutResettingIDAction()),
        AnyAction(UserCustomAttributesAction())
    ]

    private let userAttributesActions: [AnyAction] = [
        AnyAction(SetNameAction()),
        AnyAction(SetSurnameAction()),
        AnyAction(SetEmailAction()),
        AnyAction(SetPhoneNumberAction()),
        AnyAction(SetAgeAction()),
        AnyAction(SetGenderAction()),
        AnyAction(SetBirthdayAction()),
        AnyAction(SetLanguageAction()),
        AnyAction(SetLocaleAction()),
        AnyAction(SetFacebookIDAction()),
        AnyAction(SetTwitterIDAction())
    ]

    private let inappActions: [AnyAction] = [
        AnyAction(EnableInappMessagesAction()),
        AnyAction(DisableInappMessagesAction())
    ]

    private let wishlistActions: [AnyAction] = [
        AnyAction(VisitWishlistAction()),
        AnyAction(VisitWishlistWithCustomParametersAction()),
        AnyAction(AddItemToWishlistAction()),
        AnyAction(ItemAddedToWishlistWithCustomParametersAction()),
        AnyAction(RemoveItemFromWishlistAction()),
        AnyAction(ItemRemovedFromWishlistWithCustomParametersAction()),
        AnyAction(ClearWishlistAction()),
        AnyAction(WishlistClearedWithCustomParametersAction())
    ]

    private let productActions: [AnyAction] = [
        AnyAction(VisitProductDetailPageAction()),
        AnyAction(ItemAddedToCartAction()),
        AnyAction(ItemAddedToCartWithCustomParametersAction()),
        AnyAction(ItemRemovedFromCartAction()),
        AnyAction(ItemRemovedFromCartWithCustomParametersAction()),
        AnyAction(VisitCartPageAction()),
        AnyAction(ItemPurchasedAction()),
        AnyAction(ItemPurchasedWithCustomParametersAction()),
        AnyAction(CartClearedWithCustomParametersAction())
    ]

    private let contentOptimizerActions: [AnyAction] = [
        AnyAction(GetContentStringWithoutCacheAction()),
        AnyAction(GetContentStringAction()),
        AnyAction(GetContentBoolWithoutCacheAction()),
        AnyAction(GetContentBoolAction()),
        AnyAction(GetContentIntWithoutCacheAction()),
        AnyAction(GetContentIntAction())
    ]

    private let eventActions: [AnyAction] = [
        AnyAction(VisitHomePageAction()),
        AnyAction(VisitHomePageWithCustomParametersAction()),
        AnyAction(VisitListingPageAction(taxonomy: ["Electronics", "Smartphones", "iPhone"])),
        AnyAction(VisitListingPageWithCustomParametersAction()),
        AnyAction(VisitProductDetailPageWithCustomParametersAction()),
        AnyAction(VisitCartPageWithCustomParametersAction()),
        AnyAction(CustomEventAction())
    ]

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        DispatchQueue.main.async(execute: applySnapshot)
    }

    @objc private func clearPrintLabel() {
        printLabel.text = nil
    }

    private func setupNavigationBar() {
        let image = UIImage(
            systemName: "trash",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 14.0, weight: .semibold)
        )
        let rightBarButtonItem = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(clearPrintLabel)
        )
        rightBarButtonItem.tintColor = .textPrimary
        navigationItem.rightBarButtonItem = rightBarButtonItem

        let imageView = UIImageView(image: UIImage(named: "Primary_SolarNova"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        let titleView = UIView()
        titleView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 40),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 3.0)
        ])
        navigationItem.titleView = titleView
    }

    private func setupCollectionView() {
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = Section(rawValue: sectionIndex) else { return nil }
            switch section {
            case .custom:
                return CollectionViewLayoutProvider.Section.grid(columns: 1, height: .absolute(44))
            case .reinit:
                return CollectionViewLayoutProvider.Section.grid(columns: 1, height: .absolute(80))
            case .core, .consent:
                return CollectionViewLayoutProvider.Section.horizontal(height: .absolute(80))
            case .user, .userAttributes, .inapp, .contentOptimizer:
                return CollectionViewLayoutProvider.Section.grid(columns: 2, height: .absolute(80))
            case .wishlist, .product, .event:
                return CollectionViewLayoutProvider.Section.vertical(height: .absolute(80))
            }
        }
    }

    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyAction>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems([AnyAction(CustomAction())], toSection: .custom)
        snapshot.appendItems(coreActions, toSection: .core)
        snapshot.appendItems([AnyAction(ReinitAction())], toSection: .reinit)
        snapshot.appendItems(consentActions, toSection: .consent)
        snapshot.appendItems(userActions, toSection: .user)
        snapshot.appendItems(userAttributesActions, toSection: .userAttributes)
        snapshot.appendItems(inappActions, toSection: .inapp)
        snapshot.appendItems(eventActions, toSection: .event)
        snapshot.appendItems(productActions, toSection: .product)
        snapshot.appendItems(wishlistActions, toSection: .wishlist)
        snapshot.appendItems(contentOptimizerActions, toSection: .contentOptimizer)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
