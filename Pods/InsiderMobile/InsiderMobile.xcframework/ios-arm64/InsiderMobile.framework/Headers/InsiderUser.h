//
//  InsiderUser.h
//
//  Created by Insider on 17.06.2019.
//  Copyright © 2019 Insider. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InsiderGenderEnum.h"
#import "InsiderIdentifiers.h"

@class InsiderUser; @interface InsiderUser : NSObject
/**
 This method allows you to set the gender attribute of your InsiderUser object.
 @discussion You need to pass InsiderGender enum object as a parameter.
 */
-(InsiderUser*(^)(InsiderGender))setGender;

/**
 This method allows you to set the birthday attribute of your InsiderUser object.
 @discussion You need to pass NSDate object as a parameter.
 */
-(InsiderUser*(^)(NSDate *))setBirthday;

/**
 This method allows you to set the name attribute of your InsiderUser object.
 @discussion You need to pass NSString object as a parameter.
 */
-(InsiderUser*(^)(NSString *))setName;

/**
 This method allows you to set the surname attribute of your InsiderUser object.
 @discussion You need to pass NSString object as a parameter.
 */
-(InsiderUser*(^)(NSString *))setSurname;

/**
 This method allows you to set the age attribute of your InsiderUser object.
 @discussion You need to pass int as a parameter.
 */
-(InsiderUser*(^)(int))setAge;

/**
 This method allows you to set email attribute of your InsiderUser object.
 @discussion You need to pass a String object as a parameter.
 */
-(InsiderUser *(^)(NSString *))setEmail;

/**
 This method allows you to set phone number attribute of your InsiderUser object.
 @discussion You need to pass a String object as a parameter.
 */
-(InsiderUser *(^)(NSString *))setPhoneNumber;

/**
 This method allows you to set the language attribute of your InsiderUser object.
 @discussion You need to pass NSString object as a parameter.
 */
-(InsiderUser*(^)(NSString *))setLanguage;

/**
This method allows you to set the locale attribute of your InsiderUser object.
@discussion You need to pass NSString object as a parameter.
*/
-(InsiderUser *(^)(NSString *))setLocale;

/**
 This method allows you to set the facebookID attribute of your InsiderUser object.
 @discussion You need to pass NSString object as a parameter.
 */
-(InsiderUser*(^)(NSString *))setFacebookID;

/**
 This method allows you to set the twitterID attribute of your InsiderUser object.
 @discussion You need to pass NSString object as a parameter.
 */
-(InsiderUser*(^)(NSString *))setTwitterID;

/**
 This method allows you to set the emailOptin attribute of your InsiderUser object.
 @discussion You need to pass bool as a parameter.
 */
-(InsiderUser*(^)(bool))setEmailOptin;

/**
 This method allows you to set the SMSOptin attribute of your InsiderUser object.
 @discussion You need to pass bool as a parameter.
 */
-(InsiderUser*(^)(bool))setSMSOptin;

/**
 This method allows you to set the pushOptin attribute of your InsiderUser object.
 @discussion You need to pass bool as a parameter.
 
 @warning If you pass false to this method, that device wont be able to receive push notifications until it set back to true.
 */
-(InsiderUser*(^)(bool))setPushOptin;

/**
 This method allows you to set the locationOptin attribute of your InsiderUser object.
 @discussion You need to pass bool as a parameter.
 
 @warning If you pass false to this method, Insider Geofencing will stop working until it set back to true.
 */
-(InsiderUser*(^)(bool))setLocationOptin;

/**
 This method allows you to set the whatsapp_optin attribute of your InsiderUser object.
 @discussion You need to pass bool as a parameter.
 
 @warning If you pass false to this method, WhatsApp Service will stop working until it set back to true.
 */
-(InsiderUser*(^)(bool))setWhatsappOptin;

/**
 This method allows you to set the login status attribute and InsiderIdentifiers of your InsiderUser object.
 @discussion You need to pass InsiderIdentifiers object.
 */
-(void)login:(InsiderIdentifiers *)insiderIdentifiers;

/**
 This method allows you to set the login status attribute and InsiderIdentifiers of your InsiderUser object and it retrieves insiderID if login (unification) is successful.
 @param insiderIdentifiers The Insider Identifier object.
 @param insiderIDResult The Insider ID data retrieved after successful login.
 @discussion You need to pass InsiderIdentifiers object.
 */
-(void)login:(InsiderIdentifiers *)insiderIdentifiers insiderIDResult:(void (^)(NSString *))insiderIDResult;

/**
 This method allows you to set the logout status attribute of your InsiderUser object.
 */
-(void)logout;

/**
 This method allows you set a NSString type attribute to your InsiderUser object.
 @discussion The first parameter is the key and the second parameter is the value of the attribute that is going to be added to the InsiderUser object.
 
 @warning Your attribute key should be all lowercase and should not include any special or non Latin characters, otherwise this attribute will be ignored. For more information check our documentation.
 */
-(InsiderUser*(^)(NSString *, NSString *))setCustomAttributeWithString;

/**
 This method allows you set a int type attribute to your InsiderUser object.
 @discussion The first parameter is the key and the second parameter is the value of the attribute that is going to be added to the InsiderUser object.
 
 @warning Your attribute key should be all lowercase and should not include any special or non Latin characters, otherwise this attribute will be ignored. For more information check our documentation.
 */
-(InsiderUser*(^)(NSString *, int))setCustomAttributeWithInt;

/**
 This method allows you set a BOOL type attribute to your InsiderUser object.
 @discussion The first parameter is the key and the second parameter is the value of the attribute that is going to be added to the InsiderUser object.
 
 @warning Your attribute key should be all lowercase and should not include any special or non Latin characters, otherwise this attribute will be ignored. For more information check our documentation.
 */
-(InsiderUser*(^)(NSString *, bool))setCustomAttributeWithBoolean;

/**
 This method allows you set a double type attribute to your InsiderUser object.
 @discussion The first parameter is the key and the second parameter is the value of the attribute that is going to be added to the InsiderUser object.
 
 @warning Your attribute key should be all lowercase and should not include any special or non Latin characters, otherwise this attribute will be ignored. For more information check our documentation.
 */
-(InsiderUser*(^)(NSString *, double))setCustomAttributeWithDouble;

/**
 This method allows you set a NSDate type attribute to your InsiderUser object.
 @discussion The first parameter is the key and the second parameter is the value of the attribute that is going to be added to the InsiderUser object.
 
 @warning Your attribute key should be all lowercase and should not include any special or non Latin characters, otherwise this attribute will be ignored. For more information check our documentation.
 */
-(InsiderUser*(^)(NSString *, NSDate *))setCustomAttributeWithDate;

/**
 This method allows you set a NSArray type attribute to your InsiderUser object.
 @discussion The first parameter is the key and the second parameter is the value of the attribute that is going to be added to the InsiderUser object.
 
 @warning Your attribute key should be all lowercase and should not include any special or non Latin characters, otherwise this attribute will be ignored. For more information check our documentation.
 */
-(InsiderUser*(^)(NSString *, NSArray *))setCustomAttributeWithArray;

/**
 This method allows you unset an attribute of your InsiderUser object.
 @discussion The first parameter is the key of youd InsiderUser attribute.
 
 @warning Your attribute key should be all lowercase and should not include any special or non Latin characters, otherwise this action will be ignored. For more information check our documentation.
 */
-(InsiderUser*(^)(NSString *))unsetCustomAttribute;

@end
