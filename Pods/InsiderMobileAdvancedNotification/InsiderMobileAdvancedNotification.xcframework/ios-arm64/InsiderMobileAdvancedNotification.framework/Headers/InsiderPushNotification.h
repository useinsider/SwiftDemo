//
//  InsiderPushNotification.h
//  InsiderPushNotification
//
//  Created by Insider on 3/14/17.
//  Copyright © 2017 Insider. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import <Foundation/Foundation.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface InsiderPushNotification : NSObject

+(instancetype)sharedInstance;

//Notification Service
+(void)showInsiderRichPush:(UNNotificationRequest *)request appGroup:(NSString *)appGroup nextButtonText:(NSString *)nextButtonText goToAppText:(NSString *)goToAppText success:(void (^)(UNNotificationAttachment* attachment))completionBlock;
+(void)serviceExtensionTimeWillExpire:(UNNotificationRequest *)request content:(UNMutableNotificationContent *)bestAttemptContent;


//Content Extension
+(void)interactivePushLoad:(NSString *)appGroup superView:(UIView *)superView notification:(UNNotification *)notification;
+(void)interactivePushDidReceiveNotification;
+(void)logPlaceholderClick:(UNNotificationResponse *)response;
+(NSInteger)getNumberOfSlide;
+(CGFloat)getItemWidth;
+(UIView *)getSlide:(NSInteger)index reusingView:(UIView *)view superView:(UIView *)superView;
+(NSInteger)didReceiveNotificationResponse:(NSInteger)currentIndex;
+(void)setTimeAttribution;


@property (retain, nonatomic) NSString *appGroup;
@property (retain, nonatomic) NSDictionary *userInfo;
@property (retain, nonatomic) NSDictionary *pushData;
@property (nonatomic, strong) NSArray *slides;
@property (nonatomic, assign) NSInteger pushType;

@end
