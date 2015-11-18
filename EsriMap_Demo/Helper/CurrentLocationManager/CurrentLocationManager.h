//
//  CurrentLocationManager.h
//  OTW
//
//  Created by Asim Hafeez on 8/13/15.
//  Copyright (c) 2015 EnterMarkets. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@protocol LocationManagerDelegate<NSObject>
- (void)currentUserLocationUpdated:(CLLocation *)location;
@end

@interface CurrentLocationManager : CLLocation <CLLocationManagerDelegate>

@property(nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, assign) id <LocationManagerDelegate> currentLocationDelegate;


- (void)initialze;

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

@end
