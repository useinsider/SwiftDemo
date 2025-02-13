//
//  InsiderProduct.h
//  InsiderShop
//
//  Created by Insider on 24.06.2019.
//  Copyright © 2019 Insider. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InsiderProduct; @interface InsiderProduct : NSObject

-(instancetype) init __attribute__((unavailable("init not available, use initProduct instead")));

-(bool)isProductValid;
-(id)init:(NSObject *)internalProductObject;
+(InsiderProduct *)getDummyProduct;
-(InsiderProduct*(^)(NSString *))setSaleID;

/**
This method allows you to set the productID attribute of your InsiderProduct object.
*/
-(InsiderProduct *(^)(NSString *))setProductID;

/**
This method allows you to set the name attribute of your InsiderProduct object.
*/
-(InsiderProduct*(^)(NSString *))setName;

/**
This method allows you to set the taxonomy attribute of your InsiderProduct object.
*/
-(InsiderProduct*(^)(NSArray *))setTaxonomy;


/**
This method allows you to set the setProductImageURL attribute of your InsiderProduct object.
*/
-(InsiderProduct *(^)(NSString *))setProductImageURL;

/**
 This method allows you to set the color attribute of your InsiderProduct object.
 */
-(InsiderProduct*(^)(NSString *))setColor;

/**
 This method allows you to set the voucherName attribute of your InsiderProduct object.
 */
-(InsiderProduct*(^)(NSString *))setVoucherName;

/**
 This method allows you to set the promotionName attribute of your InsiderProduct object.
 */
-(InsiderProduct*(^)(NSString *))setPromotionName;

/**
 This method allows you to set the size attribute of your InsiderProduct object.
 */
-(InsiderProduct*(^)(NSString *))setSize;

/**
 This method allows you to set the salePrice attribute of your InsiderProduct object.
 */
-(InsiderProduct*(^)(double))setSalePrice;

/**
This method allows you to set the unit price attribute of your InsiderProduct object.
*/
-(InsiderProduct *(^)(double))setUnitPrice;
    
/**
 This method allows you to set the currency attribute of your InsiderProduct object.
 */
-(InsiderProduct*(^)(NSString *))setCurrency;

/**
 This method allows you to set the shippingCost attribute of your InsiderProduct object.
 */
-(InsiderProduct*(^)(double))setShippingCost;

/**
 This method allows you to set the voucherDiscount attribute of your InsiderProduct object.
 */
-(InsiderProduct*(^)(double))setVoucherDiscount;

/**
 This method allows you to set the promotionDiscount attribute of your InsiderProduct object.
 */
-(InsiderProduct*(^)(double))setPromotionDiscount;

/**
 This method allows you to set the stock attribute of your InsiderProduct object.
 */
-(InsiderProduct*(^)(int))setStock;

/**
 This method allows you to set the stock existence attribute of your InsiderProduct object.
 */
-(InsiderProduct*(^)(BOOL))setInStock;

/**
 This method allows you to set the quantity attribute of your InsiderProduct object.
 */
-(InsiderProduct*(^)(int))setQuantity;

/**
This method allows you to set the currency attribute of your InsiderProduct object.
*/
-(InsiderProduct*(^)(NSString *))setGroupCode;

/**
This method allows you set a NSString type attribute to your InsiderProduct object.
@discussion The first parameter is the key and the second parameter is the value of the attribute that is going to be added to the InsiderProduct object.

@warning Your attribute key should be all lowercase and should not include any special or non Latin characters, otherwise this attribute will be ignored. For more information check our documentation.
*/
-(InsiderProduct*(^)(NSString *, NSString *))setCustomAttributeWithString;

/**
 This method allows you set a int type attribute to your InsiderProduct object.
 @discussion The first parameter is the key and the second parameter is the value of the attribute that is going to be added to the InsiderProduct object.
 
 @warning Your attribute key should be all lowercase and should not include any special or non Latin characters, otherwise this attribute will be ignored. For more information check our documentation.
 */
-(InsiderProduct*(^)(NSString *, int))setCustomAttributeWithInt;

/**
 This method allows you set a bool type attribute to your InsiderProduct object.
 @discussion The first parameter is the key and the second parameter is the value of the attribute that is going to be added to the InsiderProduct object.
 
 @warning Your attribute key should be all lowercase and should not include any special or non Latin characters, otherwise this attribute will be ignored. For more information check our documentation.
 */
-(InsiderProduct *(^)(NSString *, bool))setCustomAttributeWithBoolean;

/**
 This method allows you set a double type attribute to your InsiderProduct object.
 @discussion The first parameter is the key and the second parameter is the value of the attribute that is going to be added to the InsiderProduct object.
 
 @warning Your attribute key should be all lowercase and should not include any special or non Latin characters, otherwise this attribute will be ignored. For more information check our documentation.
 */
-(InsiderProduct*(^)(NSString *, double))setCustomAttributeWithDouble;

/**
 This method allows you set a NSDate type attribute to your InsiderProduct object.
 @discussion The first parameter is the key and the second parameter is the value of the attribute that is going to be added to the InsiderProduct object.
 
 @warning Your attribute key should be all lowercase and should not include any special or non Latin characters, otherwise this attribute will be ignored. For more information check our documentation.
 */
-(InsiderProduct*(^)(NSString *, NSDate *))setCustomAttributeWithDate;

/**
 This method allows you set a NSArray type attribute to your InsiderProduct object.
 @discussion The first parameter is the key and the second parameter is the value of the attribute that is going to be added to the InsiderProduct object.
 
 @warning Your attribute key should be all lowercase and should not include any special or non Latin characters, otherwise this attribute will be ignored. For more information check our documentation.
 */
-(InsiderProduct*(^)(NSString *, NSArray *))setCustomAttributeWithArray;

/**
 This method will return the summary of the InsiderProduct object.
 @discussion Summary is the dictionary which holds all the attributes of your product.
 
 @return Summary of the InsiderProduct object.
 */
-(NSMutableDictionary *)getProductSummary;

/**
 This method will return the ID of the InsiderProduct object.
 @return ID of the InsiderProduct object.
 */
-(NSString *)getProductID;

/**
 This method will return the name of the InsiderProduct object.
 @return Name of the InsiderProduct object.
 */
-(NSString *)getName;

/**
 This method will return the taxonomy(category) of the InsiderProduct object.
 @return Taxonomy(Category) of the InsiderProduct object.
 */
-(NSArray *)getTaxonomy;

/**
 This method will return the imageURL of the InsiderProduct object.
 @return ImageURL of the InsiderProduct object.
 */
-(NSString *)getImageURL;

/**
 This method will return the currency of the InsiderProduct object.
 @return Currency of the InsiderProduct object.
 */
-(NSString *)getCurrency;

/**
 This method will return the groupcode of the InsiderProduct object.
 @return GroupCode of the InsiderProduct object.
 */
-(NSString *)getGroupCode;

/**
 This method will return the unitPrice of the InsiderProduct object.
 @return UnitPrice of the InsiderProduct object.
 */
-(double)getUnitPrice;

/**
 This method will return the quantity of the InsiderProduct object.
 @return Quantity of the InsiderProduct object.
 */
-(int)getQuantity;

/**
This method will return the string customAttribute of the InsiderProduct object.
 @param key The key of the customAttribute.
 
 @return NSString customAttribute of the InsiderProduct object for the given key..
*/
-(NSString *)getCustomAttributeString:(NSString *)key;

/**
This method will return the string customAttribute of the InsiderProduct object.
 @param key The key of the customAttribute.
 
 @return int customAttribute of the InsiderProduct object for the given key..
*/
-(int)getCustomAttributeInt:(NSString *)key;

/**
This method will return the string customAttribute of the InsiderProduct object.
 @param key The key of the customAttribute.
 
 @return bool customAttribute of the InsiderProduct object for the given key..
*/
-(bool)getCustomAttributeBoolean:(NSString *)key;

/**
This method will return the string customAttribute of the InsiderProduct object.
 @param key The key of the customAttribute.
 
 @return double customAttribute of the InsiderProduct object for the given key..
*/
-(double)getCustomAttributeDouble:(NSString *)key;

/**
This method will return the string customAttribute of the InsiderProduct object.
 @param key The key of the customAttribute.
 
 @return NSDate customAttribute of the InsiderProduct object for the given key..
*/
-(NSDate *)getCustomAttributeDate:(NSString *)key;

/**
This method will return the string customAttribute of the InsiderProduct object.
 @param key The key of the customAttribute.
 
 @return NSArray customAttribute of the InsiderProduct object for the given key..
*/
-(NSArray *)getCustomAttributeArray:(NSString *)key;

@end
