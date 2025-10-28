//
//  ViewController.swift
//  SwiftDemo
//
//  Created by Zahide Sena Kurtak on 9.02.2025.
//

import UIKit

private let padding: CGFloat = 22
private let spacing: CGFloat = 16

private let taxonomy = ["taxonomy1", "taxonomy2", "taxonomy3"]
private let insiderExampleProduct = Insider.createNewProduct(withID: "productID", name: "productName", taxonomy: taxonomy, imageURL: "imageUrl", price: 1000.5, currency: "currency")

import InsiderMobile
class ViewController: UIViewController {
    
    // MARK: - UI Elements
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    let imageView = UIImageView()
    
    let demoHeader = createLabel(text: UIStrings.demoHeader, fontSize: 20, weight: .bold)
    let demoDescription = createLabel(text: UIStrings.demoDescription, fontSize: 16, weight: .medium, numberOfLines: 0)
    
    // User Attributes
    let userAttributesLabel = createSectionLabel(title: UIStrings.UserAttributes.title)
    lazy var setAttributeButton = createActionButton(title: UIStrings.UserAttributes.setAttribute, color: .black, action: #selector(setAttributeTapped))
    
    // User Identifiers
    let userIdentifiersLabel = createSectionLabel(title: UIStrings.UserIdentifiers.title)
    lazy var loginButton = createActionButton(title: UIStrings.UserIdentifiers.login, color: .black, action: #selector(loginTapped))
    lazy var logoutButton = createActionButton(title: UIStrings.UserIdentifiers.logout, color: .systemRed, action: #selector(logoutTapped))
    lazy var signUpButton = createActionButton(title: UIStrings.UserIdentifiers.signUp, color: .systemBlue, action: #selector(signUpTapped))
    lazy var setLocaleButton = createActionButton(title: UIStrings.UserIdentifiers.setLocale, color: .black, action: #selector(setLocaleTapped))
    
    // Event
    let eventLabel = createSectionLabel(title: UIStrings.Events.title)
    lazy var triggerEventButton = createActionButton(title: UIStrings.Events.trigger, color: .black, action: #selector(triggerEventTapped))
    
    // Product
    let productLabel = createSectionLabel(title: UIStrings.Product.title)
    lazy var createProductButton = createActionButton(title: UIStrings.Product.createProduct, color: .black, action: #selector(createProductTapped))
    
    // Cart Events
    let cartLabel = createSectionLabel(title: UIStrings.CartEvents.title)
    lazy var addToCartButton = createActionButton(title: UIStrings.CartEvents.addToCart, color: .black, action: #selector(addToCartTapped))
    lazy var removeFromCartButton = createActionButton(title: UIStrings.CartEvents.removeFromCart, color: .black, action: #selector(removeFromCartTapped))
    lazy var cartClearButton = createActionButton(title: UIStrings.CartEvents.cartClear, color: .black, action: #selector(cartClearTapped))

    // Wishlist
    let wishlistLabel = createSectionLabel(title: UIStrings.WishlistEvents.title)
    lazy var addedToWishlistButton = createActionButton(title: UIStrings.WishlistEvents.addedToWishlist, color: .black, action: #selector(addToWishlistTapped))
    lazy var removedFromWishlistButton = createActionButton(title: UIStrings.WishlistEvents.removedFromWishlist, color: .black, action: #selector(removedFromWishlistTapped))
    lazy var wishlistClearedButton = createActionButton(title: UIStrings.WishlistEvents.wishlistCleared, color: .black, action: #selector(wishlistClearedTapped))

    // Smart Recommender
    let smartRecommenderLabel = createSectionLabel(title: UIStrings.SmartRecommender.title)
    lazy var getSmartDataButton = createActionButton(title: UIStrings.SmartRecommender.getSmartData, color: .black, action: #selector(getSmarRecotDataTapped))
    
    // Social Proof
    let socialProofLabel = createSectionLabel(title: UIStrings.SocialProof.title)
    lazy var triggerSocialProofButton = createActionButton(title: UIStrings.SocialProof.triggerSocialProof, color: .black, action: #selector(triggerSocailProofTapped))
    lazy var dismissSocialProofButton = createActionButton(title: UIStrings.SocialProof.dismissSocialProof, color: .black, action: #selector(dismissSocialProofTapped))
    
    // PageVisit
    let pageVisitMethodsLabel = createSectionLabel(title: UIStrings.PageVisitMethods.title)
    lazy var homePageButton = createActionButton(title: UIStrings.PageVisitMethods.homePage, color: .black, action: #selector(homePageTapped))
    lazy var listingPageButton = createActionButton(title: UIStrings.PageVisitMethods.listingPage, color: .black, action: #selector(listingPageTapped))
    lazy var productDetailPageButton = createActionButton(title: UIStrings.PageVisitMethods.productDetailPage, color: .black, action: #selector(productDetailPageTapped))
    lazy var cartPageButton = createActionButton(title: UIStrings.PageVisitMethods.cartPage, color: .black, action: #selector(cartPageTapped))
    lazy var wishListPageButton = createActionButton(title: UIStrings.PageVisitMethods.wishlistPage, color: .black, action: #selector(wishlistPageTapped))
    lazy var confirmationPageButton = createActionButton(title: UIStrings.PageVisitMethods.categoryPage, color: .black, action: #selector(confirmationPageTapped))
    
    // GDPR
    let gdprLabel = createSectionLabel(title: UIStrings.GDPR.title)
    lazy var gdprTrueButton = createActionButton(title: UIStrings.GDPR.trueValue, color: .black, action: #selector(gdprTrueTapped))
    lazy var gdprFalseButton = createActionButton(title: UIStrings.GDPR.falseValue, color: .black, action: #selector(gdprFalseTapped))
    
    // Message Center
    let messageCenterLabel = createSectionLabel(title: UIStrings.MessageCenter.title)
    lazy var getMessageCenterButton = createActionButton(title: UIStrings.MessageCenter.getMessageData, color: .black, action: #selector(getMessageDataTapped))
    
    // Content Optimizer
    let contentOptimizerLabel = createSectionLabel(title: UIStrings.ContentOptimizer.title)
    lazy var getStringButton = createActionButton(title: UIStrings.ContentOptimizer.getStringVariable, color: .black, action: #selector(getStringVariable))
    lazy var getStringtWithoutCacheButton = createActionButton(title: UIStrings.ContentOptimizer.getStringWithoutCache, color: .black, action: #selector(getStringVariableWithoutCache))
    lazy var getBooleanButton = createActionButton(title: UIStrings.ContentOptimizer.getBooleanVariable, color: .black, action: #selector(getBooleanVariable))
    lazy var getBooleanWithoutCacheButton = createActionButton(title: UIStrings.ContentOptimizer.getBooleanWithoutCache, color: .black, action: #selector(getBooleanVariableWithoutCache))
    lazy var getNumberButton = createActionButton(title: UIStrings.ContentOptimizer.getNumberVariable, color: .black, action: #selector(getIntVariable))
    lazy var getNumbertWithoutCacheButton = createActionButton(title: UIStrings.ContentOptimizer.getNumberWithoutCache, color: .black, action: #selector(getIntVariableWithoutCache))
    
    // Reinit
    let reinitLabel = createSectionLabel(title: UIStrings.Reinit.title)
    lazy var reinitButton = createActionButton(title: UIStrings.Reinit.reinit, color: .black, action: #selector(reinitParnerName))
    
    // Block Inapps
    let blockInAppLabel = createSectionLabel(title: UIStrings.BlockInApps.title)
    lazy var enableInAppButton = createActionButton(title: UIStrings.BlockInApps.enableInAppMessages, color: .black, action: #selector(enableInAppMessages))
    lazy var disableInAppButton = createActionButton(title: UIStrings.BlockInApps.disableInAppMessages, color: .black, action: #selector(disableInAppMessages))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Button Actions
extension ViewController {
    @objc private func setAttributeTapped() {
        let user = Insider.getCurrentUser()
        user?.setName()("name")
        user?.setSurname()("surname")
        user?.setGender()(InsiderGender.other)
        user?.setAge()(23)
        user?.setBirthday()(Date())
        user?.setLanguage()("language")
        user?.setFacebookID()("facebookID")
        user?.setTwitterID()("twitterID")
        user?.setEmailOptin()(true)
        user?.setSMSOptin()(true)
        user?.setWhatsappOptin()(true)
        user?.setPushOptin()(true)
        user?.setLocationOptin()(true)
        print("\(UIStrings.UserAttributes.setAttribute) tapped")
    }
    
    @objc private func loginTapped() {
        let identifiers = InsiderIdentifiers()
        identifiers
            .addEmail()("swiftdemo@useinsider.test.com")
            .addPhoneNumber()("+901234567890")
            .addUserID()("CRM-ID")
        Insider.getCurrentUser().login(identifiers)
        print("\(UIStrings.UserIdentifiers.login) tapped")
    }
    
    @objc private func logoutTapped() {
        Insider.getCurrentUser()?.logout()
        print("\(UIStrings.UserIdentifiers.logout) tapped")
    }
    
    @objc private func signUpTapped() {
        Insider.signUpConfirmation()
        print("\(UIStrings.UserIdentifiers.signUp) tapped")
    }
    
    @objc private func setLocaleTapped() {
        Insider.getCurrentUser()?.setLocale()("en_EN")
        print("\(UIStrings.UserIdentifiers.setLocale) tapped")
    }
    
    @objc private func triggerEventTapped(){
        Insider.tagEvent("eventname")?.build()
        Insider.tagEvent("eventname")?.addParameterWithInt()("key", 10).build()
        let insiderexampleEvent = Insider.tagEvent("eventname")?.addParameterWithInt()("key", 10)
        insiderexampleEvent?.build()
        print("\(UIStrings.Events.trigger) tapped")
    }
    
    @objc private func createProductTapped() {
        let taxonomy = ["taxonomy1", "taxonomy2", "taxonomy3"]
        let insiderExampleProduct = Insider.createNewProduct(withID: "productID", name: "productName", taxonomy: taxonomy, imageURL: "imageUrl", price: 1000.5, currency: "currency")
        insiderExampleProduct?.setColor()("color")
        insiderExampleProduct?.setVoucherName()("voucherName")
        insiderExampleProduct?.setVoucherDiscount()(10.5)
        insiderExampleProduct?.setPromotionName()("promotionName")
        insiderExampleProduct?.setPromotionDiscount()(10.5)
        insiderExampleProduct?.setGroupCode()("groupCode")
        insiderExampleProduct?.setSize()("size")
        insiderExampleProduct?.setSalePrice()(10.5)
        insiderExampleProduct?.setShippingCost()(10.5)
        insiderExampleProduct?.setUnitPrice()(10.5)
        insiderExampleProduct?.setQuantity()(10)
        insiderExampleProduct?.setStock()(10)
        insiderExampleProduct?.setInStock()(true)
        insiderExampleProduct?.setCustomAttributeWithInt()("key", 10)
        insiderExampleProduct?.setCustomAttributeWithString()("key", "value")
        insiderExampleProduct?.setCustomAttributeWithDouble()("key", 10.5)
        let date = Date()
        insiderExampleProduct?.setCustomAttributeWithDate()("key", date)
        let arr = ["value1", "value2", "value3"]
        insiderExampleProduct?.setCustomAttributeWithStringArray()("key", arr)
        print("\(UIStrings.Product.createProduct) tapped")
    }

    @objc private func addToCartTapped() {
        Insider.itemAddedToCart(with: insiderExampleProduct)
        print("\(UIStrings.CartEvents.addToCart) tapped")
    }
    
    @objc private func removeFromCartTapped() {
        Insider.itemRemovedFromCart(withProductID: "1030")
        print("\(UIStrings.CartEvents.removeFromCart) tapped")
    }
    
    @objc private func cartClearTapped() {
        Insider.cartCleared()
        print("\(UIStrings.CartEvents.cartClear) tapped")
    }
    
    @objc private func addToWishlistTapped() {
        Insider.itemAddedToWishlist(with: insiderExampleProduct)
        print("\(UIStrings.WishlistEvents.addedToWishlist) tapped")
    }
    
    @objc private func removedFromWishlistTapped() {
        Insider.itemRemovedFromWishlist(withProductID: insiderExampleProduct?.getID())
        print("\(UIStrings.WishlistEvents.removedFromWishlist) tapped")
    }
    
    @objc private func wishlistClearedTapped() {
        Insider.wishlistCleared()
        print("\(UIStrings.WishlistEvents.wishlistCleared) tapped")
    }
    
    @objc private func getSmarRecotDataTapped() {
        // getSmartRecommendationWithID
        Insider.getSmartRecommendation(withID: 1, locale: "en_EN", currency: "currency") { (recommendation) in
            // Handle here
        }
        
        // getSmartRecommendationWithProduct
        Insider.getSmartRecommendation(with: insiderExampleProduct, recommendationID: 1, locale: "en_EN") { (recommendation) in
            // Handle here
        }
        
        // getSmartRecommendationWithProductIDs
        Insider.getSmartRecommendation(withProductIDs: ["x", "y", "z"], recommendationID: 4, locale: "en_US", currency: "USD", smartRecommendation: {
            (recommendation) in
            // Handle here
        })
        
        // clickSmartRecommendationWithProductID
        Insider.clickSmartRecommendationProduct(withID: 1, product: insiderExampleProduct)
        print("\(UIStrings.SmartRecommender.getSmartData) tapped")
    }
    
    @objc private func triggerSocailProofTapped() {
        Insider.visitListingPage(withTaxonomy: ["taxonomy"])
        print("\(UIStrings.SocialProof.triggerSocialProof) tapped")
    }
    
    @objc private func dismissSocialProofTapped() {
        Insider.removeInapp()
        print("\(UIStrings.SocialProof.dismissSocialProof) tapped")
    }
    
    @objc private func homePageTapped() {
        Insider.visitHomepage()
        print("\(UIStrings.PageVisitMethods.homePage) tapped")
    }
    
    @objc private func listingPageTapped() {
        Insider.visitListingPage(withTaxonomy: ["taxonomy"])
        print("\(UIStrings.PageVisitMethods.listingPage) tapped")
    }
    
    @objc private func productDetailPageTapped() {
        Insider.visitProductDetailPage(with: insiderExampleProduct)
        print("\(UIStrings.PageVisitMethods.productDetailPage) tapped")
    }
    
    @objc private func cartPageTapped() {
        Insider.visitCartPage(withProducts: ["taxonomy"])
        print("\(UIStrings.PageVisitMethods.cartPage) tapped")
    }
    
    @objc private func wishlistPageTapped() {
        Insider.visitCartPage(withProducts: ["taxonomy"])
        print("\(UIStrings.PageVisitMethods.wishlistPage) tapped")
    }
    
    @objc private func confirmationPageTapped() {
        Insider.itemPurchased(withSaleID: "uniqueSaleID", product: insiderExampleProduct)
        print("\(UIStrings.PageVisitMethods.categoryPage) tapped")
    }
    
    @objc private func gdprTrueTapped() {
        Insider.setGDPRConsent(true)
        print("\(UIStrings.GDPR.trueValue) tapped")
    }
    
    @objc private func gdprFalseTapped() {
        Insider.setGDPRConsent(false)
        print("\(UIStrings.GDPR.falseValue) tapped")
    }
    
    @objc private func getMessageDataTapped() {
        let today = Date()
        var oneDayBefore = DateComponents()
        oneDayBefore.setValue(-1, for: .day)
        let yesterday = Calendar.current.date(byAdding: oneDayBefore, to: today)
        
        Insider.getMessageCenterData(withLimit: 20, start: yesterday, end: today) { (messageCenterData) in
            // Handle here
        }
        print("\(UIStrings.MessageCenter.getMessageData) tapped")
    }
    
    @objc private func getStringVariable() {
        Insider.getContentString(withName: "variableName", defaultString: "defaultValue", dataType: ContentOptimizerDataType.element)
        print("\(UIStrings.ContentOptimizer.getStringVariable) tapped")
    }
    
    @objc private func getStringVariableWithoutCache() {
        Insider.getContentStringWithoutCache("variableName", defaultString: "defaultValue", dataType: ContentOptimizerDataType.element)
        print("\(UIStrings.ContentOptimizer.getStringWithoutCache) tapped")
    }
    
    @objc private func getBooleanVariable() {
        Insider.getContentBool(withName: "variableName", defaultBool: true, dataType: ContentOptimizerDataType.element)
        print("\(UIStrings.ContentOptimizer.getBooleanVariable) tapped")
    }
    
    @objc private func getBooleanVariableWithoutCache() {
        Insider.getContentBoolWithoutCache("variableName", defaultBool: true, dataType: ContentOptimizerDataType.element)
        print("\(UIStrings.ContentOptimizer.getBooleanWithoutCache) tapped")
    }
    
    @objc private func getIntVariable() {
        Insider.getContentInt(withName: "variableName", defaultInt: 10, dataType: ContentOptimizerDataType.element)
        print("\(UIStrings.ContentOptimizer.getNumberVariable) tapped")
    }
    
    @objc private func getIntVariableWithoutCache() {
        Insider.getContentIntWithoutCache("variableName", defaultInt: 10, dataType: ContentOptimizerDataType.element)
        print("\(UIStrings.ContentOptimizer.getNumberWithoutCache) tapped")
    }
    
    @objc private func reinitParnerName() {
        Insider.reinit(withPartnerName: "newPartnerName")
        print("\(UIStrings.Reinit.reinit) tapped")
    }
    
    @objc private func enableInAppMessages() {
        Insider.enableInAppMessages()
        print("\(UIStrings.BlockInApps.enableInAppMessages) tapped")
    }
    
    @objc private func disableInAppMessages() {
        Insider.disableInAppMessages()
        print("\(UIStrings.BlockInApps.disableInAppMessages) tapped")
    }
}
