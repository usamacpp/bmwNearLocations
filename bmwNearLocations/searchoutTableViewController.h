//
//  ViewController.h
//  bmwNearLocations
//
//  Created by osama mourad on 1/22/16.
//  Copyright © 2016 ossama mikhail. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIClient.h"
#import "detailsViewController.h"
#import <MBProgressHUD.h>

@interface searchoutTableViewController : UITableViewController <APIClientDelegate, nearLocationDelegate, CLLocationManagerDelegate> {
    NSArray *locs;
    UISegmentedControl *seg;
    APIClient *client;
    CLLocationManager *locm;
    CLLocation *currLocation;
}

-(IBAction)refreshList;

@end

