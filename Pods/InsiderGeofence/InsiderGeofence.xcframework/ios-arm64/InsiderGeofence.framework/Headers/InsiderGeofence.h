//
//  InsiderGeofence.h
//  SDK
//
//  Created by Abdurrahman Sanli on 15.01.2023.
//  Copyright © 2023 Sezgin Demir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InsiderGeofence : NSObject

// Utility
/**
 This method allows you to enable Geofencing capability inside the SDK.
 @warning When you call this method, location permission request will be prompted to the user if there is no given location permission already.
 */
+(void)startTracking;

@end
