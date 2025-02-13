//
//  InsiderCallbackType.h
//  iOSDevApp
//
//  Created by Insider on 10.12.2019.
//  Copyright © 2019 insider. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface InsiderCallbackTypeEnum : NSObject
typedef NS_ENUM(NSInteger, InsiderCallbackType) {
    InsiderCallbackTypeNotificationOpen = 0,
    InsiderCallbackTypeInappButtonClick,
    InsiderCallbackTypeTempStorePurchase,
    InsiderCallbackTypeTempStoreAddedToCart,
    InsiderCallbackTypeTempStoreCustomAction,
    InsiderCallbackTypeInAppSeen,
    InsiderCallbackTypeSessionStarted
};
@end
