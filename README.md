# EsriMap_Demo
EsriMap Helper for Objective C


EsriMap Demo is a delightful helper class for iOS using Objective C for integrating EsriMap to your iOS app.


How To Get Started
Download the project. And then you need to download Esri Map.


Installation with CocoaPods

CocoaPods is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries  in your projects. ArcGis Esri Map SDK is available on https://cocoapods.org/pods/ArcGIS-Runtime-SDK-iOS (as on 18Nov 2015). If not available in this link, then you can try checking for EsriMap Sdk for ios on https://cocoapods.org/

PodFile
The podfile for this project is also available inside this project . You just need to run pod install pointing to the path where your project is.
The podfile which you need to have in your personnel should contain the following text. But I recommend you always get the latest podfile syntax from cocoapods.org

target ‘ProjectName’ do
pod 'ArcGIS-Runtime-SDK-iOS'
end


How to Use in your project
You can use the helper classes available in helper folder inside the project. There are 2 classes available namely EsriMapVIew & CurrentLocationManager. 
EsriMapVIew.h & EsriMapVIew.m are files to add EsriMap to your project.

CurrentLocationManager.h & CurrentLocationManager.m are files to add getting device location. It asks for user permission and then returns you user location.

How do you setup EsriMap on your project
You need to create a view in storyboard with its base class as EsriMapVIew. Create an outlet of this view in your class (Call it mapView).
Then you need to initialize The map and set its delegate.

[self.mapView initializeEsriMap];
self.mapView.esriMapCustomDelegate = self;


API's to be used in EsriMap
To initialize Esri Map
- (void)initializeEsriMap; 

To set custom marker pin. You just need to pass the image name
- (void)setCustomMapMarker:(NSString *)imageName; 

To centre the map based on a location
- (void)centreMapForLocation:(CLLocation *)location;

To get the street address for the location. You will get the reverse geocoded address by implementing a delegate method
- (void)getAddressForPinShownInMap:(CLLocation *)location;

ESRIMAP-DELEGATE METHOD
This returns you an address dictionary which contains details about the location you have passed for reverse geocoding 
- (void)newPinAddressObtained:(NSDictionary *)addressDictionary;


