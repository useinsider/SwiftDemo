//
//  UIStrings.swift
//  SwiftDemo
//
//  Created by Zahide Sena Kurtak on 9.02.2025.
//

enum UIStrings {
    static let demoHeader = "[iOS] Insider SDK Demo"
    static let demoDescription = "This Demo contains simple methods that you can use with the Insider SDK."
    
    enum UserAttributes {
        static let title = "User Attributes"
        static let setAttribute = "Set Attribute"
    }
    
    enum UserIdentifiers {
        static let title = "User Identifiers"
        static let login = "Login"
        static let logout = "Logout"
        static let signUp = "Sign up"
        static let setLocale = "Set Locale"
    }
    
    enum Events {
        static let title = "Event"
        static let trigger = "Trigger Events"
    }
    
    enum Product {
        static let title = "Product"
        static let createProduct = "Create Product"
    }
    
    enum CartEvents {
        static let title = "Cart Events"
        static let addToCart = "Item Add To Cart"
        static let removeFromCart = "Item Remove From Cart"
        static let cartClear = "Cart Clear"
    }

    enum WishlistEvents {
        static let title = "Wishlist Events"
        static let addedToWishlist = "Item Added to Wishlist"
        static let removedFromWishlist = "Item Removed from Wishlist"
        static let wishlistCleared = "Wishlist Cleared"
    }
    
    enum SmartRecommender {
        static let title = "Smart Recommender"
        static let getSmartData = "Get Smart Recommender Data"
    }
    
    enum SocialProof {
        static let title = "Social Proof"
        static let triggerSocialProof = "Trigger Social Proof"
        static let dismissSocialProof = "Dismiss Social Proof"
    }
    
    enum PageVisitMethods {
        static let title = "Page Visit Methods"
        static let homePage = "Homepage View"
        static let listingPage = "Listing Page View"
        static let wishlistPage = "Wishlist Page View"
        static let productDetailPage = "Product Detail Page"
        static let cartPage = "Cart Page"
        static let categoryPage = "Category Page"
    }
    
    enum GDPR {
        static let title = "GDPR"
        static let trueValue = "GDPR True"
        static let falseValue = "GDPR False"
    }
    
    enum MessageCenter {
        static let title = "Message Center"
        static let getMessageData = "Get Message Center Data"
    }
    
    enum ContentOptimizer {
        static let title = "Content Optimizer"
        static let getStringVariable = "Get String"
        static let getStringWithoutCache = "Get String Without Cache"
        static let getBooleanVariable = "Get Boolean"
        static let getBooleanWithoutCache = "Get Boolean Without Cache"
        static let getNumberVariable = "Get Number"
        static let getNumberWithoutCache = "Get Number Without Cache"
    }
    
    enum ForegroundPush {
        static let title = "Foreground Push View"
        static let allowForegroundBanner = "Allow Foreground Banner"
    }
    
    enum Reinit {
        static let title = "Reinit SDK with different partner name"
        static let reinit = "Reinit"
    }
    
    enum BlockInApps {
        static let title = "Block Inapps"
        static let enableInAppMessages = "Enable InApp Messages"
        static let disableInAppMessages = "Disable InApp Messages"
    }
}
