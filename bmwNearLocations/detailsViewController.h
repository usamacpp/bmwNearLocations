//
//  detailsViewController.h
//  bmwNearLocations
//
//  Created by osama mourad on 1/22/16.
//  Copyright © 2016 ossama mikhail. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "nearLocation.h"
#import <MapKit/MapKit.h>

@interface detailsViewController : UIViewController

@property (nonatomic, strong) nearLocation *loc;

@property (nonatomic, weak) IBOutlet MKMapView *map;
@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UILabel *lblLat;
@property (nonatomic, weak) IBOutlet UILabel *lblLng;
@property (nonatomic, weak) IBOutlet UILabel *lblAddress;
@property (nonatomic, weak) IBOutlet UILabel *lblArriveTime;

@end
