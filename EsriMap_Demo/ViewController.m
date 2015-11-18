//
//  ViewController.m
//  EsriMap_Demo
//
//  Created by Riyas Abdul Rahman on 11/16/15.
//  Copyright © 2015 Personnel. All rights reserved.
//

#import "ViewController.h"
#import "CurrentLocationManager.h"

@interface ViewController () <LocationManagerDelegate>
@property (nonatomic, strong) CurrentLocationManager *currentLocationManagerClassObj;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _currentLocationManagerClassObj = [[CurrentLocationManager alloc]init];
    _currentLocationManagerClassObj.currentLocationDelegate = self;
    [_currentLocationManagerClassObj initialze];
    
    
    [self.mapView initializeEsriMap];
    self.mapView.esriMapCustomDelegate = self;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - EsriMapCustomDelegate Methods
- (void)newPinAddressObtained:(NSDictionary *)addressDictionary
{
    NSLog(@"SubRegion %@",[addressDictionary valueForKey:@"Subregion"]);
    NSLog(@"City %@",[addressDictionary valueForKey:@"City"]);
    NSLog(@"Address %@",[addressDictionary valueForKey:@"Address"]);
    NSLog(@"CountryCode %@",[addressDictionary valueForKey:@"CountryCode"]);
    NSLog(@"Region %@",[addressDictionary valueForKey:@"Region"]);
    
    
    self.userLocationLabel.text = [addressDictionary valueForKey:@"Address"];
    
}

#pragma mark - CurrentLocationManager Delegate Methods
- (void)currentUserLocationUpdated:(CLLocation *)location
{
    [self.mapView getAddressForPinShownInMap:self.currentLocationManagerClassObj.locationManager.location];
}
@end
