//
//  CurrentLocationManager.m
//  OTW
//
//  Created by Asim Hafeez on 8/13/15.
//  Copyright (c) 2015 EnterMarkets. All rights reserved.
//

#import "CurrentLocationManager.h"


#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_OS_9_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

@implementation CurrentLocationManager


- (void)initialze
{
    [self prepareLocationManager];
    [self getCurrentLocation];
}

- (void)getCurrentLocation
{
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER)
    {
        [self.locationManager requestAlwaysAuthorization];
    }
#endif
    
    [self.locationManager startUpdatingLocation];
}

- (void)prepareLocationManager
{
    _locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;    
    [self prepareDistanceFilters];
}


-(void)prepareDistanceFilters
{
    //self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}


- (void)startUpdatingLocation
{
    [self.locationManager startUpdatingLocation];
    
#ifdef __IPHONE_9_0
    if(IS_OS_9_OR_LATER)
    {
        //self.locationManager.allowsBackgroundLocationUpdates = YES;
    }
#endif
    
}

- (void)stopUpdatingLocation
{
    [self.locationManager stopUpdatingLocation];
    
#ifdef __IPHONE_9_0
    if(IS_OS_9_OR_LATER)
    {
        //self.locationManager.allowsBackgroundLocationUpdates = NO;
    }
#endif
    
}

#pragma mark - Location Manager delegates
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //WE ARE ASSUMING THIS METHOD GETS CALLED ONLY WHEN LOCATION GETS UPDATED
    //DUE TO WHICH WE DONT CHECK FOR LOCATION CHANGE CONDITION TO PROCEED SHOWING PIN POINT IN MAP
    //ie WE UPDATE PIN WHENEVER THIS METHOD GETS CALLED REGARDLESS OF CHECKING IF THER IS ANY CHANGE IN COORDINATES NEWLY RECEIVED WITH THE PREVIOUS
    
    CLLocation *location = [locations lastObject];
   
    if(_currentLocationDelegate != nil && [_currentLocationDelegate respondsToSelector:@selector(currentUserLocationUpdated:)])
    {
        [_currentLocationDelegate currentUserLocationUpdated:location];
    }
    
    if (UIApplication.sharedApplication.applicationState == UIApplicationStateBackground)
        NSLog(@"Location Updated in background");
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location manager error: %@", error.localizedDescription);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
        
#ifdef __IPHONE_9_0
        if(IS_OS_9_OR_LATER)
        {
            self.locationManager.allowsBackgroundLocationUpdates = YES;
        }
#endif
        
        //NSLog(@"Location is updated");
    } else if (status == kCLAuthorizationStatusDenied) {
        
        
    } else if (status == kCLAuthorizationStatusAuthorizedAlways) {

        [self.locationManager startUpdatingLocation];
        
#ifdef __IPHONE_9_0
        if(IS_OS_9_OR_LATER)
        {
            //self.locationManager.allowsBackgroundLocationUpdates = YES;
        }
#endif
        
    }
}

@end
