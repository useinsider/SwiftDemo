//
//  InsiderIdentifiers.h
//
//  Created by Insider on 20.04.2020.
//  Copyright © 2020 Insider. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InsiderIdentifiers; @interface InsiderIdentifiers : NSObject
-(NSMutableDictionary *)getInsiderIdentifiers;

/**
 This method allows you set a user idendifer with the email to your InsiderIdentifiers object.
 @discussion This will allow you to unify your user among the other Insider products and will give you the posibility to reach them via different channels.
 @discussion You need to pass InsiderIdentifier object to Insider User Login method.
 */
-(InsiderIdentifiers *(^)(NSString *))addEmail;

/**
 This method allows you set a user idendifer with the phone number  to your InsiderIdentifiers object.
 @discussion This will allow you to unify your user among the other Insider products and will give you the posibility to reach them via different channels.
 @discussion You need to pass InsiderIdentifier object to Insider User Login method.
 */
-(InsiderIdentifiers *(^)(NSString *))addPhoneNumber;

/**
 This method allows you set a user idendifer with the userID to your InsiderIdentifiers object.
 @discussion This will allow you to unify your user among the other Insider products and will give you the posibility to reach them via different channels.
 @discussion You need to pass InsiderIdentifier object to Insider User Login method.
 */
-(InsiderIdentifiers *(^)(NSString *))addUserID;


/**
This method allows you set a user idendifer with the userID to your InsiderIdentifiers object.
@discussion This method allows you set a user identifier with your custom key-value pair to your InsiderIdentifiers object
@discussion You need to pass InsiderIdentifier object to Insider User Login method.
*/
-(InsiderIdentifiers *(^)(NSString *, NSString *))addCustomIdentifier;

@end

