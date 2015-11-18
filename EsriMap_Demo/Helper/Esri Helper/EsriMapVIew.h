//
//  EsriMapVIew.h
//  AnaJahiz
//
//  Created by Riyas Abdul Rahman on 10/11/15.
//  Copyright © 2015 EnterMarkets. All rights reserved.
//

#import <ArcGIS/ArcGIS.h>

@protocol EsriMapCustomDelegate<NSObject>
- (void)newPinAddressObtained:(NSDictionary *)addressDictionary;
@end


@interface EsriMapVIew : AGSMapView <AGSMapViewLayerDelegate, AGSLayerDelegate , AGSLocatorDelegate>

@property (nonatomic, strong) AGSGraphicsLayer *graphicsLayer;
@property (nonatomic, strong) AGSPictureMarkerSymbol *marker;
@property (nonatomic, strong) AGSLocator *locator;

@property (nonatomic, assign) id <EsriMapCustomDelegate> esriMapCustomDelegate;

- (void)initializeEsriMap;
- (void)setCustomMapMarker:(NSString *)imageName;
- (void)getAddressForPinShownInMap:(CLLocation *)location;
- (void)centreMapForLocation:(CLLocation *)location;

@end
