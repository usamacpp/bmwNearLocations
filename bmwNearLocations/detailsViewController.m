//
//  detailsViewController.m
//  bmwNearLocations
//
//  Created by osama mourad on 1/22/16.
//  Copyright © 2016 ossama mikhail. All rights reserved.
//

#import "detailsViewController.h"

@interface detailsViewController ()

@end

@implementation detailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    NSLog(@"near location details %@", _loc.description);
    
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(_loc.Latitude, _loc.Longtiude);
    
    //add pin
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate: loc];
    [annotation setTitle: _loc.Name];
    [_map addAnnotation: annotation];
    
    //set zoom level
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(loc, 1000, 1000);
    MKCoordinateRegion adjustedRegion = [_map regionThatFits:viewRegion];
    [_map setRegion:adjustedRegion animated:NO];
    
    _lblName.text = _loc.Name;
    _lblLat.text = [NSString stringWithFormat:@"Lat. = %.2f", _loc.Latitude];
    _lblLng.text = [NSString stringWithFormat:@"Lng. = %.2f", _loc.Longtiude];
    _lblAddress.text = _loc.Address;
    _lblArriveTime.text = [NSString stringWithFormat:@"Arrival time @ %@", _loc.arriveTime];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
