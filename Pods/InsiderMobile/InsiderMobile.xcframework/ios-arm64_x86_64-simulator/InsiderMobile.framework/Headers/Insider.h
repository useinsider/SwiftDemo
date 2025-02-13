//
//  ;
//  SDK
//
//  Created by Insider on 20.06.2016.
//  Copyright © 2016 Insider. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "InsiderUser.h"
#import "InsiderEvent.h"
#import "InsiderProduct.h"
#import "ContentOptimizerDataTypeEnum.h"

@interface Insider : NSObject

/**
 Initializes the Insider SDK with the given parameters.
 @discussion This method should be called under the didFinishLaunchingWithOptions method in your AppDelegate.m file.
  
 @param launchOptions The launchOptions dictionary provied from didFinishLaunchingWithOptions method.
 @param partnerName Your partnerName given partnerName to you by Insider.
 @param appGroup Your App Group variable as string. For more information check our documentation.
 */
+(void)initWithLaunchOptions:(NSDictionary *)launchOptions partnerName:(NSString *)partnerName appGroup:(NSString *)appGroup;

// Re-initialize with a new partner name when needed.
+(void)reinitWithPartnerName:(NSString *)newPartnerName NS_SWIFT_NAME(reinit(withPartnerName:));

// User
/**
 This methods returns the current InsiderUser object which you can set its attributes.
 @discussion When the Insider SDK initializes a new InsiderUser object initializes along with it.
 
 @return The current InsiderUser object.
 */
+(InsiderUser *)getCurrentUser;

/**
 This methods returns a new chainable InsiderEvent object which you can add parameters to it.
 @warning If you won't call InsiderEvent's build method in the end of the chaining this method will not function. Your event name should be all lowercase and should not include any special or non Latin characters, otherwise event will be ignored. For more information check our documentation.
 
 @return The InsiderEvent object.
 */
+(InsiderEvent *)tagEvent:(NSString *)eventName;

/**
 This method allows you to set your users consents about sharing their data with the 3rd party libraries.
 @discussion You can use this method where you ask for your users consent and pass the parameter according to their preference.
 
 @warning If you pass false to this method, Insider SDK will be freezed and stop working competely until you call this method and pass true.
 
 @param gdprConsent the consent of the user.
 */
+(void)setGDPRConsent:(bool)gdprConsent;

/**
 This method allows you to set your users' consent for sharing their data through the mobile app.
 @discussion You can use this method in areas where you collect your users' consent and pass the parameter based on their preference.

 @warning If you pass false to this method, the Insider SDK will stop collecting data and disable all mobile-specific features (e.g., push notifications, in-app templates) until you call this method and pass true.

 @param mobileConsent The consent of the user specifically for the mobile application.
 */
+(void)setMobileGDPRConsent:(bool)mobileConsent;

// Product
/**
 Initializes new InsiderProduct object which you can set its attributes.
 @discussion InsiderProdcut object can be for tracking revenue, CartReminder and SocialProof products.
 
 @warning If any parameter that is passed to this method is nill or an empty string, it will return an empty and invalid InsiderProdcut object. Note that an invalid InsiderProduct object will be ignored for any product related operations.
 
 @param productID Identifier of the product.
 @param name Name of the product.
 @param taxonomy Taxonomy(Category) of the product.
 @param imageURL ImageURL of the product.
 @param price Price of the product.
 @param currency Currency the product.
 
 @return The InsiderProduct object.
 */
+(InsiderProduct *)createNewProductWithID:(NSString *)productID name:(NSString *)name taxonomy:(NSArray *)taxonomy imageURL:(NSString *)imageURL price:(double)price currency:(NSString *)currency;

/**
 This method allows you to track your sales and revenue.
 @warning If you pass an invalid InsiderProduct object to this method, it will be ignored.
 
 @param saleID The saleID(transactionID) of the sale.
 @param product The InsiderProduct object.
 */
+(void)itemPurchasedWithSaleID:(NSString *)saleID product:(InsiderProduct *)product;

/**
 This method allows you to add an item to your cart.
 @discussion Call this method each time when the user adds a product to their cart.
 
 @warning If you pass an invalid InsiderProduct object to this method, it will be ignored.
 
 @param product The InsiderProduct object.
 */
+(void)itemAddedToCartWithProduct:(InsiderProduct *)product;

/**
 This method removes an item from the cart.
 @discussion Call this method each time when the user removes a product from their cart.
 
 @param productID The identifier of the product that is being removed from the cart.
 */
+(void)itemRemovedFromCartWithProductID:(NSString *)productID;

/**
 This method clears all the items in the cart.
 @discussion Call this method when the user clears the cart or when the last item in the cart has been removed.
 */
+(void)cartCleared;

// Message center
/**
 This method allows you get the push notification payloads sent from Insider with the given date range for that specific device.
 @discussion You can use this method to build your own notification center.
 
 @param limit The maximum number of the messages that will be returned.
 @param startDate The starting date of the message center data.
 @param endDate The ending date of the message center data.
 @param completionBlock Array of notifications that has been delivered to the device.
 */
+(void)getMessageCenterDataWithLimit:(int)limit startDate:(NSDate *)startDate endDate:(NSDate *)endDate success:(void (^)(NSArray *messageCenterData))completionBlock;

// Smart Recommendation
/**
 This method gives you smart recommendation
 
 @param recommendationID The identifer of the smart recommendation algorithm which is created from Insider dahsboard.
 @param locale The locale of the recommendation data is going to be retrieved.
 @param currency The currency which recommendation will be based on.
 @param smartRecommendation The recommendation data retrieved from Insider Recommendation Engine.
 */
+(void)getSmartRecommendationWithID:(int)recommendationID locale:(NSString *)locale currency:(NSString *)currency smartRecommendation:(void (^)(NSDictionary *recommendation))smartRecommendation;

/**
 This method gives you smart recommendation based on the products that users purchased.
 
 @param product The InsiderProduct object.
 @param recommendationID The identifer of the smart recommendation algorithm which is created from Insider dahsboard.
 @param locale The locale of the recommendation data is going to be retrieved.
 @param smartRecommendation The recommendation data retrieved from Insider Recommendation Engine.
 */
+(void)getSmartRecommendationWithProduct:(InsiderProduct *)product recommendationID:(int)recommendationID locale:(NSString *)locale smartRecommendation:(void (^)(NSDictionary *recommendation))smartRecommendation;

/**
 This method gives you smart recommendation based on the products that users purchased.
 
 @param productIDs The strings array of product ids.
 @param recommendationID The identifer of the smart recommendation algorithm which is created from Insider dahsboard.
 @param locale The locale of the recommendation data is going to be retrieved.
 @param smartRecommendation The recommendation data retrieved from Insider Recommendation Engine.
 */
+(void)getSmartRecommendationWithProductIDs:(NSArray *)productIDs recommendationID:(int)recommendationID locale:(NSString *)locale currency:(NSString *)currency smartRecommendation:(void (^)(NSDictionary *recommendation))smartRecommendation;

+(void)clickSmartRecommendationProductWithID:(int)recommendationID product:(InsiderProduct *)product;

// Content optimizer
/**
 This method allows you to retrieve the optimized NSString data.
 @warning Your device should be added as a test device via email to feed new content variables to the dashboard.
 
 @discussion Make the name variable easy to understand and descriptive, as this name will be shown in the panel. If there is no any ContentOptimizer campaign for this device, defaultVariable will be returned.
 
 @param name The the name of this element or content.
 @param defaultString The default value for this element or content.
 @param dataType This will be only visible on the dashboard to increase your user experience.
 
 @return The optimized string if there is any, otherwise the defaultString.
 */
+(NSString *)getContentStringWithName:(NSString *)name defaultString:(NSString *)defaultString dataType:(ContentOptimizerDataType)dataType;

/**
 This method allows you to retrieve the optimized bool data.
 @discussion Make the name variable easy to understand and descriptive, as this name will be shown in the panel. If there is no any ContentOptimizer campaign for this device, defaultVariable will be returned.
 
 @warning Your device should be added as a test device via email to feed new content variables to the dashboard.
 
 @param name The the name of this element or content.
 @param defaultBool The default value for this element or content.
 @param dataType This will be only visible on the dashboard to increase your user experience.
 
 @return The optimized bool if there is any, otherwise the defaultBool.
 */
+(bool)getContentBoolWithName:(NSString *)name defaultBool:(bool)defaultBool dataType:(ContentOptimizerDataType)dataType;

/**
 This method allows you to retrieve the optimized int data.
 @discussion Make the name variable easy to understand and descriptive, as this name will be shown in the panel. If there is no any ContentOptimizer campaign for this device, defaultVariable will be returned.
 
 @warning Your device should be added as a test device via email to feed new content variables to the dashboard.
 
 @param name The the name of this element or content.
 @param defaultInt The default value for this element or content.
 @param dataType This will be only visible on the dashboard to increase your user experience.
 
 @return The optimized int if there is any, otherwise the defaultInt.
 */
+(int)getContentIntWithName:(NSString *)name defaultInt:(int)defaultInt dataType:(ContentOptimizerDataType)dataType;

/**
 This method allows you to retrieve the optimized NSString data.
 @warning Your device should be added as a test device via email to feed new content variables to the dashboard.
 
 @discussion Make the name variable easy to understand and descriptive, as this name will be shown in the panel. If there is no any ContentOptimizer campaign for this device, defaultVariable will be returned.
 
 @param name The the name of this element or content.
 @param defaultString The default value for this element or content.
 @param dataType This will be only visible on the dashboard to increase your user experience.
 
 @return The optimized string if there is any, otherwise the defaultString.
 */
+(NSString *)getContentStringWithoutCache:(NSString *)name defaultString:(NSString *)defaultString dataType:(ContentOptimizerDataType)dataType;

/**
 This method allows you to retrieve the optimized bool data.
 @discussion Make the name variable easy to understand and descriptive, as this name will be shown in the panel. If there is no any ContentOptimizer campaign for this device, defaultVariable will be returned.
 
 @warning Your device should be added as a test device via email to feed new content variables to the dashboard.
 
 @param name The the name of this element or content.
 @param defaultBool The default value for this element or content.
 @param dataType This will be only visible on the dashboard to increase your user experience.
 
 @return The optimized bool if there is any, otherwise the defaultBool.
 */
+(bool)getContentBoolWithoutCache:(NSString *)name defaultBool:(bool)defaultBool dataType:(ContentOptimizerDataType)dataType;

/**
 This method allows you to retrieve the optimized int data.
 @discussion Make the name variable easy to understand and descriptive, as this name will be shown in the panel. If there is no any ContentOptimizer campaign for this device, defaultVariable will be returned.
 
 @warning Your device should be added as a test device via email to feed new content variables to the dashboard.
 
 @param name The the name of this element or content.
 @param defaultInt The default value for this element or content.
 @param dataType This will be only visible on the dashboard to increase your user experience.
 
 @return The optimized int if there is any, otherwise the defaultInt.
 */
+(int)getContentIntWithoutCache:(NSString *)name defaultInt:(int)defaultInt dataType:(ContentOptimizerDataType)dataType;

// Visit Page
/**
 This method allows you to tag your Homepage as an event.
 @discussion You can call this method each time when your HomePage visited by the user.
 */
+(void)visitHomepage;

/**
 This method allows you to tag your ListingPage as an event.
 @discussion You can call this method each time when the ListingPage visited by the user.
 
 @warning If any parameter that is passed to this method is nill or an empty string, it will be ignored.
 
 @param taxonomy Taxonomy(category) of the product.
 */
+(void)visitListingPageWithTaxonomy:(NSArray *)taxonomy;

/**
 This method allows you to tag your ProductDetailPage as an event.
 @discussion You can call this method each time when your ProductDetailPage visited by the user.
 
 @warning If you pass an invalid InsiderProduct object to this method, it will be ignored.
 
 @param product The InsiderProduct object.
 */
+(void)visitProductDetailPageWithProduct:(InsiderProduct *)product;


/**
 This method allows you to tag your CartPage as an event.
 @discussion You can call this method each time when your CartPage visited by the user by passing the products on the page.
 
 @warning If you have any invalid InsiderProduct object inside the array, it will be ignored.
 
 @param insiderProducts The array of InsiderProduct objects.
 */
+(void)visitCartPageWithProducts:(NSArray *)insiderProducts;

/**
 This method allows Insider SDK to keep the logs for the session started from the push notification.
 @discussion You need to call this method inside the application:didReceiveRemoteNotification:fetchCompletionHandler method.
 
 @param userInfo The launchOptions dictionary provided from application:didReceiveRemoteNotification:fetchCompletionHandler method.
 */
+(void)handlePushLogWithUserInfo:(NSDictionary *)userInfo;

/**
 This method allows you to add your device as a test device via email.
 @discussion You need to call this method inside the openURL:options:completionHandler method.
 
 @warning You need to add your partnerName with insider prefix to URL scheme. For more information check our documentation.
 
 @param openUrl The NSURL parameter provided from openURL:options:completionHandler method.
 */
+(void)handleUrl:(NSURL *)openUrl;

/**
 This method removes any exsisting InApps completely (including SocialProof).
 @discussion You need to call this method on view changes where you used visitProductDetailPage method.
 */
+(void)removeInapp;

/**
You can use these methods to temporarly enable / disable app templates. Do not forget to reenable templates after disabling them.
 */
+(void)reenableTemplates;
+(void)disableTemplates;

/**
You can use these methods to temporarly enable / disable inapps. */

+(void)enableInAppMessages;
+(void)disableInAppMessages;

/**
Allows visual debugging of template windows by adding a color. Do not release.
 */
+(void)enableTemplateDebugging;

/**
 This method allows you to register your method to be triggered later on when the expected action happens.
 
 @discussion You can call this method after inside the didFinishLaunchingWithOptions method.
 
 @param selector The method is going to be triggered.
 @param sender The sender object. (self)
 */
+(void)registerInsiderCallbackWithSelector:(SEL)selector sender:(id)sender;

/**
 This method allows you to get notification permission from the user.
 @discussion On iOS 12+ you have an ability to send push notifications quietly. You can enable it by passing true to this method. For more information check our documentation.
 
 @warning On below iOS 12, this method will prompt notification permission to the user regardless from the parameter that is being passed to it.
 
 @param enabled Weather deliver quietly option should be enabled or not.
 */
+(void)registerWithQuietPermission:(bool)enabled;

/**
 This method allows Insider SDK to collect device token given by the operating system.
 @discussion You need to call this method inside the application:didRegisterForRemoteNotificationsWithDeviceToken method.
 
 @warning Push notifications cannot be delivered without correct implementation of this method.
 
 @param app UIApplication provided from didRegisterForRemoteNotificationsWithDeviceToken method.
 @param inDeviceToken deviceToken NSData provided from didRegisterForRemoteNotificationsWithDeviceToken method.
 */
+(void)registerDeviceTokenWithApplication:(UIApplication*)app deviceToken:(NSData*)inDeviceToken;

/**
 This method allows Insider SDK to keep the logs for the session started from the Advanced Push Notifications (Carousel, Slider).
 @discussion You need to call this method inside the application:didReceiveRemoteNotification:fetchCompletionHandler method.
 
 @warning In order for this method to function you need to initialize the Insider SDK with appGroup.

 @param userInfo The userInfo dictionary provied from didReceiveRemoteNotification method.
 */
+(void)trackInteractiveLogWithUserInfo:(NSDictionary *)userInfo;


/**
 This method allows you to disable auto integraiton capability inside the SDK.
 
 @discussion Auto integration eases your integration by automatically retrieving the deviceToken, collecting pushLogs, handling to add test device via email.
 
 @warning Calling this method will avoid you to have all the benefits of auto integration capability. Note that you should call this method inside the didFinishLaunchingWithOptions method before initializing the InsiderSDK
 */
+(void)disableAutoIntegration;

/**
 This method allows you to enable or disable advertising ID (IDFA) collection of the SDK.
 
 @discussion This method should be called under the didFinishLaunchingWithOptions method in your AppDelegate.m file.
 
 @warning Calling this method will set advertising ID (IDFA) collection status. It is set to false by default.
 
 @param enableIDFACollection the advertising ID (IDFA) collection status.
 */
+(void)enableIDFACollection:(bool)enableIDFACollection;

/**
 This method allows you to enable or disable IP collection of the SDK.
 
 @discussion This method should be called under the didFinishLaunchingWithOptions method in your AppDelegate.m file.
 
 @warning Calling this method will set IP collection status. It is set to false by default.
 
 @param enableIpCollection the IP collection status.
 */
+(void)enableIpCollection:(bool)enableIpCollection;

/**
 This method allows you to enable or disable Carrier collection of the SDK.
 
 @discussion This method should be called under the didFinishLaunchingWithOptions method in your AppDelegate.m file.
 
 @warning Calling this method will set Carrier collection status. It is set to false by default.
 
 @param enableCarrierCollection the Carrier collection status.
 */
+(void)enableCarrierCollection:(bool)enableCarrierCollection;

/**
 This method allows you to enable or disable Location collection of the SDK.
 
 @discussion This method should be called under the didFinishLaunchingWithOptions method in your AppDelegate.m file.
 
 @warning Calling this method will set Location collection status. It is set to false by default.
 
 @param enableLocationCollection the Location collection status.
 */
+(void)enableLocationCollection:(bool)enableLocationCollection;

/**
 This method allows you to set custom regular font for Insider Inapp.
 
 @discussion This method should be called under the didFinishLaunchingWithOptions method in your AppDelegate.m file right after initializing the SDK.
 
 @warning Calling this method will set the regular font for inapps. It is set to system regular font by default.
 
 @param regularFont the regular custom font.
 */
+(void)setCustomRegularFont:(UIFont *)regularFont;

/**
 This method allows you to set custom bold font for Insider Inapp.
 
 @discussion This method should be called under the didFinishLaunchingWithOptions method in your AppDelegate.m file right after initializing the SDK.
 
 @warning Calling this method will set the bold font for inapps. It is set to system bold font by default.
 
 @param boldFont the  bold custom font.
 */
+(void)setCustomBoldFont:(UIFont *)boldFont;

/**
 This method allows you to set custom italic font for Insider Inapp.
 
 @discussion This method should be called under the didFinishLaunchingWithOptions method in your AppDelegate.m file right after initializing the SDK.
 
 @warning Calling this method will set the italic font for inapps. It is set to system italic font by default.
 
 @param italicFont the  italic custom font.
 */
+(void)setCustomItalicFont:(UIFont *)italicFont;

/**
 This method allows you to call native app review pop up.

 @discussion This method can be called anywhere inside the application.
*/
+(void)showNativeAppReview;

/**
 This method allows to handle universal link data from insider
 
 @discussion This method can be called anywhere
 */
+(void)handleUniversalLink:(NSUserActivity *)activity;


// On Premise
+(void)initWithLaunchOptions:(NSDictionary *)launchOptions partnerName:(NSString *)partnerName appGroup:(NSString *)appGroup customEndpoint:(NSString *)endpoint;

// Hybrid SDK
+(void)hybridApplicationDidBecomeActive;
+(void)setHybridSDKVersion:(NSString *)sdkVersion;
+(void)sendError:(NSException *)crashError desc:(NSString *)desc;

// Sign Up Confirmation
/**
 This method allows you to tag your Sign Up Confirmation as an event.
 @discussion You can call this method every time a sign up is created by the user.
 */
+(void)signUpConfirmation;

/**
 This method allows you to manage your foreground notifications.
 
 @param selector The method is going to be triggered.
 @param sender The sender object. (self)
 */
+(void)setForegroundPushCallback:(SEL)selector sender:(id)sender;

/**
 With this method, you can make notifications appear when the application is in foreground state.
 */
+(void)setActiveForegroundPushView;

/**
This method is a method that you should to continue other processes with insider when you use the setForegroundPushCallback method for foregorund push.
 */
+(void)triggerPushProcessWithUserInfo:(NSDictionary *)userInfo;

/**
 With this method, you can get the current Insider ID.
 */
+(NSString *)getInsiderID;

/**
 This method allows you to get the Insider ID value as soon as it changes.
 
 @discussion You should call this method inside the didFinishLaunchingWithOptions method before the Insider initWithLaunchOptions method.
 
 @param selector The method is going to be triggered.
 @param sender The sender object. (self)
 */
+(void)registerInsiderIDListenerWithSelector:(SEL)selector sender:(id)sender;


// Wishlist

/**
 This method allows you to tag your Wishlist as an event.
 @discussion You can call this method each time when your Wishlist visited by the user by passing the products on the page.
 
 @warning If you have any invalid InsiderProduct object inside the array, it will be ignored.
 
 @param insiderProducts The array of InsiderProduct objects.
 */
+(void)visitWishlistWithProducts:(NSArray *)insiderProducts;

/**
 This method allows you to add an item to your wishlist.
 @discussion Call this method each time when the user adds a product to their wishlist.
 
 @warning If you pass an invalid InsiderProduct object to this method, it will be ignored.
 
 @param product The InsiderProduct object.
 */
+(void)itemAddedToWishlistWithProduct:(InsiderProduct *)product;

/**
 This method removes an item from the wishlist.
 @discussion Call this method each time when the user removes a product from their wishlist.
 
 @param productID The identifier of the product that is being removed from the wishlist.
 */
+(void)itemRemovedFromWishlistWithProductID:(NSString *)productID;

/**
 This method clears all the items in the wishlist.
 @discussion Call this method when the user clears the wishlist or when the last item in the wishlist has been removed.
 */
+(void)wishlistCleared;


/**
 This method sets the push notification token.
 @discussion Call this method to register the push notification token that the device will use to receive notifications.
 
 @param token The push notification token string.
 */
+(void)setPushToken:(NSString *)token;

@end
