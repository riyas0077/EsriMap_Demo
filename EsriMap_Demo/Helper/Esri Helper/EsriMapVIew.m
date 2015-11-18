//
//  EsriMapVIew.m
//  AnaJahiz
//
//  Created by Riyas Abdul Rahman on 10/11/15.
//  Copyright © 2015 EnterMarkets. All rights reserved.
//

#import "EsriMapVIew.h"

#define MAP_TILED_LAYER_URL @"http://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer"
#define GEO_LOCATOR_URL @"http://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer"

@interface EsriMapVIew ()

@property (nonatomic, strong) AGSTiledMapServiceLayer *tiledLayer;

@end

@implementation EsriMapVIew

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)initializeEsriMap
{
    //Add a basemap tiled layer
    NSURL* url = [NSURL URLWithString:MAP_TILED_LAYER_URL];
    
    _tiledLayer = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:url];
    [self addMapLayer:_tiledLayer withName:@"Basemap Tiled Layer"];
    
    //2. Set the map view's layerDelegate
    self.layerDelegate = self;
    
    self.minScale = 100000000;
    
    self.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanModeDefault;
    self.locationDisplay.wanderExtentFactor = 0.25f; //25% of the map's viewable extent
    
    self.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanModeNavigation;
    self.locationDisplay.navigationPointHeightFactor  = 0.6f; //25% along the centerline from the bottom edge to the top edge
    
    
    self.locationDisplay.showsAccuracy = NO;
    self.locationDisplay.showsPing = NO;
    
    self.graphicsLayer = [AGSGraphicsLayer graphicsLayer];
    self.graphicsLayer.allowLayerConsolidation = YES;
    [self addMapLayer:self.graphicsLayer withName:@"Graphics Layer"];
    self.rotationAngle = 0;
    [self.marker setAngle:0];
}

#pragma mark - AGSMap delegate method
- (void)mapViewDidLoad:(AGSMapView *) mapView {
    
    [mapView.locationDisplay startDataSource];

    NSLog(@"map loaded successfully");
    [self addCustomMapPin ];
}



- (void) layerDidLoad: (AGSLayer *) layer {
    NSLog(@"Layer added successfully");
}

- (void) layer : (AGSLayer *) layer didFailToLoadwithError:(NSError *) error {
    NSLog(@"Error: %@",error);
    
    //Resubmit to load the map if failed
    [_tiledLayer resubmit];
}

#pragma mark Private Method
- (void)addCustomMapPin
{
    NSLog(@"pin created");
    [self.graphicsLayer removeAllGraphics];
}

- (AGSPoint *)agsPointFromLatitude:(double)latitude longitude:(double)longitude
{
    AGSSpatialReference *referenceGPS = [AGSSpatialReference wgs84SpatialReference];
    AGSGeometryEngine *ge = [AGSGeometryEngine defaultGeometryEngine];
    AGSPoint *graphicPoint = [AGSPoint pointWithX:longitude y:latitude spatialReference:referenceGPS];
    AGSGeometry *myPointReprojected = [ge projectGeometry:graphicPoint toSpatialReference:self.spatialReference]; //[AGSSpatialReference webMercatorSpatialReference]
    return (AGSPoint *)myPointReprojected;
}


//If you want to set custom pin in map
- (void)setCustomMapMarker:(NSString *)imageName
{
    if(!_marker)
    {
        _marker = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:imageName];
    }
    
    _marker.image = [UIImage imageNamed:imageName];
    
    AGSSimpleRenderer* mySimpleRenderer = [AGSSimpleRenderer
                                           simpleRendererWithSymbol:_marker];
    _graphicsLayer.renderer = mySimpleRenderer;
    
    self.locationDisplay.defaultSymbol =_marker;
    self.locationDisplay.courseSymbol = _marker;
    self.locationDisplay.headingSymbol = _marker;
}



//To center the pin in map area
- (void)centreMapForLocation:(CLLocation *)location
{
    AGSPoint *centrePoint = [self agsPointFromLatitude:location.coordinate.latitude
                                             longitude:location.coordinate.longitude];
    
    [self centerAtPoint:centrePoint animated:YES];
}


//To get address of the pin location -  from Esri Server
- (void)getAddressForPinShownInMap:(CLLocation *)location
{
    NSString *kGeoLocatorURL = GEO_LOCATOR_URL;
    _locator = [AGSLocator locatorWithURL:[NSURL URLWithString:kGeoLocatorURL]];
    self.locator.delegate = self;
    
    AGSPoint *mapPoint  = [self agsPointFromLatitude:location.coordinate.latitude
                                           longitude:location.coordinate.longitude];
    [self.locator addressForLocation:mapPoint maxSearchDistance:1000];
}

#pragma mark AGSLocatorDelegate Methods
//When address for the pin location is received
- (void)locator:(AGSLocator *)locator operation:(NSOperation*)op didFindAddressForLocation:(AGSAddressCandidate *)candidate
{
    if(_esriMapCustomDelegate != nil && [_esriMapCustomDelegate respondsToSelector:@selector(newPinAddressObtained:)])
    {
        [_esriMapCustomDelegate newPinAddressObtained:candidate.address];
    }
}

- (void)locator:(AGSLocator *)locator operation:(NSOperation*)op didFailAddressForLocation:(NSError *)error
{
    NSLog(@"DidFail");
}

@end
