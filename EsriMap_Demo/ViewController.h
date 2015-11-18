//
//  ViewController.h
//  EsriMap_Demo
//
//  Created by Riyas Abdul Rahman on 11/16/15.
//  Copyright © 2015 Personnel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EsriMapVIew.h"

@interface ViewController : UIViewController <EsriMapCustomDelegate>
@property (strong, nonatomic) IBOutlet EsriMapVIew *mapView;
@property (strong, nonatomic) IBOutlet UILabel *userLocationLabel;

@end

